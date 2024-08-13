require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-solhint");
require("@nomicfoundation/hardhat-verify");
const dotenv = require("dotenv");

dotenv.config({
  path: "./config.env",
});
console.log(process.env.ETHEREUM_API_KEY);
module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [`${process.env.SEPOLIA_PRIVATE_KEY}`],
    },
    polygon: {
      url: "https://polygon-mainnet.g.alchemy.com/v2/U5DjIcvCZExsqjSCRe0zoWMOZ_fJa2uH",
      accounts: [`${process.env.SEPOLIA_PRIVATE_KEY}`],
    },
  },

  etherscan: {
    apiKey: {
      // polygon: process.env.POLYGON_API_KEY,
      sepolia: process.env.ETHEREUM_API_KEY,
    },
  },

  sourcify: {
    // Disabled by default
    // Doesn't need an API key
    enabled: true,
  },
};

// command to deploy contract
// deploy: hardhat run scripts/deploy.js --network polygon
// verify: hardhat verify --network polygon DEPLOYED_CONTRACT_ADDRESS "Constructor argument 1" "Constructor argument 2" ...
