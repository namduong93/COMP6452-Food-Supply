// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "../src/AccessControl.sol";

contract AccessControlTest is Test {
    AccessControl accessControl;
    address owner;
    address addr1 = address(0x123);
    address addr2 = address(0x456);

    function setUp() public {
        owner = address(this);
        accessControl = new AccessControl(owner);
    }

    function testAddManager() public {
        accessControl.addManager(addr1);
        address[] memory managers = accessControl.getManagers();
        assertEq(managers[1], addr1);
    }

    function testAddManagerFail() public {
        vm.prank(addr1);
        vm.expectRevert("Unauthorized");
        accessControl.addManager(addr2);
    }

    function testAddManagerAlreadyAdded() public {
        accessControl.addManager(addr1);
        vm.expectRevert("ManagerAlreadyAdded");
        accessControl.addManager(addr1);
    }

    function testGetManagers() public {
        accessControl.addManager(addr1);
        address[] memory managers = accessControl.getManagers();
        assertEq(managers.length, 2);
        assertEq(managers[0], owner);
        assertEq(managers[1], addr1);
    }
}
