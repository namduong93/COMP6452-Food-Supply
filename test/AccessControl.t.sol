// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {AccessControl} from "../src/AccessControl.sol";

contract AccessControlTest is StdCheats, Test {
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

    function testAddManagerUnauthorized() public {
        vm.prank(addr1);
        vm.expectRevert(abi.encodeWithSelector(AccessControl.Unauthorized.selector, addr1));
        accessControl.addManager(addr2);
    }

    function testAddManagerAlreadyAdded() public {
        accessControl.addManager(addr1);
        vm.expectRevert(abi.encodeWithSelector(AccessControl.ManagerAlreadyAdded.selector, addr1));
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
