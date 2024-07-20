// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        //这是一个合约调用，向指定的 FundMe 合约地址发送资金.payable 关键字允许发送以太币。
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment( //aquire the most recent deployment address of contract
            "FundMe",
            block.chainid
        );
        fundFundMe(mostRecentlyDeployed); //using mostRecentlyDeployed as a parameters to call the fundFundMEe
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment( //aquire the most recent deployment address of contract
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        WithdrawFundMe(mostRecentlyDeployed); //using mostRecentlyDeployed as a parameters to call the fundFundMEe
        vm.stopBroadcast();
    }
}
