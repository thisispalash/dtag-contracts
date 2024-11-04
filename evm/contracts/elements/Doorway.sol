// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {IDoorway} from "../_i/IDoorway.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {EffectType} from "../dTAGconstants.sol";
import {dTAGelement} from "../dTAGelement.sol";
import {dTAGutils} from "../dTAGutils.sol";

contract Doorway is Initializable, dTAGelement, IDoorway {

  DoorwayProperties private properties;

  mapping(bytes32 direction => address room) private directionToRoom;


  modifier validDirection(bytes32 _direction) {
    require(_direction.length > 0, "Direction cannot be empty");
    require(directionToRoom[_direction] != address(0), "Direction not registered");
    _;
  }

  constructor() {}

  function initialize(
    string memory _name,
    string memory _image,
    string memory _description,
    bool _isEgg,
    uint8 _cost,
    address _creator,
    address _manager,
    EffectType _effectType,
    uint8 _effectValue,
    address _effectRelated
  ) external 
    initializer 
  {
    __ERC721_init(_name, "dTAGd");
    __dTAGelement_init(_creator, _manager, uint256(0), _name, _image, _description);
    properties.cost = _cost;
    properties.isEgg = _isEgg;
    _assignEffect(_effectType, _effectValue, _effectRelated);
  }

  function registerPath(
    bytes32 _direction,
    address _room
  ) external 
    onlyManager 
    nonreentrant 
  {
    require(_isRoom(_room), "Given address is not a room");
    require(directionToRoom[_direction] == address(0), "Direction already registered");
    
    directionToRoom[_direction] = _room;

    emit PathRegistered(_direction, _room);
  }

  function peek(
    bytes32 _direction
  ) external 
    view 
    validDirection(_direction) 
    returns (string memory) 
  {
    return IRoom(directionToRoom[_direction]).name();
  }

  function cross(
    bytes32 _direction, 
    address _player
  ) external 
    nonreentrant 
    validDirection(_direction) 
  {
    require(IPlayer(_player).energy() >= properties.cost, "Insufficient energy to cross doorway");

    bool continueToRoom = _applyEffect(_player);

    if (continueToRoom) {
      IPlayer(_player).move(directionToRoom[_direction]);
    }
  }

  function describe() external view returns (string memory) {
    
    if (properties.isEgg) {
      return "";
    }
    
    else {
      return description;
    }
    
  }

  function _assignEffect(
    EffectType _effectType,
    uint8 _value,
    address _related
  ) private {

    if (_effectType == EffectType.NO_EFFECT) {
      properties.effect.effect = EffectType.NO_EFFECT;
      properties.effect.value = uint8(0);
      properties.effect.related = address(0);
    }

    else if (_effectType == EffectType.DEATH) {
      properties.effect.effect = EffectType.DEATH;
      properties.effect.value = uint8(0);
      properties.effect.related = address(0);
    }

    else if (_effectType == EffectType.REVIVE) {
      properties.effect.effect = EffectType.REVIVE;
      properties.effect.value = uint8(0);
      properties.effect.related = address(0);
    }

    else if (_effectType == EffectType.HEALTH_UP) {
      require(_value > 0, "Health value must be greater than 0");

      properties.effect.effect = EffectType.HEALTH_UP;
      properties.effect.value = _value;
      properties.effect.related = address(0);
    }

    else if (_effectType == EffectType.HEALTH_DOWN) {
      require(_value > 0, "Health value must be greater than 0");

      properties.effect.effect = EffectType.HEALTH_DOWN;
      properties.effect.value = _value;
      properties.effect.related = address(0);
    }

    else if (_effectType == EffectType.ENERGY_UP) {
      require(_value > 0, "Energy value must be greater than 0");

      properties.effect.effect = EffectType.ENERGY_UP;
      properties.effect.value = _value;
      properties.effect.related = address(0);
    }

    else if (_effectType == EffectType.ENERGY_DOWN) {
      require(_value > 0, "Energy value must be greater than 0");

      properties.effect.effect = EffectType.ENERGY_DOWN;
      properties.effect.value = _value;
      properties.effect.related = address(0);
    }

    else if (_effectType == EffectType.TELEPORT) {
      require(_related != address(0), "Related address cannot be 0");
      require(dTAGutils.isRoom(_related), "Related address is not a room");
      require(IRoom(_related).isWhitelisted(creator), "Creator has not licensed this room");

      properties.effect.effect = EffectType.TELEPORT;
      properties.effect.value = uint8(0);
      properties.effect.related = _related;
    }

    else if (_effectType == EffectType.GET_ITEM) {
      require(_related != address(0), "Related address cannot be 0");
      require(dTAGutils.isItem(_related), "Related address is not an item");
      require(IItem(_related).isWhitelisted(creator), "Creator has not licensed this item");

      properties.effect.effect = EffectType.GET_ITEM;
      properties.effect.value = uint8(0);
      properties.effect.related = _related;
    }

    else {
      revert("This effect type is invalid. Not sure how this happened.");
    }

  }

  function _applyEffect(address _player) internal returns (bool) {

    EffectType _type = properties.effect.effect;

    if (_type == EffectType.NO_EFFECT) {
      return true;
    }

    else if (_type == EffectType.DEATH) {
      IPlayer(_player).kill();
      return false;
    }

    else if (_type == EffectType.REVIVE) {
      IPlayer(_player).revive();
      return true;
    }

    else if (_type == EffectType.HEALTH_UP) {
      IPlayer(_player).healthUp(properties.effect.value);
      return true;
    }

    else if (_type == EffectType.HEALTH_DOWN) {
      IPlayer(_player).healthDown(properties.effect.value);
      return true;
    }

    else if (_type == EffectType.ENERGY_UP) {
      IPlayer(_player).energyUp(properties.effect.value);
      return true;
    }

    else if (_type == EffectType.ENERGY_DOWN) {
      IPlayer(_player).energyDown(properties.effect.value);
      return true;
    }

    else if (_type == EffectType.TELEPORT) {
      IPlayer(_player).move(properties.effect.related);
      return false;
    }

    else if (_type == EffectType.GET_ITEM) {
      IItem(properties.effect.related).mint(address(_player));
      return true;
    }

  }

  uint256[50] private __gap;
}