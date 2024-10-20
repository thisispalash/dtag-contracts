// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Command} from "../Command.sol";

/// @dev this contract is used on Flow to create new Commands
contract CommandFactory is ERC721 {

  struct CommandStruct {
    address creator;
    Command cmd;
  }

  uint256 tokenHeight;
  mapping(uint256 => CommandStruct) public tokenToCommand;

  constructor() ERC721("dextraCommand", "deC") {}

  function mint(
    address _creator,
    string memory _name, 
    address _requires, 
    address _ip, 
    CommandType _ability
  ) external {

    Command c = new Command(_name, _requires, _ip, _ability);
    CommandStruct memory s = CommandStruct({
      creator: _creator,
      cmd: c
    });

    tokenToCommand[tokenHeight] = s;

    _safeMint(_creator, tokenHeight);
    tokenHeight++;
  }
}