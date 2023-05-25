// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/DelegateRegistry.sol";

contract DelegateRegistryTest is Test {
    DelegateRegistry public delegateRegistry;
    address public adminAddress;
    address public delegateAddress;
    address public tokenAddress;
    address public providerAddress;
    uint256 public tokenChainId;
    string public metadata;

    event DelegateAdded(address indexed delegateAddress, address indexed tokenAddress, uint256 tokenChainId, string metadata);
    event DelegateRemoved(address indexed delegateAddress, address indexed tokenAddress, uint256 tokenChainId);

    function setUp() public {
        adminAddress = address(1);
        delegateRegistry = new DelegateRegistry(adminAddress);
        delegateAddress = address(2);
        providerAddress = address(3);
        tokenAddress = address(1337);
        tokenChainId = 1234;
        metadata = '{"ipfsMetadata":"bafybeibzyw2agazqgvheijgmadpycuhbacqrw2uc23kxlljeglhp4hzdsy/delegate-example-0.1.json"}';

        vm.startPrank(adminAddress);
        delegateRegistry.grantRole(delegateRegistry.PROVIDER_ROLE(), providerAddress);
        delegateRegistry.setExpiryDateForRegistryBackfill(block.timestamp+ 1 days);
        vm.stopPrank();
    }

    function testRegisterDelegate() public {
        vm.prank(delegateAddress);
        vm.expectEmit(true, true, true, true);
        emit DelegateRegistryTest.DelegateAdded(delegateAddress, tokenAddress, tokenChainId, metadata);

        delegateRegistry.registerDelegate(tokenAddress, tokenChainId, metadata);
        assertEq(delegateRegistry.isDelegateRegistered(delegateAddress, tokenAddress, tokenChainId), 1);
    }

    function testDeregisterDelegate() public {
        vm.startPrank(delegateAddress);
        delegateRegistry.registerDelegate(tokenAddress, tokenChainId, metadata);
        vm.expectEmit(true, true, true, true);
        emit DelegateRegistryTest.DelegateRemoved(delegateAddress, tokenAddress, tokenChainId);
        delegateRegistry.deregisterDelegate(tokenAddress, tokenChainId);
        assertEq(delegateRegistry.isDelegateRegistered(delegateAddress, tokenAddress, tokenChainId), 0);
    }

    function testUploadDelegate() public {
        vm.startPrank(providerAddress);
        delegateRegistry.uploadDelegate(delegateAddress, tokenAddress, tokenChainId, metadata);
        assertEq(delegateRegistry.isDelegateRegistered(delegateAddress, tokenAddress, tokenChainId), 1);
    }
}