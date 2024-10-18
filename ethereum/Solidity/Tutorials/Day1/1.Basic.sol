//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";

contract BasicInfo {
  function aboutGas() public {
    // you pay [gasSpent * gasPrice] amount of ether
    // gasSpent: total amount of gas
    // gasPrice: how much ether will be paid per gas

    // gas limit: max amount of gas willing to use for transaction
    // block gas limit: max amount of gas allowed in block, set by network
  }

  function aboutEtherUnits() public pure {
    uint oneWei = 1 wei;

    // 1 wei is equal to 1
    bool isOneWei = 1 wei == 1;

    uint oneEther = 1 ether;
    // 1 ether is equal to 10 ^ 18
    bool isOneEther = oneEther == 1e18;
  }

  function aboutIfElse(uint x) public pure returns (int) {
    if (x < 10) {
      return 0;
    } else if (x < 20) {
      return 1;
    } else {
      return 2;
    }
  }

  function aboutLoop() public {
    for (uint i = 0; i < 10; i++) {
      if (i  < 5) {
        continue;
      } else {
        break;
      }
    }

    uint j;
    while (j < 10) {
      j++;
    }
  }
}