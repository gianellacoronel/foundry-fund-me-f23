// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

contract FundMeTest is Test {
    uint256 number = 1;

    // setUp always runs first
    function setUp() external {
        number = 2;
    }

    function testDemo() public {
        assertEq(number, 2);
    }
}
