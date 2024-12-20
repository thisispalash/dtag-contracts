// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

import {dTAGfactory} from "../dTAGfactory.sol";

import {IRoom} from "../_i/IRoom.sol";

/// @dev this contract is used on Flow to create new Rooms
contract RoomFactory is Initializable, dTAGfactory {

  constructor() {}

  function initialize(
    address _manager,
    address _implementation
  ) external initializer {
    __ERC721_init("dTAGroomFactory", "dTAGrF");
    __dTAGfactory_init(_manager, _implementation);
  }

  function create(

  ) external returns (address) {

  }

  function getRoom(uint256 _tokenId) external view returns (address) {
    return getElement(_tokenId);
  }

  uint256[50] private __gap;
}