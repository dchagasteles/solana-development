# How to fix “stack too deep” solidity error (more than 16 varilables)

- use struct data varialble
- use internal function
- using block scoping
- use msg.data

# Max bytecode of a contract and how to fix if a contract exceeds the limit

- 24KB
- use uint256 instead of boolean
- use library
- use short strings (reason for require)
- single line swaps
- use event to store data that is not required on-chain
- use optimizer
- use fewer functions
- use internal functions that is cheaper
- using proxy patterns for mass deployment (multiple)

# Uint8 or Uint256, which costs more gas

The gas estimate clearly indicates that the uint8 version is more costly. In terms of number of opcodes the uint8 version has more than the uint256 version - an entire new line

# Order variables to save gas

Solidity contract have contiguous 32 bytes(256 bit) slots used for storae.
We can do varaible packing that means arrange variables so multiple fit in a single slot.
(uint128, bytes32, bool, and uint128) => (uint128, uint128, bytes32, bool)

bool = 1 byte
uint8 = 1 byte
bytes32 = 32 bytes
uint128 = 16 bytes
address = 20 bytes
