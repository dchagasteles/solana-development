// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

/**
  Any contract that follow the ERC20 standard is a ERC20 token.
  ERC20 tokens provide functionalities to
  - transfer tokens
  - allow others to transfer tokens on behlaf of the token holders
 */

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MyToken is ERC20 {
  constructor (string memory name, string memory symbol) ERC20(name, symbol) {
    // mint 100 tokens to msg.sender
    _mint(msg.sender, 100 * 10 ** uint(decimals()));
  }
}

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
  IERC20 public token1;
  address public owner1;
  uint public amount1;
  IERC20 public token2;
  address public owner2;
  uint public amount2;

  constructor(
    address _token1,
    address _owner1,
    uint _amount1,
    address _token2,
    address _owner2,
    uint _amount2
  ) {
    token1 = IERC20(_token1);
    owner1 = _owner1;
    amount1 = _amount1;
    token2 = IERC20(_token2);
    owner2 = _owner2;
    amount2 = _amount2;
  }

  function swap() public {
    require(msg.sender == owner1 || msg.sender == owner2, 'not authorized');
    require(
      token1.allowance(owner1, address(this)) >= amount1,
      'Token 1 allowance too low'
    );
    require(
      token2.allowance(owner2, address(this)) >= amount2,
      'Token 2 allowance too low'
    );

    _safeTransferFrom(token1, owner1, owner2, amount1);
    _safeTransferFrom(token2, owner2, owner1, amount2);
  }

  function _safeTransferFrom(
    IERC20 token,
    address sender,
    address receipient,
    uint amount
  ) private {
    bool sent = token.transferFrom(sender, receipient, amount);
    require(sent, 'token transfer frailed');
  }
}