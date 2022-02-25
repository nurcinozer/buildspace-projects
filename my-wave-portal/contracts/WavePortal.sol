// SPDX-License-Identifier: UNLICENSED

// smart contracts are immutable. They can't change. They're permanent. That means changing a contract requires a full redeploy. This will also reset all the variables since it'd be treated as a brand new contract. That means we'd lose all our wave data if we wanted to update the contract's code.

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
  uint256 totalWaves;
  uint256 private seed;

  event NewWave(address indexed from, uint256 timestamp, string message);

  struct Wave {
    address waver; // the address of the user who waved
    string message; // the message the user sent
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

      seed = (block.timestamp + block.difficulty) % 100;
  }

  function wave(string memory _message) public {
    // totalWaves += 1;

    // console.log("%s waved w/ message %s", msg.sender, _message); // This is the message our user sends us from the frontend!

    // waves.push(Wave(msg.sender, _message, block.timestamp));

    // seed = (block.difficulty + block.timestamp + seed) % 100;

    // console.log("Random # generated: %d", seed);

        /*
        * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
        */
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

    if (seed <= 50) {
      console.log("%s won!", msg.sender);

      uint256 prizeAmount = 0.0001 ether;
      require( // checks to see that some condition is true
          prizeAmount <= address(this).balance, // address(this).balance is the balance of the contract itself.
          "Trying to withdraw more money than the contract has."
      );
      (bool success, ) = (msg.sender).call{value: prizeAmount}(""); // we send money
      require(success, "Failed to withdraw money from contract.");
    }

    emit NewWave(msg.sender, block.timestamp, _message);
  }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint256) {
      console.log("we have %d total waves", totalWaves);
      return totalWaves;
  }
}