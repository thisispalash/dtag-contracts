// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

contract Exit is ERC721 {

  bool isEgg; // If true, the exit is an easter egg, ie, hidden
  mapping(string => address) directionToRoom;

  uint256 tokenHeight;


  constructor(bool _isEgg) {
    isEgg = _isEgg;
  }

  function peek(address player) external returns (string memory) {
    if (isEgg) {
      Utils.mint(Player(player).owner(), tokenHeight++, address(this));
    }
    return Room(room).description();
  }

}