import WalletConnectProvider from "@walletconnect/web3-provider";
import afFairReferralNetwork from "./@artifacts/FairReferralNetwork.sol/FairReferralNetwork.json";

export const provider = new WalletConnectProvider({
  rpc: {
    80001: "https://rpc-mumbai.maticvigil.com/",
  },
  clientMeta: {
    name: "FairReferralNetwork",
    description: "Fair Referral Network",
    url: "https://github.com/jordan-public/fair-referral-network",
    icons: [
      document.head.querySelector<HTMLLinkElement>("link[rel~=icon]")!.href,
    ],
  },
});

export const CONTRACT_ADDRESS =
  process.env.WLD_CONTRACT_ADDRESS || // eslint-disable-line @typescript-eslint/prefer-nullish-coalescing
  "0xe6ad7663B2614c51e07F27e82c195050a4E8F1B5";

export const CONTRACT_ABI = afFairReferralNetwork.abi;
