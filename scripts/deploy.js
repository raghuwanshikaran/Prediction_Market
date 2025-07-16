const { ethers } = require("hardhat");

async function main() {
  console.log("Starting deployment...");

  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Get account balance
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "ETH");

  // Get the contract factory
  const PredictionMarket = await ethers.getContractFactory("Project");

  // Deploy the contract
  console.log("Deploying Prediction Market contract...");
  const predictionMarket = await PredictionMarket.deploy();

  // Wait for deployment to complete
  await predictionMarket.waitForDeployment();

  const contractAddress = await predictionMarket.getAddress();
  console.log("Prediction Market deployed to:", contractAddress);

  // Verify deployment
  console.log("Verifying deployment...");
  const owner = await predictionMarket.owner();
  const marketCount = await predictionMarket.marketCount();
  
  console.log("Contract owner:", owner);
  console.log("Initial market count:", marketCount.toString());

  // Create a sample market for testing
  console.log("\nCreating a sample market for testing...");
  const sampleQuestion = "Will Bitcoin reach $100,000 by the end of 2024?";
  const sampleOptions = ["Yes", "No"];
  const duration = 7 * 24 * 60 * 60; // 7 days in seconds

  const tx = await predictionMarket.createMarket(
    sampleQuestion,
    sampleOptions,
    duration
  );

  await tx.wait();
  console.log("Sample market created successfully!");

  // Get the created market info
  const marketInfo = await predictionMarket.getMarketInfo(0);
  console.log("Sample market question:", marketInfo.question);
  console.log("Sample market options:", marketInfo.options);
  console.log("Sample market end time:", new Date(Number(marketInfo.endTime) * 1000).toLocaleString());

  console.log("\n=== Deployment Summary ===");
  console.log("Network:", hre.network.name);
  console.log("Contract Address:", contractAddress);
  console.log("Deployer:", deployer.address);
  console.log("Gas used for deployment: Check transaction hash in explorer");
  console.log("Block Explorer:", `https://scan.test2.btcs.network/address/${contractAddress}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Deployment failed:", error);
    process.exit(1);
  });
