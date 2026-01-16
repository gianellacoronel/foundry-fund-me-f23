// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // setUp always runs first
    function setUp() external {
        // us -> FundMeTest -> FundMe
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
       assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        // assertEq(fundMe.i_owner(), msg.sender);  // -> This will not work because the sender is different that the address which deploy the contract
        assertEq(fundMe.i_owner(), address(this)); // -> This will work because the sender is the same that the address which deploy the contract (address(this))
    }
}
