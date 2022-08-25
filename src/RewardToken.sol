// SPDX-License-Identifier: GPL 3

pragma solidity >=0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    constructor() ERC20("Reward Token", "RT") {
        _mint(msg.sender, 1000000 * 1e18);
    }
}
