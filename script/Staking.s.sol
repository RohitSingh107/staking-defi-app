// SPDX-License-Identifier: GPL 3

pragma solidity >=0.8.13;

import "forge-std/Script.sol";
import "./HelperConfig.sol";
import "../src/Staking.sol";
import "../src/RewardToken.sol";

// import "forge-std/console.sol";

contract DeployStaking is Script, HelperConfig {
    function run() external {
        address rt = address(new RewardToken());

        vm.startBroadcast();

        console.log("Deploying Staking...");
        new Staking(rt, rt);

        vm.stopBroadcast();
    }
}
