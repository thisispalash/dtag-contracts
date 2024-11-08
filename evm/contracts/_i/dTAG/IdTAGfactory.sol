// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

interface IdTAGfactory {

  struct ElementStruct {
    address creator;
    address element;
  }

  event ElementCreated(uint256 indexed tokenId, address indexed element, address indexed creator);

  function getElement(uint256 _tokenId) external view returns (address);

  function getCreator(uint256 _tokenId) external view returns (address);

}