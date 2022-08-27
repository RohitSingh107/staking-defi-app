// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../script/HelperConfig.sol";
import "../src/Staking.sol";
import "../src/RewardToken.sol";

contract StakingTest is Test {
    Staking public stakingContract;
    RewardToken public rewardToken;
    uint256 public constant AMOUNT = 100000e18;
    uint256 public constant SECONDS_IN_A_DAY = 86400;
    uint256 public constant SECONDS_IN_A_YEAR = 31449600;
    address public constant DEPLOYER =
        0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    function setUp() public {
        rewardToken = new RewardToken();
        address rt = address(rewardToken);
        stakingContract = new Staking(rt, rt);
    }

    function testConstructor() public {
        address response = address(stakingContract.s_rewardToken());
        assertEq(response, address(rewardToken));
    }

    function testRewardPerToken() public {
        rewardToken.approve(address(stakingContract), AMOUNT);
        stakingContract.stake(AMOUNT);

        skip(SECONDS_IN_A_DAY);
        vm.roll(block.number + 1);

        uint256 reward = stakingContract.rewardPerToken();
        uint256 expectedReward = 86;
        assertEq(reward, expectedReward);

        skip(SECONDS_IN_A_YEAR);
        vm.roll(block.number + 1);

        reward = stakingContract.rewardPerToken();
        expectedReward = 31536;
        assertEq(reward, expectedReward);
    }

    function testStake() public {
        rewardToken.approve(address(stakingContract), AMOUNT);
        stakingContract.stake(AMOUNT);

        skip(SECONDS_IN_A_DAY);
        vm.roll(block.number + 1);

        uint256 earned = stakingContract.earned(DEPLOYER);
        uint256 expectedEarned = 8600000;
        assertEq(earned, expectedEarned);
    }

    function testWithdraw() public {
        rewardToken.approve(address(stakingContract), AMOUNT);
        stakingContract.stake(AMOUNT);

        skip(SECONDS_IN_A_DAY);
        vm.roll(block.number + 1);

        uint256 balanceBefore = rewardToken.balanceOf(DEPLOYER);
        stakingContract.withdraw(AMOUNT);
        uint256 balanceAfter = rewardToken.balanceOf(DEPLOYER);
        uint256 _earned = stakingContract.earned(DEPLOYER);
        uint256 expectedEarned = 8600000;
        assertEq(expectedEarned, _earned);
        assertEq(balanceBefore + AMOUNT, balanceAfter);
    }

    function testClaimReward() public {
        rewardToken.approve(address(stakingContract), AMOUNT);
        stakingContract.stake(AMOUNT);

        skip(SECONDS_IN_A_DAY);
        vm.roll(block.number + 1);

        uint256 _earned = stakingContract.earned(DEPLOYER);

        uint256 balanceBefore = rewardToken.balanceOf(DEPLOYER);
        stakingContract.claimReward();
        uint256 balanceAfter = rewardToken.balanceOf(DEPLOYER);
        assertEq(balanceBefore + _earned, balanceAfter);
    }
}
