// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DelegateRegistryPayable is EIP712, AccessControl  {
   bytes32 public constant PROVIDER_ROLE = keccak256("PROVIDER_ROLE");

    mapping(address => mapping(address => mapping(uint256 => uint8))) public delegates;
    mapping (address => uint) public nonces;

    uint public expiryDateForRegistryBackfill;
    uint256 public registrationFeeAmount;

    constructor(address admin) EIP712("delegate-registry", "1.0") {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    bytes32 public constant REGISTER_TYPEHASH =
        keccak256("RegisterDelegate(address tokenAddress,uint256 tokenChainId,string metadata,uint256 nonce,uint256 expiry)");
    bytes32 public constant DEREGISTER_TYPEHASH =
        keccak256("DeregisterDelegate(address tokenAddress,uint256 tokenChainId,uint256 nonce,uint256 expiry)");

    event DelegateAdded(address indexed delegateAddress, address indexed tokenAddress, uint256 tokenChainId, string metadata);
    event DelegateRemoved(address indexed delegateAddress, address indexed tokenAddress, uint256 tokenChainId);

    function setExpiryDateForRegistryBackfill(uint expiry) public onlyRole(DEFAULT_ADMIN_ROLE) {
        expiryDateForRegistryBackfill = expiry;
    }

    function setRegistrationFee(uint256 _registrationFeeAmount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        registrationFeeAmount = _registrationFeeAmount;
    }

    function registerDelegate(address tokenAddress, uint256 tokenChainId, string memory metadata) public payable {
        _payRegistrationFee();
        _registerDelegate(msg.sender, tokenAddress, tokenChainId, metadata);
    }

    function uploadDelegate(
        address delegateAddress,
        address tokenAddress,
        uint256 tokenChainId,
        string memory metadata
    ) public payable onlyRole(PROVIDER_ROLE) {
        require(block.timestamp <= expiryDateForRegistryBackfill, "RegisterDelegate: registry backfill period has expired");
        _payRegistrationFee();
        _registerDelegate(delegateAddress, tokenAddress, tokenChainId, metadata);
    }

   function registerDelegateBySig(
        address delegateAddress,
        address tokenAddress,
        uint256 tokenChainId,
        string memory metadata,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public payable virtual {
        require(block.timestamp <= expiry, "RegisterDelegate: signature expired");
        _payRegistrationFee();

        address signer = ECDSA.recover(
            _hashTypedDataV4(keccak256(abi.encode(
                REGISTER_TYPEHASH,
                tokenAddress,
                tokenChainId,
                keccak256(bytes(metadata)),
                nonce,
                expiry))),
            v,
            r,
            s
        );
        require(delegateAddress == signer, "Signer and delegate addresses don't match");
        require(nonce == nonces[signer]++, "RegisterDelegate: invalid nonce");
        _registerDelegate(signer, tokenAddress, tokenChainId, metadata);
    }

    function deregisterDelegate(address tokenAddress, uint256 tokenChainId) public {
        require(isDelegateRegistered(msg.sender, tokenAddress, tokenChainId) == 1, "Not a registered delegate");
        _deregisterDelegate(msg.sender, tokenAddress, tokenChainId);
        _refundRegistrationFee();
    }

 function deregisterDelegateBySig(
        address tokenAddress,
        uint256 tokenChainId,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        require(block.timestamp <= expiry, "DeregisterDelegate: signature expired");

        address signer = ECDSA.recover(
            _hashTypedDataV4(keccak256(abi.encode(
                DEREGISTER_TYPEHASH,
                tokenAddress,
                tokenChainId,
                nonce,
                expiry))),
            v,
            r,
            s
        );
        require(nonce == nonces[signer]++, "DeregisterDelegate: invalid nonce");
        require(isDelegateRegistered(signer, tokenAddress, tokenChainId) == 1, "Not a registered delegate");

        _deregisterDelegate(signer, tokenAddress, tokenChainId);
        _refundRegistrationFee();
    }

    function isDelegateRegistered(address delegateAddress, address tokenAddress, uint256 tokenChainId)
        public
        view
        returns (uint8 isRegistered)
    {
        return delegates[delegateAddress][tokenAddress][tokenChainId];
    }

    function _registerDelegate(
        address delegateAddress,
        address tokenAddress,
        uint256 tokenChainId,
        string memory metadata
    )
        private
    {
        delegates[delegateAddress][tokenAddress][tokenChainId] = 1;

        emit DelegateAdded(delegateAddress, tokenAddress, tokenChainId, metadata);
    }

    function _deregisterDelegate(address delegateAddress, address tokenAddress, uint256 tokenChainId) private {
        require(delegates[delegateAddress][tokenAddress][tokenChainId] != 0, "DeregisterDelegate: Already deregistered");
        delegates[delegateAddress][tokenAddress][tokenChainId] = 0;
        emit DelegateRemoved(delegateAddress, tokenAddress, tokenChainId);
    }

    function _payRegistrationFee() internal {
        require(msg.value >= registrationFeeAmount, "RegisterDelegate: insufficient fee");
        if (msg.value > registrationFeeAmount) {
            (bool success, ) = payable(msg.sender).call{value: msg.value - registrationFeeAmount}("");
            require(success, "Refund of excess fee failed");
        }
    }

    function _refundRegistrationFee() private {
        require(address(this).balance >= registrationFeeAmount, "Insufficient balance for refund");
        (bool success, ) = payable(msg.sender).call{value: registrationFeeAmount}("");
        require(success, "Refund failed");
    }
}
