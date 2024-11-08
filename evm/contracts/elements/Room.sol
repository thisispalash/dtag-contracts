// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {IRoom} from "../_i/IRoom.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {CommandType} from "../dTAGconstants.sol";
import {dTAGelement} from "../dTAGelement.sol";

contract Room is Initializable, dTAGelement, IRoom {

  address private item;
  address[] private doorways;
  mapping(address receiver => DeadDrop deadDrop) private deadDrops;

  RoomProperties public properties;


  constructor() {}


  function initialize(
    address _creator,
    address _manager,
    string memory _name,
    string memory _image,
    string memory _description,
    address _item
  ) external initializer {
    __ERC721_init(_name, "dTAGr");
    __dTAGelement_init(_creator, _manager, uint256(0), _name, _image, _description);

    // check item
    require(_item != address(0), "Room: item cannot be the zero address");
    require(IItem(_item).isWhitelisted(_creator), "Creator has not licensed this item!");
    item = _item;
  }

  function registerDoorway(address _doorway) external {

  }


  function enter(address player) external {
    bool apply = _checkCondition(player);
    if (apply) {
      _applyEffect(player);
    }

    if (deadDrops[player].item != address(0)) {
      /// @todo do something here
    }
  }

  function peek(address player) external returns (string memory) {
    return description;
  }

  function interact(address player, CommandType action) external {

  }

  function describe() external returns (string memory) {
    return this.description;
  }


}