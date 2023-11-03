// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract IDelegateRegistry is EIP712, AccessControl {
    function isDelegateRegistered(
        address delegateAddress,
        address tokenAddress,
        uint256 tokenChainId
    ) external view returns (uint8 isRegistered);
}
