// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

enum ElementType {
  ITEM,
  DOORWAY,
  NPC,
  ROOM,
  ADVENTURE
}

error ZeroAddressNotAllowed();

error NotLicensed(ElementType elementType, address element, address creator);

error IncorrectType(ElementType expected, ElementType given, address element);
