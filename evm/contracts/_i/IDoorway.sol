// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {Effect, EffectType} from "../dTAGconstants.sol";

interface IDoorway {

  struct DoorwayProperties {
    bool isEgg; // If true, the doorway is an easter egg, ie, hidden
    uint8 cost; // Cost to cross the doorway
    Effect effect;
  }

  event PathRegistered(string indexed direction, address indexed room);

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

  /**
   * Registers a path to a room.
   * 
   * @param _direction The direction of the doorway.
   * @param _room The address of the room to connect to
   */
  function registerPath(
    string memory _direction,
    address _room
  ) external;

  /**
   * Peeks the room connected to the given direction.
   * 
   * @param _direction The direction to peek in.
   * @return The name of the room connected to the given direction.
   */
  function peek(
    string memory _direction
  ) external view returns (string memory);

  /**
   * Crosses the doorway in the given direction. Doorway effect is applied to the player.
   * 
   * @param _direction The direction to cross.
   * @param _player The address of the player crossing the doorway.
   */
  function cross(
    string memory _direction,
    address _player
  ) external;
}
