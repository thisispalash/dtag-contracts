// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";


interface IdTAGelement is IERC165 {




  function withdraw() external;

  function describe() external view returns (string memory);

  function updateManager(address _manager) external;


  function isWhitelisted(address _creator) external view returns (bool);

  function addToWhitelist(address _creator) external;

  function removeFromWhitelist(address _creator) external;
  
}
