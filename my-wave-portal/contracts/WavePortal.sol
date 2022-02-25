// SPDX-License-Identifier: UNLICENSED

// smart contracts are immutable. They can't change. They're permanent. That means changing a contract requires a full redeploy. This will also reset all the variables since it'd be treated as a brand new contract. That means we'd lose all our wave data if we wanted to update the contract's code.

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint256 totalWaves;
  address payable public owner;

  event NewWave(address indexed from, uint256 timestamp, string message, string name);

  struct Wave {
    address waver; // the address of the user who waved
    string message; // the message the user sent
    string name;
    uint256 timestamp; // the timestamp when the user waved
  }

  Wave[] waves; // this is what lets me hold all the waves anyone ever sends to me

    /*
    * This is an address => uint mapping, meaning I can associate an address with a number!
    * In this case, I'll be storing the address with the last time the user waved at us.
    */
    mapping(address => uint256) public lastWavedAt;

  constructor() payable {
      console.log("wave!!");

      owner = payable(msg.sender);
  }

    function wave(
        string memory _message,
        string memory _name,
        uint256 _payAmount
    ) public payable {
        uint256 cost = 0.001 ether;
        require(_payAmount <= cost, "Insufficient Ether provided");

        totalWaves += 1;
        console.log("%s has just waved!", msg.sender);

        /*
         * This is where I actually store the coffee data in the array.
         */
        waves.push(Wave(msg.sender, _message, _name, block.timestamp));

        (bool success, ) = owner.call{value: _payAmount}("");
        require(success, "Failed to send money");

        emit NewWave(msg.sender, block.timestamp, _message, _name);
    }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
      console.log("we have %d total waves", totalWaves);
      return totalWaves;
  }
}