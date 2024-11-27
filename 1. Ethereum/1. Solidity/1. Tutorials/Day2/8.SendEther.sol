// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

/**
  you can send Ether to other contracts by
  - tarnsfer (2300 gas, thorws error) 
  - send (2300 gas, returns bool)
  - call(forward all gas or set gas, returns bool)
*/

/**
  to receive Ethers, contract must have at least one of the below functions
  - receive() external payable
  - fallback() external payable

  receive() is called if msg.data is empty
*/

/**
  call in combination with re-entrancy guard is the recommended method to use after December 2019.
  Guard against re-entrancy by
  - making all state changes before calling other contracts
  - using re-entrancy guard modifier
*/


contract ReceiveEther {
/*
  Which function is called, fallback() or receive()?

          send Ether
              |
        msg.data is empty?
            / \
          yes  no
          /     \
receive() exists?  fallback()
        /   \
      yes   no
      /      \
  receive()   fallback()
*/

  // funciton to receive Ethers, msg.data must be empty
  receive() external payable {}

  // Fallback function is called when msg.data is not empty
  fallback() external payable {}

  function getBalance() public view returns(uint) {
    return address(this).balance;
  }
}

contract SendEther {
  function sendViaTransfer(address payable _to) public payable {
    // This function is no longer recommended for sending Ether.
    _to.transfer(msg.value);
  }

  function sendViaSend(address payable _to) public payable {
    // Send returns a boolean value indicating success or failure.
    // This function is not recommended for sending Ether.
    bool sent = _to.send(msg.value);
    require(sent, 'Failed to send Ether');
  }

  function sendViaCall(address payable _to) public payable {
    // Call returns a boolean value indicating success or failure.
    // This is the current recommended method to use.
    (bool sent, bytes memory data) = _to.call{value: msg.value}('');
    require(sent, 'Failed to send Ether');
  }
}