// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

import {IItem} from "./_i/IItem.sol";
import {INPC} from "./_i/INPC.sol";
import {IDoorway} from "./_i/IDoorway.sol";
import {IRoom} from "./_i/IRoom.sol";
import {IAdventure} from "./_i/IAdventure.sol";

import {IPlayer} from "./_i/IPlayer.sol";
import {ICreator} from "./_i/ICreator.sol"; 

import {IdTAGuser} from "./_i/dTAG/IdTAGuser.sol";
import {IdTAGelement} from "./_i/dTAG/IdTAGelement.sol";


contract dTAGutils {

  // Errors



  // Randomness

  address constant public cadenceArch = 0x0000000000000000000000010000000000000001;

  /// @dev this is very Flow specific, we need a VRF for other chains
  function getRandom() public view returns (uint64) {

    (bool success, bytes memory data) = cadenceArch.call(abi.encodeWithSignature("revertibleRandom()"));
    require(success, "Failed to get random number");

    return abi.decode(data, (uint64));
  }


  // Type Checkers 

  function isElement(address _element) public view returns (bool) {
    return IERC165(_element).supportsInterface(type(IdTAGelement).interfaceId);
  }

  function isItem(address _element) public view returns (bool) {
    return IERC165(_element).supportsInterface(type(IItem).interfaceId);
  }

  function isNPC(address _element) public view returns (bool) {
    return IERC165(_element).supportsInterface(type(INPC).interfaceId);
  }

  function isDoorway(address _element) public view returns (bool) {
    return IERC165(_element).supportsInterface(type(IDoorway).interfaceId);
  }

  function isRoom(address _element) public view returns (bool) {
    return IERC165(_element).supportsInterface(type(IRoom).interfaceId);
  }

  function isAdventure(address _element) public view returns (bool) {
    return IERC165(_element).supportsInterface(type(IAdventure).interfaceId);
  }

  function isUser(address _user) public view returns (bool) {
    return IERC165(_user).supportsInterface(type(IdTAGuser).interfaceId);
  }

  function isPlayer(address _user) public view returns (bool) {
    return IERC165(_user).supportsInterface(type(IPlayer).interfaceId);
  }

  function isCreator(address _user) public view returns (bool) {
    return IERC165(_user).supportsInterface(type(ICreator).interfaceId);
  }
}