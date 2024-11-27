//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

// Base contract X
contract X {
  string public name;

  constructor(string memory _name) {
    name = _name;
  }
}

// Base contract Y
contract Y {
  string public text;

  constructor(string memory _text) {
    text = _text;
  }
}

// There are 2 ways to initialize parent contract with parameters.
contract B is X('input to X'), Y('input to Y') {}

contract C is X,Y {
  // Pass the parameters here in the constructor,
  // similar to function modifiers.
  constructor(string memory _name, string memory _text) X(_name) Y(_text) {
  }
}


// Order of constructors called:
// 1. Y
// 2. X
// 3. E
contract E is X, Y {
  constructor() X("X was called") Y("Y was called") {
  }
}


// Order of constructors called:
// 1. Y
// 2. X
// 3. E
contract E is X, Y {
  constructor() Y("Y was called") X("X was called") {
  }
}