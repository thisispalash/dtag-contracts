// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;


contract Player is ERC721 {

  address owner;
  uint8 health;
  uint8 energy;
  address ip;

  constructor(address _owner, address _ip) {
    owner = _owner;
    health = 255;
    energy = 255;
    ip = _ip;
  }

  function health_up(uint8 value) external {
    health += value;
  }

  function health_down(uint8 value) external {
    health -= value;
  }

  function energy_up(uint8 value) external {
    energy += value;
  }

  function energy_down(uint8 value) external {
    energy -= value;
  }

  function owner() external view returns (address) {
    return owner;
  }

}