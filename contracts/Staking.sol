/**
 *Submitted for verification at Etherscan.io on 2024-06-29
 */

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// import console.sol
// import "hardhat/console.sol";

contract Stakings is Ownable {
    struct Offer {
        IERC20 token; // token that users will use to stake
        uint apy; // apy of the offer
        uint lockPeriod; // lock periods
        string name;
        uint numberOfStakers; // number of stakers
        uint tvl; // total staked amount
        uint rewardPool; // total reward pool for staking.
        uint totalStaked;
        uint startDate;
        uint totalReward;
        mapping(uint => uint) rewardsPerDay;
    }

    struct OfferImages {
        string bannerUrl;
        string logourl;
    }
    struct Staking {
        uint id; // offer id
        uint amount;
        uint lastClaminedDays;
        uint unstakeTime;
        address staker;
    }

    mapping(uint => Offer) public offers;
    mapping(uint => OfferImages) public offerImages;

    mapping(uint => Staking) public stakings;

    mapping(address => uint[]) public usersStakeids;

    uint public numberOfOffers;
    uint public numberOfStakes;

    // events
    event OfferCreated(uint id, address token, uint apy, uint lockPeriod);
    event OfferEdited(uint id, address token, uint apy, uint lockPeriod);
    event Staked(uint id, uint amount);
    event Unstaked(uint id, uint amount);
    event RewardClaimed(uint id, uint amount);
    event RewardUpdated(uint id, uint amount);

    constructor() {}

    /*
        @des function to create a new offer.
        @params _token: address of the token that is besing staked. 
                _apy: APY of the stake
                _lockPeriod: lockperiod of the stake.
                _isActivated: for storing status of offers.
    
     */
    function createOffer(
        address _token,
        uint _apy,
        uint _lockPeriod,
        string memory _name,
        uint _rewardPool,
        string memory _bannerUrl,
        string memory _logoUrl,
        uint _startDate
    ) external onlyOwner {
        numberOfOffers = numberOfOffers + 1;

        Offer storage _offer = offers[numberOfOffers];
        OfferImages storage _offerImages = offerImages[numberOfOffers];

        _offer.apy = _apy;
        _offer.token = IERC20(_token);
        _offer.lockPeriod = _lockPeriod;
        _offer.name = _name;
        _offer.rewardPool = _rewardPool;
        _offer.token.transferFrom(msg.sender, address(this), _rewardPool);
        // offer images
        _offerImages.bannerUrl = _bannerUrl;
        _offerImages.logourl = _logoUrl;

        _offer.startDate = _startDate;

        emit OfferCreated(numberOfOffers, _token, _apy, _lockPeriod);
    }

    /*
        @des function to edit offer.
        @params _token: address of the token that is besing staked. 
                _apy: APY of the stake
                _lockPeriod: lockperiod of the stake.
                _isActivated: for storing status of offers.
                _id: id of the offer.
    
     */
    function editOffer(
        uint _id,
        address _token,
        uint _apy,
        uint _lockPeriod,
        uint _rewardPool
    ) external onlyOwner {
        require(_id > 0 && _id <= numberOfOffers, "Offer does not exist");
        numberOfOffers = numberOfOffers + 1;
        Offer storage _offer = offers[numberOfOffers];
        _offer.apy = _apy;
        _offer.token = IERC20(_token);
        _offer.lockPeriod = _lockPeriod;
        _offer.token.transferFrom(msg.sender, address(this), _rewardPool);
        _offer.rewardPool += _rewardPool;

        emit OfferEdited(_id, _token, _apy, _lockPeriod);
    }

    function stake(uint _id, uint _amount) external {
        require(_id > 0 && _id <= numberOfOffers, "Offer does not exist");
        require(offers[_id].rewardPool > 0, "Reward Pool is 0");
        require(offers[_id].startDate < block.timestamp, "Staking not started");

        numberOfStakes = numberOfStakes + 1;
        Staking storage myStake = stakings[numberOfStakes];
        IERC20 _token = offers[_id].token;
        _token.transferFrom(msg.sender, address(this), _amount);
        myStake.amount = _amount;
        myStake.id = _id;
        myStake.unstakeTime = block.timestamp + offers[_id].lockPeriod;
        myStake.lastClaminedDays = block.timestamp;
        myStake.staker = msg.sender;
        offers[_id].tvl += _amount;
        usersStakeids[msg.sender].push(numberOfStakes);
        offers[_id].numberOfStakers++;
        offers[_id].totalStaked += _amount;

        emit Staked(numberOfStakes, _amount);
    }

    function unStake(uint _stakeId) external {
        require(
            _stakeId > 0 && _stakeId <= numberOfStakes,
            "Stake does not exist"
        );
        Staking storage myStake = stakings[_stakeId];
        uint _amount = myStake.amount;
        myStake.amount = 0;
        // check if unstake time has passed.
        if (myStake.unstakeTime > block.timestamp) {
            // cut 20% of the stake and send to staker.
            _amount = (_amount * 80) / 100;
        }
        IERC20 _token = offers[myStake.id].token;
        delete stakings[_stakeId];
        _token.transfer(msg.sender, _amount);

        emit Unstaked(_stakeId, _amount);
    }

    function claimReward(uint _stakeId) external {
        require(
            _stakeId > 0 && _stakeId <= numberOfStakes,
            "Stake does not exist"
        );
        Staking storage myStake = stakings[_stakeId];
        IERC20 _token = offers[myStake.id].token;
        uint _reward = reward(_stakeId);
        // update last claimed time.
        myStake.lastClaminedDays = block.timestamp;
        require(
            offers[myStake.id].rewardPool >= _reward,
            "There are no rewards to give"
        );
        offers[myStake.id].rewardPool -= _reward;
        _token.transfer(myStake.staker, _reward);
        // update total reward
        offers[myStake.id].totalReward += _reward;
        emit RewardClaimed(_stakeId, _reward);
    }

    function updateDailyReward(uint _id) public {
        // update daily reward for today.
        uint _dailyReward = getDailyReward(_id);
        offers[_id].rewardsPerDay[block.timestamp / 1 days] = _dailyReward;
        emit RewardUpdated(_id, _dailyReward);
    }

    function withdrawToken(address _token) external onlyOwner {
        IERC20 token = IERC20(_token);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function withdrawNative() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function reward(uint _stakeId) public view returns (uint) {
        // check the days passed since last claim.
        Staking memory myStake = stakings[_stakeId];
        uint _daysPassed = daysPassedLastClaim(_stakeId);
        if (_daysPassed == 0) {
            return 0;
        }
        uint _reward = 0;

        // last day id
        uint _lastDay = block.timestamp / 1 days;

        // loop for last _dasPassed days.
        for (uint i = 0; i < _daysPassed; i++) {
            uint _day = _lastDay - i;
            _reward +=
                (getDailyRewardSaved(myStake.id, _day) * myStake.amount) /
                offers[myStake.id].totalStaked;
        }

        return _reward;
    }

    function getDailyReward(uint _id) public view returns (uint) {
        return (offers[_id].apy * offers[_id].totalStaked) / 365;
    }

    function getMyStakeIds() public view returns (uint[] memory) {
        return usersStakeids[msg.sender];
    }

    function getDailyRewardSaved(
        uint _id,
        uint _day
    ) public view returns (uint) {
        return offers[_id].rewardsPerDay[_day];
    }

    function daysPassedLastClaim(uint _stakeId) public view returns (uint) {
        Staking memory myStake = stakings[_stakeId];
        return (block.timestamp - myStake.lastClaminedDays) / 1 days;
    }

    function daysPassesSinceStart(uint _stakeId) public view returns (uint) {
        Staking memory myStake = stakings[_stakeId];
        return (block.timestamp - offers[myStake.id].startDate) / 1 days;
    }
}
