// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";

import {DeployFundMe} from "../../script/FundMe.s.sol";

contract FundMeTest is Test{
uint8 num = 2;
 FundMe fundme;

 address private User = makeAddr("Sivanesh is a fucking beast");
 uint256 private constant SEND_ETH = 20 ether;
 uint256 private constant GAS_PRICE = 1;

function setUp()external{
DeployFundMe deployFundMe = new DeployFundMe();
fundme = deployFundMe.run();
vm.deal(User,SEND_ETH);

}
function testNum() public view{
    assertEq(fundme.MINIMUM_USD(),5e18);
    console.log("Minimum doller is indeed 5e18");
}
function testOwner() public view{
    console.log(fundme.getOwner());
    console.log(msg.sender);
    console.log(address(this));
   


    assertEq(fundme.getOwner(),msg.sender);
}

function testPriceFeedVersionIsAccurate() public view{
console.log(fundme.getVersion());
assertEq(fundme.getVersion(),4);
assertEq(uint256(2*10**18), uint256(2e18));


}

modifier funded() {
     vm.prank(User);//this will prank that the next very transaction likely to make by this address, not address(this) for function call, because its got pranked
    fundme.fund{value: SEND_ETH}();//we are going to check that the updated value in a data structure align with data we are sending to the fund.
    _;

}

function testFundRevertWorks() public {
    vm.expectRevert();//this line expects the next line to revert , making sure that revert statments works as intented
    fundme.fund();

}


function testFundUpdatesFundedDataStructure() public funded {

    uint256 funds = fundme.getFunderFunds(User);
    assertEq(funds, 20e18);

}


function testFunderIsInArray() public funded() {
   

    address funder = fundme.getFunder(0);
    assertEq(User, funder);

}

function testOnlyOwnerCanWithdraw()public funded{
    vm.expectRevert();//expectRevert also expects the next functional call to revert something
    vm.prank(User);
    fundme.withdraw();
}


function testFundmeTransferEntireBalance() public funded{
    //arrange
    uint256 startingGas = gasleft();
    uint256 startingOwnerBalance = fundme.getOwner().balance;
    uint256 startingContractBalnce = address(fundme).balance;
    //act

    vm.txGasPrice(GAS_PRICE);
    
    vm.prank(fundme.getOwner());
    fundme.withdraw();//This calling withdraw function from owner indeed cost some gas and owner should pay it 
    //assert
    uint256 endingOwnerBalance = fundme.getOwner().balance;
    uint256 endingContractBalance = address(fundme).balance;
    assertEq(endingContractBalance, 0);
    assertEq(startingOwnerBalance+startingContractBalnce,endingOwnerBalance);
    uint256 endingGas = gasleft();
    uint256 gasUsed = (startingGas - endingGas)*tx.gasprice;
    console.log(gasUsed);


}

function testManyFundersWithdraw() public funded{
//Arrange
uint256 numberOfFunders = 10;
uint160 startingFunderIndex = 1;
for (uint160 index = startingFunderIndex;index < numberOfFunders; index++) {

    hoax(address(index),SEND_ETH);
    fundme.fund{value: SEND_ETH}();
    
}

uint256 startingContractBalance = address(fundme).balance;
uint256 startingOwnerBalance = fundme.getOwner().balance;


//act
vm.startPrank(fundme.getOwner());
fundme.withdraw();
vm.stopPrank();

//assert
uint256 endingOwnerBalance = fundme.getOwner().balance;
uint256 endingContractBalance = address(fundme).balance;
assertEq(endingContractBalance,0);
assertEq( startingContractBalance + startingOwnerBalance , endingOwnerBalance);



}


function testManyFundersCheeperWithdraw() public funded{
//Arrange
uint256 numberOfFunders = 10;
uint160 startingFunderIndex = 1;
for (uint160 index = startingFunderIndex;index < numberOfFunders; index++) {

    hoax(address(index),SEND_ETH);
    fundme.fund{value: SEND_ETH}();
    
}

uint256 startingContractBalance = address(fundme).balance;
uint256 startingOwnerBalance = fundme.getOwner().balance;


//act
vm.startPrank(fundme.getOwner());
fundme.cheaperWithdraw();
vm.stopPrank();

//assert
uint256 endingOwnerBalance = fundme.getOwner().balance;
uint256 endingContractBalance = address(fundme).balance;
assertEq(endingContractBalance,0);
assertEq( startingContractBalance + startingOwnerBalance , endingOwnerBalance);



}



}

