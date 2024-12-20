// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {Condition, Effect} from "../dTAGconstants.sol";

interface IRoom {

  struct RoomProperties {
    uint8 score;
    Condition condition;
    Effect effect;
  }

  struct DeadDrop {
    address item;
    address sender;
  }

  event ItemClaimed(address indexed item, address indexed claimer);
}
