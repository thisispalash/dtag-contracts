// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract Utils {

  address constant public cadenceArch = 0x0000000000000000000000010000000000000001;

  function getRandom() public view returns (uint64) {

    (bool success, bytes memory data) = cadenceArch.call(abi.encodeWithSignature("revertibleRandom()"));
    require(success, "Failed to get random number");

    return abi.decode(data, (uint64));
  }

  function mint(address _to, uint256 _tokenId, address _contract) public {
    IERC721(_contract).mint(_to, _tokenId);
  }
}