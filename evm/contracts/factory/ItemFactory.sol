// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

import {dTAGfactory} from "../dTAGfactory.sol";

import {IItem} from "../_i/IItem.sol";
import {ItemType, ItemAction} from "../dTAGconstants.sol";

/// @dev this contract is used on Flow to create new items
contract ItemFactory is Initializable, dTAGfactory {

  constructor() {}

  function initialize(
    address _manager, 
    address _implementation
  ) external initializer {
    __ERC721_init("dTAGitemFactory", "dTAGiF");
    __dTAGfactory_init(_manager, _implementation);
  }


  /// @notice creates a new DOORWAY or VIBE item
  function create(
    address _creator,
    string memory _name,
    string memory _image, 
    string memory _description,
    ItemType _itemType,
    ItemAction _itemAction,
    address _related,
    uint8 _cost,
    uint8 _cooldown
  ) external returns (address) {
    
    bytes memory data = abi.encodeWithSelector(
      IItem.initialize.selector,
      _creator, 
      gameManager,
      _name, 
      _image, 
      _description, 
      _cost, 
      _cooldown, 
      _itemType,
      _itemAction, 
      uint8(0),
      _related
    );
    
    return mint(_creator, data);
  }

  /// @notice creates a new STAT or GAMBLE item
  function create(
    address _creator,
    string memory _name,
    string memory _image,
    string memory _description,
    ItemType _itemType,
    ItemAction _itemAction,
    uint8 _value,
    uint8 _cost,
    uint8 _cooldown
  ) external returns (address) {

    bytes memory data = abi.encodeWithSelector(
      IItem.initialize.selector,
      _creator, 
      gameManager,
      _name, 
      _image, 
      _description, 
      _cost, 
      _cooldown, 
      _itemType,
      _itemAction,
      _value,
      address(0)
    );

    return mint(_creator, data);
  }

  /// @notice creates a new achievement item
  function create(
    address _creator,
    string memory _name,
    string memory _image,
    string memory _description
  ) external returns (address) {

    bytes memory data = abi.encodeWithSelector(
      IItem.initialize.selector,
      _creator, 
      gameManager,
      _name, 
      _image, 
      _description, 
      uint8(0),
      uint8(0),
      ItemType.ACHIEVEMENT,
      ItemAction.NONE,
      uint8(0),
      address(0)
    );

    return mint(_creator, data);
  }


  function getItem(uint256 _tokenId) external view returns (address) {
    return getElement(_tokenId);
  }

  uint256[50] private __gap;
}