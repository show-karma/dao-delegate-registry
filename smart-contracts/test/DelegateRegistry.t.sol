// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/DelegateRegistry.sol";

contract DelegateRegistryTest is Test {
    DelegateRegistry public delegateRegistry;
    address public delegateAddress;
    address public tokenAddress;
    uint256 public tokenChainId;
    string public metadata;

    event DelegateAdded(address indexed delegateAddress, address indexed tokenAddress, uint256 tokenChainId, string metadata);
    event DelegateRemoved(address indexed delegateAddress, address indexed tokenAddress, uint256 tokenChainId);

    function setUp() public {
        delegateRegistry = new DelegateRegistry();
        delegateAddress = address(1);
        tokenAddress = address(1337);
        tokenChainId = 1234;
        metadata = '{"ipfsMetadata":"bafybeibzyw2agazqgvheijgmadpycuhbacqrw2uc23kxlljeglhp4hzdsy/delegate-example-0.1.json"}';
    }

    function testRegisterDelegate() public {
        vm.prank(delegateAddress);
        vm.expectEmit(true, true, true, true);
        emit DelegateRegistryTest.DelegateAdded(delegateAddress, tokenAddress, tokenChainId, metadata);

        delegateRegistry.registerDelegate(tokenAddress, tokenChainId, metadata);
        assertEq(delegateRegistry.isDelegateRegistered(delegateAddress, tokenAddress, tokenChainId), 1);
    }

    // Test that a delegate can be deregistered successfully.
    function testDeregisterDelegate() public {
        vm.startPrank(delegateAddress);
        delegateRegistry.registerDelegate(tokenAddress, tokenChainId, metadata);
        vm.expectEmit(true, true, true, true);
        emit DelegateRegistryTest.DelegateRemoved(delegateAddress, tokenAddress, tokenChainId);
        delegateRegistry.deregisterDelegate(tokenAddress, tokenChainId);
        assertEq(delegateRegistry.isDelegateRegistered(delegateAddress, tokenAddress, tokenChainId), 0);
    }
}