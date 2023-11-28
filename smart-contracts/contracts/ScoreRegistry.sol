// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Stats} from "./ScoreStats.sol";
import {IDelegateRegistry} from "./IDelegateRegistry.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract ScoreRegistry is Ownable {
    mapping(address => mapping(address => mapping(uint256 => Stats)))
        private stats;

    IDelegateRegistry private delegateRegistry;

    constructor(IDelegateRegistry _delegateRegistry) {
        delegateRegistry = _delegateRegistry;
    }

    function setDelegateRegistry(IDelegateRegistry _delegateRegistry)
        public
        onlyOwner
    {
        delegateRegistry = _delegateRegistry;
    }

    function setStats(
        Stats calldata payload,
        address token,
        uint32 chainId
    ) public {
        require(
            isDelegateRegistered(msg.sender, token, chainId) == 1,
            "delegate is not registered"
        );

        stats[msg.sender][token][chainId] = payload;
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

    function getStats(
        address user,
        address token,
        uint256 chainId
    ) public view returns (Stats memory) {
        return stats[user][token][chainId];
    }
}
