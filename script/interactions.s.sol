// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe  is Script{
// ,"foundry-devops=lib/foundry-devops"


function fundFundMe(address reacentlyDeployedFundMe)public {
uint256 fund = 0.01 ether;
vm.startBroadcast();
FundMe fundMe = FundMe(payable(reacentlyDeployedFundMe));
fundMe.fund{value : fund}();
vm.stopBroadcast();

console.log("Funded the fundMe with %s",fund);
}

function run() external   {

address reacentlyDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);

fundFundMe(reacentlyDeployedFundMe);

}

constructor()payable{

}

}



contract WithdrawFundMe is Script {
address private owner;

function withdrawFundMe(address reacentlyDeployedFundMe)public {

FundMe fundMe = FundMe(payable(reacentlyDeployedFundMe));//msg.sender will be `address(this)`
address ownerOfFundMe = fundMe.getOwner();
uint256 balance = address(fundMe).balance;
vm.prank(ownerOfFundMe);
fundMe.cheaperWithdraw();//msg.sender will be `address(this)`

console.log("Amount withdrawn : %s",balance);
}


function run() external   {

address reacentlyDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
vm.startBroadcast();
withdrawFundMe(reacentlyDeployedFundMe);
vm.stopBroadcast();


}


constructor()payable{

}


}