import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan";
import "solidity-coverage";
import "hardhat-contract-sizer";
import "hardhat-deploy";
import { config as dotenv } from "dotenv";

dotenv();

const config: HardhatUserConfig = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            forking: process.env["MAINNET_RPC"]
                ? {
                      url: process.env["MAINNET_RPC"],
                      blockNumber: 13270000,
                  }
                : undefined,

            accounts: process.env["MAINNET_DEPLOYER_PK"]
                ? [
                      {
                          privateKey: process.env["MAINNET_DEPLOYER_PK"],
                          balance: (10 ** 20).toString(),
                      },
                  ]
                : undefined,
        },
        localhost: {
            url: "http://localhost:8545",
        },
        kovan: {
            url:
                process.env["KOVAN_RPC"] ||
                "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
            accounts: process.env["KOVAN_DEPLOYER_PK"]
                ? [process.env["KOVAN_DEPLOYER_PK"]]
                : undefined,
        },
        bsc: {
            url: process.env["BSC_RPC"] || 
                "https://bsc-dataseed.binance.org/",
            accounts: process.env["BSC_DEPLOYER_PK"]
                ? [process.env["BSC_DEPLOYER_PK"]]
                : undefined,
        },
        mainnet: {
            url: process.env["MAINNET_RPC"],
            accounts: process.env["MAINNET_DEPLOYER_PK"]
                ? [process.env["MAINNET_DEPLOYER_PK"]]
                : undefined,
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
            kovan: process.env["KOVAN_DEPLOYER"] as string,
            bsc: process.env["BSC_DEPLOYER"] as string
        },
    },

    solidity: {
        compilers: [
            {
                version: "0.8.12",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                    evmVersion: "london",
                },
            },
        ],
    },
    etherscan: {
        apiKey: process.env["ETHERSCAN_API_KEY"],
    },
};

export default config;
