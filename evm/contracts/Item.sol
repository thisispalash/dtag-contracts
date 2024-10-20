// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {Utils} from "./Util.sol";
import {Player} from "./Player.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";


enum ItemAction {
  
  // Describes what lays beyond a direction
  PEEK_DOOR,

  // Chat with an NPC
  NPC_CHAT,

  // Increase health by {value}
  HEALTH,

  // Increase energy by {value}
  ENERGY,

  // May increase health or decrease it by {value}
  GAMBLE_HEALTH,
  
  // May increase energy or decrease it by {value}
  GAMBLE_ENERGY,

  // Simulate a gamble item, only positive outcome is applied
  SCRY,

  // Achievement item
  END_GAME
}


contract Item is ERC721 {

  string name;
  string image;
  string description;
  ItemAction action;
  uint8 value; // For certain actions
  uint8 cost; // Energy spent in using
  uint8 cooldown; // Turns to wait before using again
  address ip; // address of corresponding ip on story

  uint256 tokenHeight;

  constructor(
    string memory _name,
    string memory _image,
    string memory _description,
    uint8 _action,
    uint8 _value,
    uint8 _cost,
    uint8 _cooldown,
    address _ip
  ) {
    name = _name;
    image = _image;
    description = _description;
    value = _value;
    cost = _cost;
    cooldown = _cooldown;
    ip = _ip;
    for (uint8 i=0; i < 8; i++) {
      uint8 mask = 1 << i;
      if (_action & mask != 0) {
        action = ItemAction(i);
      }
    }
  }

  function use(address player) external {


    if (action == ItemAction.PEEK_DOOR) {

    } else if (action == ItemAction.NPC_CHAT) {
      revert('Not implemented');
    } else if (action == ItemAction.HEALTH) {
      Player(player).health_up(value);
    } else if (action == ItemAction.ENERGY) {
      Player(player).energy_up(value);
    } else if (action == ItemAction.GAMBLE_HEALTH) {
      uint64 random = Utils.getRandom();
      if (random & 1) { // that's odd
        Player(player).health_up(value);
      } else {
        Player(player).health_down(value);
      }
    } else if (action == ItemAction.GAMBLE_ENERGY) {
      uint64 random = Utils.getRandom();
      if (random & 1) { // that's odd
        Player(player).energy_up(value);
      } else {
        Player(player).energy_down(value);
      }
    } else if (action == ItemAction.SCRY) {
      uint64 random = Utils.getRandom();
      if (!(random & 1)) {
        Player(player).energy_up(value);
      }
    } else if (action == ItemAction.END_GAME) {
      Utils.mint(Player(player).owner(), tokenHeight++, address(this));
    }

  }

  function mint(address to) external {
    Utils.mint(to, tokenHeight++, address(this));
    uint256 tokenId = tokenHeight - 1;
    address ipId = IP_ASSET_REGISTRY.register(block.chainid, address(SIMPLE_NFT), tokenId);
  }
}