//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

/* Graph of inheritance
    A
   / \
  B   C
 / \ /
F  D,E
*/

// Parent contracts can be
// - called directly
// - or by using the keyword super.

contract A {
  // Function that is going to be overridden by a child contract must be declared as virtual.
  // Function that is going to override a parent function must use the keyword override.
  function foo() public pure virtual returns (string memory) {
    return "A";
  }
}

// Contracts inherit other contracts by using the keyword 'is'.
contract B is A {
  // override A.foo()
  function foo() public pure virtual override returns (string memory) {
    return 'B';
  }
}

contract C is A {
  // overrides A.foo()
  function foo() public pure virtual override returns (string memory) {
    return 'B';
  }
}


// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in depth-first manner.

contract D is B, C {
  // D.foo returns 'C'
  // since C is the right most parent contract with function foo()
  function foo() public pure override(B, C) returns (string memory) {
    return super.foo();
  }
}

contract E is C, B {
  // E.foo() returns "B"
  // since B is the right most parent contract with function foo()
  function foo() public pure override(C, B) returns (string memory) {
      return super.foo();
  }
}

// Inheritance must be ordered from “most base-like” to “most derived”.
// Swapping the order of A and B will throw a compilation error.
contract F is A, B {
  function foo() public pure override(A, B) returns (string memory) {
    return super.foo();
  }
}