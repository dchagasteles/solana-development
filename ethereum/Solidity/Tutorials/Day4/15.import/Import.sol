// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import './Foo.sol';

// https://github.com/owner/repo/blob/branch/path/to/Contract.sol
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/cryptography/ECDSA.sol


contract Import {
  Foo public foo = new Foo();

  function getFooName() public view returns (string memory) {
    return foo.name();
  }
}

