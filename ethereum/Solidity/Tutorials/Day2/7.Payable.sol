// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract Payable {
  // Payable address can receive Ether
  address payable public owner;

  // Payable address can receive Ether
  constructor() payable {
    owner = payable(msg.sender);
  }

  // Function to deposit Ether into this contract
  // Call this function along with some Ethers
  // The balance of this contract will be automaticlly updated
  function deposit() public payable {
  }

  // Call this function along with some Ether
  // will throw an error since its not payable
  function notPayable() public {
  }

  // Function to withdraw all Ether from this contract
  function withdraw() public {
    uint amount = address(this).balance;

    // send all Ether to owner
    // Owner can receive Ether since the address of owner is payable
    (bool success, ) = owner.call{value: amount}('');
    require(success, 'Failed to send Ether');
  }

  // Function to transfer Ether from this contract to address from input
  function transfer(address payable _to, uint _amount) public {
    (bool success, ) = _to.call{value: _amount}('');
    require(success, 'Failed to send Ether');
  }
}