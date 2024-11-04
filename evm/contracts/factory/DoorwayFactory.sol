// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";

import {dTAGfactory} from "../dTAGfactory.sol";

import {IDoorway} from "../_i/IDoorway.sol";
import {EffectType} from "../dTAGconstants.sol";

/// @dev this contract is used on Flow to create new Exits
contract DoorwayFactory is Initializable, dTAGfactory {

  constructor() {}

  function initialize(
    address _manager,
    address _implementation
  ) external initializer {
    __ERC721_init("dTAGdoorwayFactory", "dTAGdF");
    __dTAGfactory_init(_manager, _implementation);
  }


  /// @notice create function for effect types that don't require a related address or value
  function create(
    address _creator,
    string memory _name,
    string memory _image,
    string memory _description,
    bool _isEgg,
    uint8 _cost,
    EffectType _effectType
  ) external returns (address) {

    bytes memory data = abi.encodeWithSelector(
      IDoorway.initialize.selector,
      _creator,
      gameManager,
      _name,
      _image,
      _description,
      _isEgg,
      _cost,
      _effectType,
      uint8(0),
      address(0)
    );

    return mint(_creator, data);
  }

  /// @notice create function for effect types that require a value
  function create(
    address _creator,
    string memory _name,
    string memory _image,
    string memory _description,
    bool _isEgg,
    uint8 _cost,
    EffectType _effectType,
    uint8 _effectValue
  ) external returns (address) {

    bytes memory data = abi.encodeWithSelector(
      IDoorway.initialize.selector,
      _creator,
      gameManager,
      _name,
      _image,
      _description,
      _isEgg,
      _cost,
      _effectType,
      _effectValue,
      address(0)
    );

    return mint(_creator, data);
  }

  /// @notice create function for effect types that require a related address
  function create(
    address _creator,
    string memory _name,
    string memory _image,
    string memory _description,
    bool _isEgg,
    uint8 _cost,
    EffectType _effectType,
    address _effectRelated
  ) external returns (address) {

    bytes memory data = abi.encodeWithSelector(
      IDoorway.initialize.selector,
      _creator,
      gameManager,
      _name,
      _image,
      _description,
      _isEgg,
      _cost,
      _effectType,
      uint8(0),
      _effectRelated
    );

    return mint(_creator, data);
  }


  function getDoorway(uint256 _tokenId) external view returns (address) {
    return getElement(_tokenId);
  }

  uint256[50] private __gap;
}