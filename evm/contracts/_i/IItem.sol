// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ItemType, ItemAction} from "../dTAGconstants.sol";

interface IItem {

  struct ItemProperties {
    uint8 cost; // Energy spent in using
    uint8 cooldown; // Turns to wait before using again
    ItemType itemType;
    ItemAction itemAction;
    uint8 value; // For stat related actions
    address related; // Address of a related element, like a door or a gamble item
  }


  event ItemInitialized(
    address indexed creator,
    address manager,
    string indexed name,
    string image,
    string description,
    uint8 cost,
    uint8 cooldown,
    ItemType itemType,
    ItemAction indexed itemAction,
    uint8 value,
    address related
  );


  function initialize(
    address _creator,
    address _manager,
    string memory _name,
    string memory _image,
    string memory _description,
    uint8 _cost,
    uint8 _cooldown,
    ItemType _itemType,
    ItemAction _itemAction,
    uint8 _value,
    address _related
  ) external;

  function itemAction() external view returns (ItemAction);

  function itemType() external view returns (ItemType);

  function use(address player) external;
}
