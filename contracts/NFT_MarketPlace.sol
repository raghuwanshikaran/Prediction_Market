// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Project {
    struct Market {
        string question;
        string[] options;
        uint256 endTime;
        uint256 totalPool;
        mapping(uint256 => uint256) optionPools;
        mapping(address => mapping(uint256 => uint256)) userBets;
        mapping(address => bool) hasClaimed;
        bool resolved;
        uint256 winningOption;
        address creator;
    }

    mapping(uint256 => Market) public markets;
    uint256 public marketCount;
    uint256 public constant MIN_BET = 0.001 ether;
    uint256 public constant CREATOR_FEE = 2; // 2% fee for market creator
    uint256 public constant PLATFORM_FEE = 1; // 1% platform fee
    
    address public owner;
    
    event MarketCreated(
        uint256 indexed marketId,
        string question,
        string[] options,
        uint256 endTime,
        address creator
    );
    
    event BetPlaced(
        uint256 indexed marketId,
        address indexed user,
        uint256 option,
        uint256 amount
    );
    
    event MarketResolved(
        uint256 indexed marketId,
        uint256 winningOption
    );
    
    event WinningsClaimed(
        uint256 indexed marketId,
        address indexed user,
        uint256 amount
    );
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier validMarket(uint256 marketId) {
        require(marketId < marketCount, "Market does not exist");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Creates a new prediction market
     * @param question The question for the prediction market
     * @param options Array of possible outcomes
     * @param duration Duration in seconds for how long the market will be active
     */
    function createMarket(
        string memory question,
        string[] memory options,
        uint256 duration
    ) external {
        require(options.length >= 2, "Market must have at least 2 options");
        require(options.length <= 10, "Market cannot have more than 10 options");
        require(duration > 0, "Duration must be greater than 0");
        require(bytes(question).length > 0, "Question cannot be empty");
        
        uint256 marketId = marketCount;
        Market storage newMarket = markets[marketId];
        
        newMarket.question = question;
        newMarket.options = options;
        newMarket.endTime = block.timestamp + duration;
        newMarket.totalPool = 0;
        newMarket.resolved = false;
        newMarket.creator = msg.sender;
        
        marketCount++;
        
        emit MarketCreated(marketId, question, options, newMarket.endTime, msg.sender);
    }
    
    /**
     * @dev Places a bet on a specific option in a market
     * @param marketId The ID of the market
     * @param option The option index to bet on
     */
    function placeBet(uint256 marketId, uint256 option) external payable validMarket(marketId) {
        Market storage market = markets[marketId];
        
        require(block.timestamp < market.endTime, "Market has ended");
        require(!market.resolved, "Market already resolved");
        require(msg.value >= MIN_BET, "Bet amount too small");
        require(option < market.options.length, "Invalid option");
        
        market.userBets[msg.sender][option] += msg.value;
        market.optionPools[option] += msg.value;
        market.totalPool += msg.value;
        
        emit BetPlaced(marketId, msg.sender, option, msg.value);
    }
    
    /**
     * @dev Resolves a market by setting the winning option
     * @param marketId The ID of the market to resolve
     * @param winningOption The index of the winning option
     */
    function resolveMarket(uint256 marketId, uint256 winningOption) external validMarket(marketId) {
        Market storage market = markets[marketId];
        
        require(msg.sender == market.creator || msg.sender == owner, "Only creator or owner can resolve");
        require(block.timestamp >= market.endTime, "Market has not ended yet");
        require(!market.resolved, "Market already resolved");
        require(winningOption < market.options.length, "Invalid winning option");
        
        market.resolved = true;
        market.winningOption = winningOption;
        
        emit MarketResolved(marketId, winningOption);
    }
    
    /**
     * @dev Allows users to claim their winnings from a resolved market
     * @param marketId The ID of the resolved market
     */
    function claimWinnings(uint256 marketId) external validMarket(marketId) {
        Market storage market = markets[marketId];
        
        require(market.resolved, "Market not resolved yet");
        require(!market.hasClaimed[msg.sender], "Already claimed");
        require(market.userBets[msg.sender][market.winningOption] > 0, "No winning bet");
        
        uint256 userBet = market.userBets[msg.sender][market.winningOption];
        uint256 winningPool = market.optionPools[market.winningOption];
        
        if (winningPool > 0) {
            // Calculate fees
            uint256 creatorFeeAmount = (market.totalPool * CREATOR_FEE) / 100;
            uint256 platformFeeAmount = (market.totalPool * PLATFORM_FEE) / 100;
            uint256 distributionPool = market.totalPool - creatorFeeAmount - platformFeeAmount;
            
            // Calculate user's share of winnings
            uint256 userWinnings = (userBet * distributionPool) / winningPool;
            
            market.hasClaimed[msg.sender] = true;
            
            // Transfer winnings to user
            payable(msg.sender).transfer(userWinnings);
            
            // Transfer fees (only once per market resolution)
            if (creatorFeeAmount > 0) {
                payable(market.creator).transfer(creatorFeeAmount);
            }
            if (platformFeeAmount > 0) {
                payable(owner).transfer(platformFeeAmount);
            }
            
            emit WinningsClaimed(marketId, msg.sender, userWinnings);
        }
    }
    
    // View functions
    function getMarketInfo(uint256 marketId) external view validMarket(marketId) returns (
        string memory question,
        string[] memory options,
        uint256 endTime,
        uint256 totalPool,
        bool resolved,
        uint256 winningOption,
        address creator
    ) {
        Market storage market = markets[marketId];
        return (
            market.question,
            market.options,
            market.endTime,
            market.totalPool,
            market.resolved,
            market.winningOption,
            market.creator
        );
    }
    
    function getOptionPool(uint256 marketId, uint256 option) external view validMarket(marketId) returns (uint256) {
        return markets[marketId].optionPools[option];
    }
    
    function getUserBet(uint256 marketId, address user, uint256 option) external view validMarket(marketId) returns (uint256) {
        return markets[marketId].userBets[user][option];
    }
    
    function hasUserClaimed(uint256 marketId, address user) external view validMarket(marketId) returns (bool) {
        return markets[marketId].hasClaimed[user];
    }
}
