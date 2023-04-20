// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DelegateRegistry {
    struct Delegate {
        address delegateAddress;
        address tokenAddress;
        uint256 tokenChainId;
    }

    mapping(address => mapping(address => mapping(uint256 => Delegate))) public delegates;

    event DelegateAdded(address indexed delegateAddress, address tokenAddress, uint256 tokenChainId, bytes metadata);
    event DelegateRemoved(address indexed delegateAddress);
    event DelegateMetadataUpdated(address indexed delegateAddress, address tokenAddress, uint256 chainId, bytes metadata);

    function registerDelegate(address _tokenAddress, uint256 _tokenChainId, bytes memory _metadata) public {
        Delegate memory newDelegate = Delegate({
            delegateAddress: msg.sender,
            tokenAddress: _tokenAddress,
            tokenChainId: _tokenChainId
        });

        require(delegates[msg.sender][_tokenAddress][_tokenChainId].delegateAddress == address(0), "Delegate already exists for this address, token address, and chain ID");

        delegates[msg.sender][_tokenAddress][_tokenChainId] = newDelegate;

        emit DelegateAdded(msg.sender, _tokenAddress, _tokenChainId, _metadata);
    }

    function deregisterDelegate() public {
        address delegateAddress = msg.sender;
        Delegate memory removedDelegate = delegates[delegateAddress][delegateAddress][0];
        delete delegates[delegateAddress][removedDelegate.tokenAddress][removedDelegate.tokenChainId];

        emit DelegateRemoved(removedDelegate.delegateAddress);
    }
    
    function updateDelegateMetadata(address _tokenAddress, uint256 _chainId, bytes memory _metadata) public {
        Delegate storage delegateToUpdate = delegates[msg.sender][_tokenAddress][_chainId];
        require(delegateToUpdate.delegateAddress == msg.sender, "Delegate does not exist for this address, token address, and chain ID");

        emit DelegateMetadataUpdated(msg.sender, _tokenAddress, _chainId, _metadata);
    }

    function getDelegate(address _delegateAddress, address _tokenAddress, uint256 _tokenChainId) public view returns (Delegate memory) {
        return delegates[_delegateAddress][_tokenAddress][_tokenChainId];
    }
}
