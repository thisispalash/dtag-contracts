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

enum EffectType {
  NO_EFFECT,

  DEATH,
  REVIVE,

  HEALTH_UP,
  HEALTH_DOWN,
  ENERGY_UP,
  ENERGY_DOWN,

  TELEPORT,
  GET_ITEM
}

struct Effect {
  EffectType effect;
  uint8 value;
  address related;
}

// TODO below

enum ConditionType {

  ON_PEEK,

  ITEM_EXISTS,
  ITEM_DNE,

  ENTRY,
  EXIT,

  HEALTH_ABOVE,
  HEALTH_BELOW,
  HEALTH_EQUAL,
  ENERGY_ABOVE,
  ENERGY_BELOW,
  ENERGY_EQUAL
}

struct Condition {
  ConditionType condition;
  uint8 value;
  address related;
}

enum CommandType {
  // consumed by Adventure
  START,
  
  // consumed by Room
  PICK,
  DROP,
  PEEK,
  
  // consumed by Item
  USE,
  
  // consumed by Doorwau
  GO,
  
  // consumed by NPC
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