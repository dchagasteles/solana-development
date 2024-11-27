# delegatecall

- When contract A executes delegatecall to contract B, B's code is excuted with contract A's storage, msg.sender and msg.value.

# staticcall

- this is for read-only calls at runtime
- solidity only impelements STATICCALL opcode in its assembly lanage.
- `pure` & `view` specifiers do not change state, so calls to `pure` & `view` functions could be compiled as STATICCALL
- if a contract’s state change depends on reading data from another contract, it can safely retrieve it without ever triggering a conflicting state change. However, if your contract’s state change requires a successful state change in another contract, STATICCALL cannot be used, so you still need to take precautions against reentrancy.
  https://medium.com/blockchannel/state-specifiers-and-staticcall-d50d5b2e4920

# call

call is a low level function to interact with other contracts.
This is the recommended method to use when you're just sending Ether via calling the fallback function.
https://solidity-by-example.org/call/
