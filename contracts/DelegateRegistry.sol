// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract DelegateRegistry is EIP712 {
    constructor() EIP712("delegate-registry", "1.0") { }
    struct Delegate {
        address delegateAddress;
        address tokenAddress;
        uint256 tokenChainId;
    }

    mapping(address => mapping(address => mapping(uint256 => Delegate))) public delegates;

    mapping (address => uint) public nonces;

    bytes32 public constant REGISTER_TYPEHASH =
        keccak256("RegisterDelegate(address tokenAddress,uint256 tokenChainId,string metadata,uint256 nonce,uint256 expiry)");
    bytes32 public constant DEREGISTER_TYPEHASH =
        keccak256("DeregisterDelegate(address tokenAddress,uint256 tokenChainId,uint256 nonce,uint256 expiry)");

    event DelegateAdded(address indexed delegateAddress, address tokenAddress, uint256 tokenChainId, string metadata);
    event DelegateRemoved(address indexed delegateAddress, address tokenAddress, uint256 tokenChainId);
    event DelegateMetadataUpdated(address indexed delegateAddress, address tokenAddress, uint256 tokenChainId, string metadata);

    function registerDelegate(address tokenAddress, uint256 tokenChainId, string memory metadata) public {
        _registerDelegate(msg.sender, tokenAddress, tokenChainId, metadata);
    }

    function registerDelegateBySig(
        address tokenAddress,
        uint256 tokenChainId,
        string memory metadata,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        require(block.timestamp <= expiry, "RegisterDelegate: signature expired");

        address signer = ECDSA.recover(
            _hashTypedDataV4(keccak256(abi.encode(
                REGISTER_TYPEHASH,
                tokenAddress,
                tokenChainId,
                metadata,
                nonce,
                expiry))),
            v,
            r,
            s
        );
        require(nonce == nonces[signer]++, "RegisterDelegate: invalid nonce");
        _registerDelegate(signer, tokenAddress, tokenChainId, metadata);
    }

    function deregisterDelegate(address tokenAddress, uint256 tokenChainId) public {
        _deregisterDelegate(msg.sender, tokenAddress, tokenChainId);
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
        _deregisterDelegate(signer, tokenAddress, tokenChainId);
    }

    function getDelegate(address delegateAddress, address tokenAddress, uint256 tokenChainId)
        public
        view
        returns (Delegate memory)
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
        Delegate memory newDelegate = Delegate({
            delegateAddress: delegateAddress,
            tokenAddress: tokenAddress,
            tokenChainId: tokenChainId
        });

        delegates[delegateAddress][tokenAddress][tokenChainId] = newDelegate;

        emit DelegateAdded(delegateAddress, tokenAddress, tokenChainId, metadata);
    }

    function _deregisterDelegate(address delegateAddress, address tokenAddress, uint256 tokenChainId) private {
        Delegate memory removeDelegate = delegates[delegateAddress][tokenAddress][tokenChainId];
        delete removeDelegate;
        emit DelegateRemoved(delegateAddress, tokenAddress, tokenChainId);
    }
}
