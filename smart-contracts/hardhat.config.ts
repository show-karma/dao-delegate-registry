import 'hardhat-deploy';
import 'solidity-coverage';
import { task } from "hardhat/config";

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

const { infuraApiKey, privateKey } = require('./secrets.json');

export default {
  solidity: {
    version: "0.8.19",
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 1000
      }
    }
  },
  etherscan: {
    apiKey: {
      sepolia: "34917361240448cda81f542681961659"
    }
  },
  networks: {
    mainnet: {
      url: `https://eth-mainnet.g.alchemy.com/v2/SsQRSwtqtBMGmXQCDH9lYb4U8p9QnqXK`,
      accounts: [privateKey],
      saveDeployments: true
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${infuraApiKey}`,
      accounts: [privateKey],
      saveDeployments: true
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${infuraApiKey}`,
      accounts: [privateKey],
      saveDeployments: true
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${infuraApiKey}`,
      accounts: [privateKey],
      saveDeployments: true
    },
    arb_testnet: {
      url: `https://arb-rinkeby.g.alchemy.com/v2/L4sUzq5YUpIY-D7IA3l230OhO6wFhghm`,
      accounts: [privateKey],
      saveDeployments: true
    },
    arbitrum: {
      gasPrice: 120000000,
      url: `https://arb-mainnet.g.alchemy.com/v2/okcKBSKXvLuSCbas6QWGvKuh-IcHHSOr`,
      accounts: [privateKey],
      saveDeployments: true
    },
    polygon_mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/u5NVwv-g9yoWK2pGpOvlSmbUH9AEkH_e`,
      accounts: [privateKey],
      gasPrice: 30000000000,
      saveDeployments: true
    },
    optimism: {
      url: `https://opt-mainnet.g.alchemy.com/v2/fx2SlVDrPbXwPMQT4v0lRT1PABA16Myl`,
      accounts: [privateKey],
      saveDeployments: true
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/34917361240448cda81f542681961659`,
      accounts: [privateKey],
      saveDeployments: true
    },
    polygon: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/r9n4TSj6T3p7YuwgbvcBYXGPXme0DreC`,
      gasPrice: 30000000000,
      accounts: [privateKey],
      saveDeployments: true
    },
    optimism_goerli: {
      url: `https://optimism-goerli.infura.io/v3/34917361240448cda81f542681961659`,
      accounts: [privateKey],
      gasPrice: 30000000000,
      saveDeployments: true
    },
    xdai: {
      url: `https://dai.poa.network/`,
      gasPrice: 30000000000,
      accounts: [privateKey],
      saveDeployments: true
    }
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
    }
  },
  watcher: {
    compilation: {
      tasks: ["compile"],
    },
    test: {
      tasks: [{ command: 'test', params: { testFiles: ['{path}'] } }],
      files: ['./test/**/*.ts'],
      verbose: true
    }
  }
};


