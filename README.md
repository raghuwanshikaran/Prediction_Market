# Prediction Market

## Project Description

The Prediction Market is a decentralized smart contract platform built on the Core Testnet that enables users to create, participate in, and resolve prediction markets. Users can bet on the outcomes of future events with cryptocurrency, creating a transparent and trustless betting environment. The platform allows market creators to pose questions about future events, while participants can place bets on their predicted outcomes and claim winnings if their predictions are correct.

## Project Vision

Our vision is to create a fully decentralized prediction market ecosystem that democratizes access to forecasting and betting on future events. By leveraging blockchain technology, we aim to eliminate intermediaries, ensure transparency, and provide fair and automated resolution of prediction markets. The platform serves as a foundation for collective intelligence gathering, where crowd wisdom can be harnessed to predict future outcomes across various domains including sports, politics, economics, and technology.

## Key Features

**Market Creation & Management**
- Create custom prediction markets with multiple outcome options (2-10 choices)
- Set custom duration for market participation
- Automatic market lifecycle management with time-based expiration
- Creator fee structure (2%) to incentivize quality market creation

**Betting & Participation**
- Place bets on predicted outcomes using cryptocurrency
- Minimum bet threshold to ensure serious participation
- Real-time tracking of betting pools and user positions
- Support for multiple bets on the same market by individual users

**Automated Resolution & Payouts**
- Transparent market resolution by authorized parties
- Automated calculation of winnings based on betting pools
- Proportional distribution of winnings to correct predictions
- Built-in fee structure (1% platform fee + 2% creator fee)

**Security & Transparency**
- Immutable smart contract logic ensuring fair play
- Public visibility of all bets and market statistics
- Protected against common vulnerabilities with proper access controls
- Event logging for complete audit trail

**User Experience**
- Simple and intuitive betting interface
- Real-time market information and statistics
- Easy claiming process for winnings
- View functions for market exploration and analysis

## Future Scope

**Enhanced Market Types**
- Implement scalar markets for price predictions and ranges
- Add support for combinatorial markets with multiple correlated events
- Introduce conditional markets that depend on other market outcomes
- Create recurring markets for periodic events

**Oracle Integration**
- Integrate with Chainlink oracles for automated market resolution
- Implement multiple oracle consensus mechanisms
- Add support for real-world data feeds (sports scores, stock prices, weather)
- Create dispute resolution mechanisms for oracle disagreements

**Advanced Features**
- Implement market maker algorithms for better liquidity
- Add support for limit orders and advanced trading options
- Create market categories and tagging systems
- Implement reputation systems for market creators and participants

**Platform Improvements**
- Develop mobile-responsive web interface
- Add social features like comments and market discussions
- Implement push notifications for market updates
- Create analytics dashboard for market performance tracking

**Cross-Chain Compatibility**
- Extend support to multiple blockchain networks
- Implement cross-chain betting and liquidity sharing
- Add support for multiple cryptocurrency tokens
- Create bridging mechanisms for seamless user experience

**Governance & Decentralization**
- Implement DAO governance for platform decisions
- Create token-based voting for market dispute resolution
- Add community-driven market moderation
- Implement decentralized market curation mechanisms

**Scalability & Performance**
- Implement Layer 2 solutions for reduced transaction costs
- Add batch processing for multiple market operations
- Optimize gas usage and contract efficiency
- Create off-chain computation with on-chain verification

## Getting Started

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn
- MetaMask or compatible Web3 wallet

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd prediction-market
```

2. Install dependencies:
```bash
npm install
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your private key and other configurations
```

4. Compile the smart contracts:
```bash
npm run compile
```

5. Deploy to Core Testnet:
```bash
npm run deploy
```

### Usage

**Creating a Market:**
```javascript
await predictionMarket.createMarket(
  "Will Bitcoin reach $100,000 by end of 2024?",
  ["Yes", "No"],
  7 * 24 * 60 * 60 // 7 days
);
```

**Placing a Bet:**
```javascript
await predictionMarket.placeBet(marketId, optionIndex, {
  value: ethers.parseEther("0.1")
});
```

**Claiming Winnings:**
```javascript
await predictionMarket.claimWinnings(marketId);
```

## Smart Contract Architecture

The main contract (`Project.sol`) includes three core functions:

1. **createMarket()** - Allows users to create new prediction markets
2. **placeBet()** - Enables users to place bets on market outcomes
3. **claimWinnings()** - Allows winners to claim their rewards after resolution

## Network Configuration

- **Network**: Core Testnet
- **RPC URL**: https://rpc.test2.btcs.network
- **Chain ID**: 1115
- **Block Explorer**: https://scan.test2.btcs.network

## Testing

Run the test suite:
```bash
npm test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the repository or contact the development team.  0xDAe1D1dcB306372aF01c231aE32Bc07EFFbdd947 ![Uploading Transaction.PNG…]()
