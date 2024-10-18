//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

// public - any contract and account can call
// private - only inside the contract that defines the function
// internal- only inside contract that inherits an internal function
// external - only other contracts and accounts can call

contract AboutFunction {
  uint[] public arr;
  // Functions can return multiple values.
  function returnMany() public pure returns (uint, bool, uint) {
    return (1, true, 2);
  }

  // Return values can be named.
  function named() public pure returns (uint x, bool b, uint y) {
      return (1, true, 2);
  }
 
  // Return values can be assigned to their name.
  // In this case the return statement can be omitted.
  function assigned() public pure returns (uint x, bool b, uint y) {
    x = 1;
    b = true;
    y = 2;
  }

  // Use destructing assignment when calling another
  // function that returns multiple values.
  function destructingAssigments()
      public pure returns (uint, bool, uint, uint, uint)
  {
    (uint i, bool b, uint j) =  returnMany();

    // Values can be left out.
    (uint x, , uint y) = (4, 5, 6);

    return (i, b, j, x, y);
  }

  // cannot use map for neither input nonr output

  // can use array for input and output
  function arrayInput(uint[] memory _arr) public returns(uint[] memory) {
    arr = _arr;
    return arr;
  }

  function aboutPureAndView() public pure {
    // view: no state will be changed
    // pure: no state will be changed or read
  }
}

contract AboutError {
  /**
    You can throw an error by calling require, revert or assert.
   */
  
  function testRequire(uint _i) public {
    // Require should be used to validate conditions such as:
    // - inputs
    // - conditions before execution
    // - return values from calls to other functions
    require(_i > 10, 'Input must be greater than 10');
  }

  function testRevert(uint _i) public {
    // Revert is useful when the condition to check is complex.
    // This code does the exact same thing as the example above
    if (_i <= 10) {
      revert ('Input must be greater than 10');
    }
  }

  uint public num;
  function testAssert() public {
    // for internal check
    assert(num == 0);
  }
}

contract AboutFunctionModifier {
  /**
    Modifers can be used to
    - restrict access
    - validate input
    - guard againt reentrancy hack
   */
  address public owner;
  uint public x = 10;
  bool public locked;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'Not owner');
    _;
  }

  modifier validAddress(address _addr) {
    require(_addr != address(0), "Not valid address");
    _;
  }

  function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner) {
    owner = _newOwner;
  }

  modifier noReEnterancy() {
    require(!locked, 'No reenterancy');

    locked = true;
    _;
    locked = false;
  }

  function decrement(uint _i) public noReEnterancy {
    x -= i;
    if (i > 1) {
      decrement(i - 1);
    }
  }
}

contract AboutEvent {
  // Indexed parameters helps you filter the logs by the indexed parameter
  event Log(address indexed sender, string message);
  event AnotherLog();

  function test() public {
    emit Log(msg.sender, 'hello world!');
    emit Log(msg.sender, 'hello evm!');
    emit AnotherLog();
  }
}
