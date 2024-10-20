// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Room} from "../Room.sol";

/// @dev this contract is used on Flow to create new Rooms
contract RoomFactory is ERC721 {

  struct RoomStruct {
    address creator;
    Room room;
  }

  uint256 tokenHeight;
  mapping(uint256 => RoomStruct) public tokenToRoom;

  constructor() ERC721("dextraRoom", "deR") {}

  function mint(
    address _creator,
    string memory _name, 
    string memory _description, 
    address[] memory _exits, 
    address _item
  ) external {

    Room i = new Room(_name, _description, _exits, _item);
    RoomStruct memory s = RoomStruct({
      creator: _creator,
      Room: i
    });

    tokenToRoom[tokenHeight] = s;

    _safeMint(_creator, tokenHeight);
    tokenHeight++;
  }
}