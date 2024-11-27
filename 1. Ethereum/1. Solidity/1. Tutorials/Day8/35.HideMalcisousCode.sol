// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

/**
  Vulnerability
  - In Solidity any address can be casted into specific contract,
  even if the contract at the address is not the one being casted.
  
  - This can be exploited to hide malicious code. Let's see how.
 */

/*
  Let's say Alice can see the code of Foo and Bar but not Mal.
  It is obvious to Alice that Foo.callBar() executes the code inside Bar.log().
  However Eve deploys Foo with the address of Mal, so that calling Foo.callBar()
  will actually execute the code at Mal.
  */

  /*
  1. Eve deploys Mal
  2. Eve deploys Foo with the address of Mal
  3. Alice calls Foo.callBar() after reading the code and judging that it is
    safe to call.
  4. Although Alice expected Bar.log() to be execute, Mal.log() was executed.
*/

contract Foo {
  Bar bar;
  constructor(address _bar) {
    bar = Bar(_bar);
  }

  function callBar() public {
    bar.log();
  }
}

contract Bar {
  event Log(string message);

  function log() public {
    emit Log('Bar was called');
  }
}

contract Mail {
  event Log(string message);

  // function () external {
  //     emit Log("Mal was called");
  // }

  // Actually we can execute the same exploit even if this function does
  // not exit by using the fallback
  function log() public {
    emit Log("Mal was called");
  }
}

/**
  Preventative Techniques
  - Initialize a new contract inside the constructor
  - Make the address of external contract public so that the code of the external contract can be reviewed
 */

Bar public bar;

constructor() public {
  bar = new Bar();
}
