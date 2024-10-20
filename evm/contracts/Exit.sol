// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

contract Exit is ERC721 {

  string direction;
  address room;
  bool isEgg; // If true, the exit is an easter egg, ie, hidden
  address ip;

  uint256 tokenHeight;


  constructor(string memory _direction, address _room, bool _isEgg) {
    direction = _direction;
    room = _room;
    isEgg = _isEgg;
  }

  function peek(address player) external returns (string memory) {
    if (isEgg) {
      Utils.mint(Player(player).owner(), tokenHeight++, address(this));
    }
    return Room(room).description();
  }

}