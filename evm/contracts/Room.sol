// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;


contract Room is ERC721 {

  string name;
  string description;
  address[] exits;
  address item;
  address ip;

  uint256 tokenHeight;

  constructor(string memory _name, string memory _description, address[] memory _exits, address _item, address _ip) {
    name = _name;
    description = _description;
    exits = _exits;
    item = _item;
    ip = _ip;
  }

  function peek(address player) external returns (string memory) {
    return description;
  }

  function pick(address player) external {
    if (item != address(0)) {
      Item(item).mint(Player(player).owner());
    }
  }

}