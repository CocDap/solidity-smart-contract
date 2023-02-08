import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  typechain: {
    outDir: "typechain",
    target: "ethers-v5",
  },
  networks: {
    canto_testnet: {
      url: `https://eth.plexnode.wtf/`,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      gasPrice: 500000000,
    },
    // bsc_testnet: {
    //   url:"https://data-seed-prebsc-1-s2.binance.org:8545/",
    //   chainId: 97,
    //   accounts: 
    //     process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],

    // }
  },
};

export default config;
