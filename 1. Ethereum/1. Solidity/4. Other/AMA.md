# what is impermanent loss and where does it go

IL happens when the value of deposited assets change from the original value when you deposited.
This is because liquidity providers get share of pool, not definite amount of tokens.
IL menns the fact that value of withdraal is lower than value of deposit.
Predict: stable coin pair, and piar that does not expose their liqudiity to the market so that arbitrage does not happen.

# Difference between public and external function?

- public use 496 gas while external use 261
- public - all can access
- external - Cannot be accessed internally, only externally
- internal - only this contract and contracts deriving from it can access
- private - can be accessed only from this contract

# What's "indexed" keyword in a event?. How many can you mark as indexed?

- off-chain side, we can filter events by name and by contract address.
- up to 3 indexed
- blockchain keeps event params in transaction logs in two parts - data and topics (indexed will be stored on topics)
- indexed params will allow users to search for these events using the indexed parameters as filter
- not indexed attributes are ABI-encoded into the data portion of the transaction log

# Verify Contract on Etherscan

- when i use hardhat, i use hardhat-etherscan with etherscan API key
  npx hardhat verify --network mainnet DEPLOYED_CONTRACT_ADDRESS "Constructor argument 1"

- manually
  using hardhat flatten to make one single contract file
  and manually verify with that on the etherscan

# Upgradeable contracts

original method

- Create & deploy a new version of the contract.
- Manually migrate all states from the old contract to the new contract.
  this is expensive, contract address is being changed whenever deploy, we should ask users to use new contract

we can use Proxy contract with an interface where each method delegates to the `implementation` contract containing logic
https://simpleaswater.com/upgradable-smart-contracts/

# flash loan arbitrage bot on uniswap

https://medium.com/@lunaray/build-a-flash-loan-arbitrage-bot-on-uniswap-9f749ee20ab9?source=email-ba782e9e1980-1659770418194-digest.reader-721b17443fd5-9f749ee20ab9----1-58------------------1ec1fca8_b890_4045_8568_8521143c99df-16

# nft royaltivies

https://medium.com/better-programming/enabling-nft-royalties-with-eip-2981-1cc7cf4378a9?source=explore---------8-98--------------------7f2dd98c_73e2_48ae_9f1c_92e4048cc0c1-------15

# random number

https://betterprogramming.pub/how-to-generate-truly-random-numbers-in-solidity-and-blockchain-9ced6472dbdf

# cross chain & multi chain

https://medium.com/@opeyemiegbeola14/understanding-cross-chain-and-multi-chain-7cbec5cb6d13?source=email-ba782e9e1980-1658475111302-digest.reader-721b17443fd5-7cbec5cb6d13----3-58------------------49f2eb52_402f_48a3_8e9d_a3b6d4bc0fd5-1

# multi-call

https://medium.com/@patrick.collins_58673/use-multicall-to-save-tons-of-api-requests-to-your-blockchain-node-f759d09a8ef5?source=email-b1ece2e7bb1b-1659286430708-digest.reader-d0b105d10f0a-f759d09a8ef5----0-59------------------7af3b7ab_283d_4d79_89f2_1dd28400000f-16

# How private variables work? Can I read them from the blockchain ?

web3.eth.getStorageAt("0x501...", 5)
https://stackoverflow.com/questions/50493197/solidity-accessing-private-variable

# How do you concatenate 2 strings?

https://docs.soliditylang.org/en/latest/units-and-global-variables.html?highlight=abi.encode

# Force send ether

https://medium.com/@alexsherbuck/two-ways-to-force-ether-into-a-contract-1543c1311c56

- Smart Contracts have a selfdestruct function that accepts an address parameter. It will forward the contract’s balance to the given address.
  The selfdestruct function does not trigger a Smart Contract’s fallback function.

# Solidity Free memory pointer

https://www.programmerall.com/article/3615569485/

# What’s better to use for a short text? Bytes32 or string, and why?

https://medium.com/@cryptopusco/bytes-and-strings-in-solidity-f2cd4e53f388

# meta-transactions

https://soliditydeveloper.com/meta-transactions

https://medium.com/coinmonks/gas-free-transactions-meta-transactions-explained-f829509a462d?source=explore---------0-98--------------------7f2dd98c_73e2_48ae_9f1c_92e4048cc0c1-------15 (gas free meta tx)

# merkle tree

# xdai

https://soliditydeveloper.com/xdai

# optimism
