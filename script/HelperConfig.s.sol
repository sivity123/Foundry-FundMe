// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

//hardcode for ETH/USD PriceFeeds on different chains

import {Script}  from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockAggregatorV3.sol";

contract HelperConfig is Script{

struct NetworkConfig{
address priceFeed;

}

uint8 private constant DECIMALS = 8;
int256 private constant INITIAL_ANSWER = 2000e8;

NetworkConfig public activeNetworkConfig;

function getSepoliaConfig()public pure returns (NetworkConfig memory sepoliaConfig){
    sepoliaConfig = NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});

}
function getAnvilConfig()public  returns (NetworkConfig memory AnvilConfig){
    vm.startBroadcast();
    MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS,INITIAL_ANSWER);
    vm.stopBroadcast();
    
    AnvilConfig = NetworkConfig({priceFeed:address(mockV3Aggregator)});

}

function getMainnetConfig() public pure  returns(NetworkConfig memory mainnetConfig){
    mainnetConfig = NetworkConfig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
}


constructor(){
  if (block.chainid == 11155111){
        activeNetworkConfig = getSepoliaConfig();
  }
  else if(block.chainid == 1){
    activeNetworkConfig = getMainnetConfig();
  }
  else{
    activeNetworkConfig = getAnvilConfig();
  }

}


}