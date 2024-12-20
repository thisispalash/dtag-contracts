// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

interface IPlayer {



  /**
   * @notice Get the player's current energy
   * 
   * @return uint8 the player's current energy
   */
  function energy() external view returns (uint8);

  /**
   * @notice Get the player's current health
   * 
   * @return uint8 the player's current health
   */
  function health() external view returns (uint8);

  /**
   * @notice Get the player's current turn
   * 
   * @return uint256 the player's current turn
   */
  function turn() external view returns (uint256);


  /**
   * @notice Increase the player's energy
   * 
   * @param _value uint8 the amount to increase the player's energy by
   */
  function energyUp(uint8 _value) external;

  /**
   * @notice Decrease the player's energy
   * 
   * @param _value uint8 the amount to decrease the player's energy by
   */
  function energyDown(uint8 _value) external;

  /**
   * @notice Increase the player's health
   * 
   * @param _value uint8 the amount to increase the player's health by
   */
  function healthUp(uint8 _value) external;

  /**
   * @notice Decrease the player's health
   * 
   * @param _value uint8 the amount to decrease the player's health by
   */
  function healthDown(uint8 _value) external;

  /**
   * @notice Kill the player, ie, set health to 0
   */
  function kill() external;

  /**
   * @notice Revive the player, ie, set health to 255
   */
  function revive() external;


  /**
   * @notice Move the player to a given room
   * 
   * @param _room address of the room to move the player to
   */
  function move(address _room) external;
}