// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Stats} from "./Common.sol";
import {IDelegateRegistry} from "./IDelegateRegistry.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ScoreRegistry is Initializable, OwnableUpgradeable, EIP712Upgradeable {
    mapping(address => uint256) private whitelist;
    mapping(address => mapping(address => mapping(uint256 => Stats)))
        private stats;

    IDelegateRegistry private delegateRegistry;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(IDelegateRegistry _delegateRegistry)
        public
        initializer
    {
        delegateRegistry = _delegateRegistry;
        __Ownable_init();
    }

    function setDelegateRegistry(IDelegateRegistry _delegateRegistry)
        public
        onlyOwner
    {
        delegateRegistry = _delegateRegistry;
    }

    function setStats(
        Stats calldata payload,
        address user,
        address token,
        uint32 chainId
    ) public {
        
        require(whitelist[msg.sender] == 1, "sender is not whitelisted");
        require(
            isDelegateRegistered(user, token, chainId) == 1,
            "delegate is not registered"
        );

        stats[user][token][chainId] = payload;
    }

    function isDelegateRegistered(
        address user,
        address token,
        uint32 chainId
    ) public view returns (uint8 isRegistered) {
        isRegistered = delegateRegistry.isDelegateRegistered(
            user,
            token,
            chainId
        );
        return isRegistered;
    }

    function setWhitelist(address user, uint256 status) public onlyOwner {
        whitelist[user] = status;
    }

    function getWhitelist(address user) public view returns (uint256) {
        return whitelist[user];
    }

    function getStats(
        address user,
        address token,
        uint256 chainId
    ) public view returns (Stats memory) {
        return stats[user][token][chainId];
    }
}
