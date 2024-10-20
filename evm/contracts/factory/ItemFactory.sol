// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Item} from "../Item.sol";

/// @dev this contract is used on Flow to create new items
contract ItemFactory is ERC721 {

  struct ItemStruct {
    address creator;
    Item item;
  }

  uint256 tokenHeight;
  mapping(uint256 => ItemStruct) public tokenToItem;

  constructor() ERC721("dextraItem", "dIT") {}

  function mint(
    address _creator,
    string memory _name,
    string memory _image,
    string memory _description,
    uint8 _action,
    uint8 _value,
    uint8 _cost,
    uint8 _cooldown
  ) external {

    Item i = new Item(_name, _image, _description, _action, _value, _cost, _cooldown);
    ItemStruct memory s = ItemStruct({
      creator: _creator,
      item: i
    });

    tokenToItem[tokenHeight] = s;

    _safeMint(_creator, tokenHeight);
    tokenHeight++;
  }
}