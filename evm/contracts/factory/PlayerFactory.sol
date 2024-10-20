// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Player} from "../Player.sol";

/// @dev this contract is used on Flow to create new Players
contract PlayerFactory is ERC721 {

  struct PlayerStruct {
    address creator;
    Player player;
  }

  uint256 tokenHeight;
  mapping(uint256 => PlayerStruct) public tokenToPlayer;

  constructor() ERC721("dextraPlayer", "deP") {}

  function mint(address _creator) external {

    Player p = new Player(_creator);
    PlayerStruct memory s = PlayerStruct({
      creator: _creator,
      Player: p
    });

    tokenToPlayer[tokenHeight] = s;

    _safeMint(_creator, tokenHeight);
    tokenHeight++;
  }
}