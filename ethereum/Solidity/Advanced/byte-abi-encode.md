# what is bytecode?

- bytecode is stored on the blockchain with address, when contract deploy to the network
- describes contract logic
- sequene of EVM opcodes written in hex
- machine-readable, not human-readable

# what is ABI? (Contract Application Binary Interface)

- ABI will describte its public interface and how to interace with it.
- link between machin-readable and human-readable layer
- specification for encoding & decoding data and contract calls.
- JSON format

# encoding data

- Solidity types (like address, uint, bytes) are encoded as 32 bytes word
- 32 bytes padding

## abi.encode (standard encode mode)

- encode solidit types into raw bytes (that an be interpreted directly by EVM)

1st 32 bytes = offest -> indicate bytes index
2nd 32 bytes = length
3rd 32 bytes - actual utf8 encoded string

abi.encode("Solidity")

> 0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000004536f6c6964697479000000000000000000000000000000000000000000000000

## abi.encodePacked (non-standard encode mode)

- drops string offset and length

abi.encodePacked("Solidity")

> 0x536f6c6964697479

# encoding contract call

- used to prepare payloads in raw bytes for external contract call
- such payable can then be passed as parameters to the low levl solidity `.call`, `.delegatecall`, `staticcall` functions

## encodeWithSelector

```
abi.encodeWithSelector(
    bytes4(keccak256(bytes(
        'transfer(address,uint256') // functoin signature
    ))) // function selector
)
```

- must provide bytes4 function selector
- selector is first 4 bytes of the keccak256-hash of the function signature)

### encodeWithSignature

```
abi.encodeWithSelector(
    'transfer(address,uint256') // functoin signature
)
```
