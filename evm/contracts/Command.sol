// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;


enum CommandType {

  PICK,

  DROP,

  USE,

  START,

  GO,

  PEEK

}


contract Command {

  string name;
  address requires;
  address ip;
  CommandType ability;

  constructor(string memory _name, address _requires, address _ip, CommandType _ability) {
    name = _name;
    requires = _requires;
    ip = _ip;
    for (uint8 i=0; i < 6; i++) {
      uint8 mask = 1 << i;
      if (_ability & mask != 0) {
        ability = CommandType(i);
      }
    }
  }

  function execute(address game, address player, address args) external {


    if (ability == CommandType.PICK) {
      Game(game).pickItem(player, args);
    } else if (ability == CommandType.DROP) {
      Game(game).dropItem(player, args);
    } else if (ability == CommandType.USE) {
      Game(game).useItem(player, args);
    } else if (ability == CommandType.START) {
      Game(game).startGame(player);
    } else if (ability == CommandType.GO) {
      Game(game).exitRoom(player, args);
    } else if (ability == CommandType.PEEK) {
        if (IERC721().balanceOf(Player(player).owner()) > 0) {
          Game(game).peekDoor(player, args);
        }
    }
    
  }

}