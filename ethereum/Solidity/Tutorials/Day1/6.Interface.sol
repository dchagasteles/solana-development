

// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

// Interface
// - cannot have any functions implemented
// - can inherit from other interfaces
// - all declared functions must be external
// - cannot declare a constructor
// - cannot declare state variables


contract Counter {
  uint public count;

  function increment() external {
    count += 1;
  }
}

interface ICounter {
  function count() external view returns (uint);
  function increment() external;
}
