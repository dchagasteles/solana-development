//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";

contract AboutStateVariables {
  // state: will be stored on blockchain
  uint public num = 123;

  // need to send a transaction to write a stete variable
  function setStateVariableNum(uint _num) public {
    num = _num;
  }

  // read from a state variable without sending a transaction
  function readStateVriableNum() public returns (uint) {
    return num;
  }

  function aboutStateVraiables() public {
    // local varaiables: will be not stored on blockchain
    uint i = 456;

    // global variables: info about blockchain
    uint timestamp = block.timestamp;
    address = sender = msg.sender;
  }
}

contract AboutMapping {
  // mapping from address to uint
  mapping(address => uint) public addressToUintMap;

  // netedMapping
  mapping(address => mapping(uint => bool)) public nested;

  function get(address _addr) public view returns (uint) {
    return addressToUintMap[_addr];
  }

  function set(address _addr, uint _v) public {
    addressToUintMap[_addr] = _v;
  }

  function remove(address _addr) public {
    delete addressToUintMap[_addr];
  }

  function getNested(address _addr, uint _i) public view returns (bool) {
    return nested[_addr][_i];
  }

  function setNested(address _addr, uint _i, bool _b) public {
    nested[_addr][_i] = _b;
  }

  function remove(address _addr, uint _i) public {
    delete nested[_addr][_i];
  }
}

contract AboutMapping {
  uint[] public arr;
  uint[] public arr2 = [1, 2, 3];
  uint[10] public fixedSizeArr;

  function get(uint i) public view returns (uint) {
    return arr[i];
  }

  // Solidity can return the entire array.
  // But this function should be avoided for
  // arrays that can grow indefinitely in length.
  function getArr() public view returns (uint[] memory) {
    return arr;
  }

  function aboutArrayActions() {
    arr.push(1);
    arr.pop();
    uint length = arr.length;

    arr.push(1);
    delete arr[0];
  }

  // Deleting an element creates a gap in the array.
  // One trick to keep the array compact is to
  // move the last element into the place to delete.
  function removeWithoutGap(uint index) public {
    arr[index] = arr[arr.length - 1];
    arr.pop();
  }

  function test() public {
    arr.push(1);
    arr.push(2);
    arr.push(3);
    arr.push(4);
    // [1, 2, 3, 4]

    remove(1);
    // [1, 4, 3]

    remove(2);
    // [1, 4]
  }
}

contract AboutEnum {
  enum Status {
    Pending,
    Shiped,
    Accepted,
    Rejected,
    Canceled
  }

  // default value is the first element
  // in out case, its "Pending"
  Status public status;

  struct Todo {
    string text;
    bool completed;
  }

  Todo[] public todos;
}

contract DataLocations {
  uint[] public arr;
  mapping(uint => address) map;
  struct MyStruct {
    uint foo;
  }
  enum MyEnum {
    Pending
  }
  mapping(uint => MyStruct) mystructs;

  function basicIntro() public {
    // storage: state vriables are stored on storage
    // memory: exist while function is being called
    // calldata: special data location that contains function arguments, only for external functions
  }

  function returnMemoryVariable(uint[] memory _arr) public returns (uint[] memory) {
    /**
      return meory variable
     */
  }

  function doWithCallData(uint[] calldata _arr) external {
  }
}