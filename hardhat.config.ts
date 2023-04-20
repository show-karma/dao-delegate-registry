import { HardhatUserConfig } from "hardhat/config";
import { HardhatUserConfig } from "hardhat/config";
import 'hardhat-deploy';
import "@nomicfoundation/hardhat-toolbox";

const { infuraApiKey, privateKey } = require('./secrets.json');

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  namedAccounts: {
    deployer: {
      default: 0
    }
  },
  networks: {
    
  }
};

export default config;
