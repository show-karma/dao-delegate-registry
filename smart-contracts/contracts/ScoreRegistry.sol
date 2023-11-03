// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Stats} from "./Common.sol";
import {IDelegateRegistry} from "./IDelegateRegistry.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ScoreRegistry is
    Initializable,
    OwnableUpgradeable,
    EIP712Upgradeable
{
    mapping(address => uint) private whitelist;
    mapping(address => mapping(address => mapping(uint256 => Stats)))
        private stats;

    IDelegateRegistry public delegateRegistry;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(IDelegateRegistry delegateRegistry) public initializer {
        _owner = msg.sender;
        __Ownable_init();
    }

    function setStats(Stats memory payload) public {
        require(
            whitelist[msg.sender] == 1,
            "ReferrerResolver: sender is not whitelisted"
        );
        require(
            delegateRegistry.isDelegateRegistered(msg.sender) != address(0),
            "ReferrerResolver: delegate is not registered"
        );

        stats[user][token][chainId] = payload;
    }

    function isDelegateRegistered(address user) public view returns (address) {
        return delegateRegistry.isDelegateRegistered(user);
    }

    function setWhitelist(address user, uint status) public onlyOwner {
        whitelist[user] = status;
    }

    function getWhitelist(address user) public view onlyOwner returns (uint) {
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
