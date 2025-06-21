//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from 'forge-std/Test.sol';
import {TipJar} from '../src/TipJar.sol';

contract TipJarTest is Test {

    address public owner;
    address niravModi; //test dummy addresses
    address beenLaiden;
    TipJar tipJar;

    function setUp() external {

       owner = address(this);
       niravModi = address(1); //creating dummy accounts;
       beenLaiden = address(2); //this means a 20 byte address that is 0x2
       tipJar = new TipJar(); // 

       vm.deal(niravModi, 10 ether); //a foundry cheatcode that sets dummy account balance
       vm.deal(beenLaiden, 1 ether);
    }

    //the convention of keeping function names as elaborate as possible in test contracts!
    function testDonateIncreasesBalanceAndRecordDonations() public {
        vm.prank(niravModi); //pretend next tx is sent by niravModi
        tipJar.donate{value: 1 ether}(); //because donate function is payable

        assertEq(address(tipJar).balance, 1 ether);
        assertEq(tipJar.viewBalance(), 1 ether); //integrated testing
    }

    function testReceiveFunctionWorks() public {
        vm.prank(beenLaiden);
        (bool success, ) = address(tipJar).call{value: 1 ether}("");
        require(success);

        assertEq(address(tipJar).balance, 1 ether);
    }

    function testIfZeroETHwasSent() public {
        vm.prank(niravModi);
        vm.expectRevert();
        
        tipJar.donate{value: 0 ether}();
    }

    function testWithdrawalOnlyByOwner() public {
        vm.prank(niravModi); //first lets send something to the tipJar contract
        tipJar.donate{value: 5 ether}();

        vm.prank(beenLaiden); //now let non owner try to withdraw
        vm.expectRevert();
        // tipJar.withdraw{value: 2 ether}(); this is wrong syntax since withdraw isnt payable
        tipJar.withdraw(2 ether);

        //now withdraw as owner
        uint ownerBalanceBefore = address(this).balance;
        tipJar.withdraw(1 ether);
        uint ownerBalanceAfter = address(this).balance;

        assertEq(ownerBalanceAfter - ownerBalanceBefore, 1 ether);
        assertEq(address(tipJar).balance, 4 ether);
    }

    receive() external payable {} 
}