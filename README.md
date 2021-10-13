# Starter Blockchain Wallet iOS App

I created a smart contract (NSEToken) using the Ethereum blockchain and connected that to an iOS app using Flutter 🕊


## Demo

![Demo.png](https://github.com/nicoestrada/nsetoken/blob/main/assets/Demo.png?raw=true)

## How I Built It

First, in order to build the smart contract, I used (https://remix.ethereum.org). This enabled me to initialize the NSEToken smart contract along with 3 functions and a constructor. Those functions were getBalance, depositBalance, and withdrawBalance.

In order to complete the connection to Ethereum network, I used (https://infura.io) as the API client

When the app is ran using *Flutter run*, the wallet balance is a live reflection of the current getBalance amount from my provided wallet address on Ethereum. The the smart contract is written on the Ethereum network in the Rinkeby Test Network. 

I enjoyed building this starter project as an introduction to my Web3 adventures! 🥳
