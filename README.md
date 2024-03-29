[This project](https://ethglobal.com/showcase/fair-referral-network-cz9m0) won the 🏊‍♂️ [Worldcoin — Pool Prize](https://ethglobal.com/showcase/fair-referral-network-cz9m0) at the [ETHNewYork 2022](https://ethglobal.com/events/ethnewyork2022) hackathon.

# Fair Referral Network
Sybil attack proof referral network using Worldcoin Zero Knowledge proof-of-personhood

## Demo video
See [this link](demo/README.md)

## Description
Sales networks are webs of people referring each other to prospective customers and sales opportunities. Most efficient such networks are Multi Level Marketing, which unfortunately suffers from a lack of fairness. This was exposed by Pershing Capital activist investor Bill Ackman, trying to reveal the unfairness and dishonesty of Herbalife. Fair Referral Network identifies these problems and provides a solution by limiting the depth of the network to avoid a pyramid scheme where the top reaps all the profit and the bottom loses. In addition it provides transparency and protection against Sybil attacks, in which one person would act as several ghost actors in order to circumvent the real referrer. 

## How it’s made
Polygon Smart Contracts written in Solidity are used to enforce the rules of engagement. In order to proof that a person can act only once, Worldcoin technology is used. In it a Zero Knowledge proof-of-personhood is generated and submitted by the user to the smart contract. This action is recorded using a nullifier to make sure the same person cannot repeat the same action more than once and create their own sub-network of referrals thus circumventing the actual referrer. The referrer issues referrals signed off-chain using WalletConnect, so they don't cost any money/gas to the referrer.
