// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {Effect, EffectType} from "../dTAGconstants.sol";

interface IDoorway {

  struct DoorwayProperties {
    bool isEgg; // If true, the doorway is an easter egg, ie, hidden
    uint8 cost; // Cost to cross the doorway
    Effect effect;
  }

  event PathRegistered(bytes32 indexed direction, address indexed room);

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
  ) external;

  function registerPath(
    bytes32 _direction,
    address _room
  ) external;

  function peek(
    bytes32 _direction
  ) external view returns (string memory);

  function cross(
    bytes32 _direction,
    address _player
  ) external returns (string memory);
}
