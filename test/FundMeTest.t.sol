// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user"); // Creating a fake user address
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    // setUp always runs first
    function setUp() external {
        // us -> FundMeTest -> FundMe
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(USER, STARTING_BALANCE); // Set the balance of the user address to STARTING_BALANCE
    }

    function testMinimumDollarIsFive() public {
       assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        // assertEq(fundMe.i_owner(), msg.sender);  // -> This will not work because the sender is different that the address which deploy the contract
        assertEq(fundMe.i_owner(), msg.sender); // -> This will work because the sender is the same that the address which deploy the contract (address(this))
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
        if(block.chainid == 11155111){
            uint256 version = fundMe.getVersion();
            assertEq(version, 4); // This will give us an error because when we test a contract without specifying the network, anvil put some address
        }else if(block.chainid == 1){
            uint256 version = fundMe.getVersion();
            assertEq(version, 4); // This will give us an error because when we test a contract without specifying the network, anvil put some address
        }
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        // This operation will fail
        fundMe.fund(); // -> BUT, this will make a successful test
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next TX will be sent by USER
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}
