import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.23",
  networks: {
    story: { // illiad
      url: "https://testnet.storyrpc.io/",
      accounts: [vars.get("PRIVATE_KEY")],
    },
    flow: { // evm on flow
      url: "https://testnet.evm.nodes.onflow.org",
      accounts: [vars.get("PRIVATE_KEY")],
    },
  },
};

export default config;
