// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Game} from "../Game.sol";

/// @dev this contract is used on Flow to create new Games
contract GameFactory is ERC721 {

  struct GameStruct {
    address creator;
    Game game;
  }

  uint256 tokenHeight;
  mapping(uint256 => GameStruct) public tokenToGame;

  constructor() ERC721("dextraGame", "deG") {}

  function mint(
    address _creator,
    string memory _title, 
    string memory _description, 
    address[] memory _rooms, 
    address _ip, 
    bool _randomSpawn, 
    address _start_room, 
    address _end_room, 
    address _achievement, 
    uint256 _price
  ) external {

    Game g = new Game(_title, _description, _rooms, _ip, _randomSpawn, _start_room, _end_room, _achievement, _price);
    GameStruct memory s = GameStruct({
      creator: _creator,
      game: g
    });

    tokenToGame[tokenHeight] = s;

    _safeMint(_creator, tokenHeight);
    tokenHeight++;
  }
}