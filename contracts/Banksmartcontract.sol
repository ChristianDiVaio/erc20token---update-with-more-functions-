// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./erc20token.sol";


    // * // NOTES //
    //  * calculate StakeReward is used to calculate how much a user should be rewarded for their stakes
    //  * and the duration the stake has been active  
    // First calculate how long the stake has been active
    // Use current seconds since epoch - the seconds since epoch the stake was made
    // The output will be duration in SECONDS ,
    // We will reward the user 0.1% per Hour So thats 0.1% per 3600 seconds
    // the alghoritm is  seconds = block.timestamp - stake seconds (block.timestap - _stake.since)
    // hours = Seconds / 3600 (seconds /3600) 3600 is an variable in Solidity names hours
    // we then multiply each token by the hours staked , then divide by the rewardPerHour rate 
    // return (((block.timestamp - _current_stake.since) / 1 hours) * _current_stake.amount) / rewardPerHour;
      
contract Banksmartcontract {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /*--------------- State Variables --------------- */
    
    IERC20 public rewardsToken;
    IERC20 public stakingToken;
    uint256 totalSupply = 10000 * 1e18;
    uint256 public periodFinish = 0;
    uint256 public rewardRate = 0;
    uint256 public rewardsDuration = 7 days;
    uint256 public rewardPerTokenStored;

    uint256 private duration = 60 seconds; // No deposit/withdraw for 60 seconds after the staking.
    uint256 private poolOneTime = 86400 seconds; // lock period for pool one.(1day)
    uint256 private poolTwoTime = 172800 seconds; // lock period for pool two.(2days)
    uint256 private poolThreeTime = 259200 seconds; // lock period for pool three;(3days)
    uint256 private totalStakedTime;


    /* ========== Events ========== */
    
    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardsDurationUpdated(uint256 newDuration);
    event Recovered(address token, uint256 amount);

    /* ========== Mapping ========== */

    mapping(address => uint256) public rewardsBalance ;
    mapping(address => uint256) public stakingBalance;    
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
}

    /*--------------- Constructor--------------- */

    constructor(Banksmartcontract) public {
        _owner = msg.sender;
        _token = token;
        _rewardsToken = rewardsToken;
        _stakingToken = stakingToken;
    }

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    } 

    public Owned(_owner) {
        rewardsToken = IERC20(_rewardsToken);
        stakingToken = IERC20(_stakingToken);
        rewardsDistribution = _rewardsDistribution;
    }

    /*--------------- Functions --------------- */

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return block.timestamp < periodFinish ? block.timestamp : periodFinish;
    }

    function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.+(
                lastTimeRewardApplicable().-(lastUpdateTime).*(rewardRate).*(1e18)./(_totalSupply)
            );
    }

    function earned(address account) public view returns (uint256) {
        return _balances[account].*(rewardPerToken().-(userRewardPerTokenPaid[account]))./(1e18).+(rewards[account]);
    }

    function getRewardForDuration() external view returns (uint256) {
        return rewardRate.*(rewardsDuration);
    }

    /* Functions for staking, withdraw, getReward */
    // -------- Pool 1 staking --------- 

    function stake(uint _amount) external updateReward(msg.sender) {
        require(amount > 0); // "Cannot stake 0"
        _totalSupply = _totalSupply.+(amount);
        _balances[msg.sender] = _balances[msg.sender].+(amount);
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

     // -------- Pool 2 staking --------- 

      function stake(uint _amount) external updateReward(msg.sender) {
        require(amount > 0); // "Cannot stake 0"
        _totalSupply = _totalSupply.+(amount);
        _balances[msg.sender] = _balances[msg.sender].+(amount);
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

     // -------- Pool 3 staking --------- 

      function stake(uint _amount) external updateReward(msg.sender) {
        require(amount > 0); // "Cannot stake 0"
        _totalSupply = _totalSupply.+(amount);
        _balances[msg.sender] = _balances[msg.sender].+(amount);
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }


    // -------- Pool 1 withdraw --------- 

    function withdraw(uint256 amount) public updateReward(msg.sender) {
        require(amount > 0);  // "Cannot withdraw 0"
        _totalSupply = _totalSupply.-(amount);
        _balances[msg.sender] = _balances[msg.sender].-(amount);
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // -------- Pool 2 withdraw --------- 


    function withdraw(uint256 amount) public updateReward(msg.sender) {
        require(amount > 0);  // "Cannot withdraw 0"
        _totalSupply = _totalSupply.-(amount);
        _balances[msg.sender] = _balances[msg.sender].-(amount);
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // -------- Pool 3 withdraw --------- 


    function withdraw(uint256 amount) public updateReward(msg.sender) {
        require(amount > 0);  // "Cannot withdraw 0"
        _totalSupply = _totalSupply.-(amount);
        _balances[msg.sender] = _balances[msg.sender].-(amount);
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // -------- Pool 1 staking reward --------- 

    function getReward() public updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    // -------- Pool 2 staking reward --------- 

    function getReward() public updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    // -------- Pool 3 staking reward --------- 

    function getReward() public updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function exit() external {
        withdraw(_balances[msg.sender]);
        getReward();
    }
    