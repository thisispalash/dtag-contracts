// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Exit} from "../Exit.sol";

/// @dev this contract is used on Flow to create new Exits
contract ExitFactory is ERC721 {

  struct ExitStruct {
    address creator;
    Exit exit;
  }

  uint256 tokenHeight;
  mapping(uint256 => ExitStruct) public tokenToExit;

  constructor() ERC721("dextraExit", "deX") {}

  function mint(
    address _creator,
    string memory _direction, 
    address _room, 
    bool _isEgg
  ) external {

    Exit e = new Exit(_direction, _room, _isEgg);
    ExitStruct memory s = ExitStruct({
      creator: _creator,
      exit: e
    });

    tokenToExit[tokenHeight] = s;

    _safeMint(_creator, tokenHeight);
    tokenHeight++;
  }
}