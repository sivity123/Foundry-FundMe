// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundFundMe,WithdrawFundMe} from "../../script/interactions.s.sol";
import {DeployFundMe} from "../../script/FundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
contract interactionsTest is Test {
FundMe private fundMe;
address private user  = makeAddr("SIVANESH IS A FUCKING BEAST");
uint256 private constant SEND_ETH = 20 ether;
uint256 private constant GAS_PRICE = 1;


function setUp() public{
 DeployFundMe deployFundMe= new DeployFundMe();
 fundMe = deployFundMe.run();
 vm.deal(user,SEND_ETH);

}

function testUserFundAndWithdraw() public {
FundFundMe fundFundMe = new FundFundMe{value: 10 ether}();
fundFundMe.fundFundMe(address(fundMe));

WithdrawFundMe withdrawFundMe = new WithdrawFundMe();//msg.sender of withdraw fundMe is address(this)
withdrawFundMe.withdrawFundMe(address(fundMe));

assertEq(address(fundMe).balance , 0 );


}


function testWithdrawFundMe() public {// there is problem with this test:) need to look today
address owner = fundMe.getOwner();


assertEq(address(fundMe).balance , 0 );



}
}