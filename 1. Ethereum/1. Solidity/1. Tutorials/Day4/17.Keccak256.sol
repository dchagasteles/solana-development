// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;


/**
  keccak256 computes the Keccak-256 hash of the input

  Some use cases are:
  - creating a deterministic unique ID from input
  - commit-reval scheme
  - compact cryptographic signature (by signing the hash instead of a larger input)
 */

 contract HashContract {
   function hash(string memory _text, uint _name, address _addr) public pure returns (bytes32) {
     return keccak256(abi.encodePacked(_text, _name, _addr));
   }

  // Example of hash collision
  // Hash collision can occur when you pass more than one dynamic data type
  // to abi.encodePacked. In such case, you should use abi.encode instead.
  function collision(string memory _text, string memory _anotherText) public pure returns (bytes32) {
    // encodePacked(AAA, BBB) -> AAABBB
    // encodePacked(AA, ABBB) -> AAABBB

    return keccak256(abi.encodePacked(_text, _anotherText));
  }
 }

 contract GuessTheMagicWord {
   bytes32 public answer = 0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

   // Magic word is "Solidity"
   function guess(string memory _word) public view returns(bool) {
     return keccak256(abi.encodePacked(_word)) == answer;
   }
 }