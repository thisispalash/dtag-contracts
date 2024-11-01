// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

enum ItemType {
  DOORWAY,
  STAT,
  GAMBLE,
  VIBE,
  ACHIEVEMENT
}

enum ItemAction {
  NONE, // for achievements

  PEEK_DOOR, // peek all doors in the room
  
  HEALTH_UP,
  HEALTH_DOWN,
  ENERGY_UP,
  ENERGY_DOWN,
  
  GAMBLE_HEALTH,
  GAMBLE_ENERGY,
  VIBES // check outcome of gamble items
}

/** TODO below */

enum Condition {

  ON_PEEK,

  // Item based conditions, see ItemCondition struct
  ITEM_EXISTS,
  ITEM_DNE,

  // Room based conditions
  ENTRY,
  EXIT,
  
  // State based conditions, see StateCondition struct
  HEALTH_ABOVE,
  HEALTH_BELOW,
  HEALTH_EQUAL,
  ENERGY_ABOVE,
  ENERGY_BELOW,
  ENERGY_EQUAL
}

struct ItemCondition {
  Condition condition;
  address item;
}

struct StateCondition {
  Condition condition;
  uint8 value;
}

enum Effect {
  DEATH,
  HEALTH_UP,
  HEALTH_DOWN,
  ENERGY_UP,
  ENERGY_DOWN,
  TELEPORT,
  GET_ITEM
}

enum CommandType {
  START,
  PICK,
  DROP,
  USE,
  GO,
  PEEK,
  CHAT
}

enum Outcome {
  DISPLAY,
  FIND,
  DROP,
  DEATH,
  COMPLETE,
  HEALTH_UP,
  ENERGY_UP,
  HEALTH_DOWN,
  ENERGY_DOWN,
  CHAT
}

enum NPCType {
  ENTITY,
  COMPANION,
  ADVERSARY
}

abstract contract dTAGconstants {


}