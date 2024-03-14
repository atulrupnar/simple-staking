// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleStaking {
    struct UserInfo {
        uint256 amount;
        uint256 rewardsAccured;
        uint256 lastStakedTime;
    }
    /**
        * REWARD_SHARE is representation of reward amount
        * Rewards = 86400(seconds/day) * 1000 * 1e18 stakedTokens/1e18 stakedTokens
                  = 86400000
        example: user deposits 5000 tokens for 11 days
                => 5000 * 11 * 86400 /(86400 * 1000) = 5000 * 11 / 1000 = 55 rewards
     */
    uint256 constant REWARD_SHARE = 86400000; //1 reward per day(86400 seconds) for 1000 tokens
    address public token;
    mapping(address => UserInfo) public usersInfo;
    constructor(address _token) {
        token = _token;
    }
    function stake(uint256 amount) external {
        UserInfo storage user = usersInfo[msg.sender];
        if (user.amount > 0) {
            // before multiple stake, we need to update the rewardsAccured for previous stake time
            user.rewardsAccured += user.amount * (block.timestamp - user.lastStakedTime);
            user.lastStakedTime = block.timestamp;
        }
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        user.amount += amount;
        user.lastStakedTime = block.timestamp;
    }
    function getPendingRewards(address _user) public view returns (uint256){
        UserInfo memory user = usersInfo[_user];
        uint256 rewards =  user.rewardsAccured + user.amount * (block.timestamp - user.lastStakedTime);
        return rewards/REWARD_SHARE;
    }
    function withdraw() external {
        UserInfo storage user = usersInfo[msg.sender];
        uint256 pendingRewards = getPendingRewards(msg.sender);
        IERC20(token).transfer(msg.sender, user.amount + pendingRewards);
        delete usersInfo[msg.sender];
    }
}


