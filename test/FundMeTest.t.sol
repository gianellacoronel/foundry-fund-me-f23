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

    // What can we do to work with addresses outside our system?
    // 1. Unit
    //    - Testing a specific part of our code
    // 2. Integration
    //    - Testing how our code works with other parts of our code
    // 3. Forked
    //    - Testing our code on a simulated real environment
    // 4. Staging
    //    - Testing our code on a real environment that is not prod

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4); // This will give us an error because when we test a contract without specifying the network, anvil put some address
    }
}
