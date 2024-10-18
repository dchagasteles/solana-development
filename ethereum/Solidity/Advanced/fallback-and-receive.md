# fallback

- `fallback() external [payable] {…}` without `function`
- no arguemnt, no return, must external
- always receive data, but also receive Ether when mark it as payable

fallback is a function that does not take any arguments and does not return anything.
It is executed either when

- a function that does not exist is called or
- Ether is sent directly to a contract but receive() does not exist or msg.data is not empty
  fallback has a 2300 gas limit when called by transfer or send.
  https://solidity-by-example.org/fallback/

# receive

- can have only one receive function, `receive() external payable {…} ` without `function`
- no argument, no rturn, must be external and payable
- executes on calls to the contract with no data (calldata)
  e.g. calls made via send() or transfer()
- can be used to receive Ether
