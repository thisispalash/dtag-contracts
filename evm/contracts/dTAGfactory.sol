// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {ERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";

import {IdTAGfactory} from "./_i/dTAG/IdTAGfactory.sol";

abstract contract dTAGfactory is 
  Initializable, 
  ERC165Upgradeable, 
  ERC721Upgradeable, 
  IdTAGfactory 
{

  address public gameManager;

  uint256 public tokenHeight;
  mapping(uint256 tokenId => ElementStruct) public tokenToElement;

  UpgradeableBeacon public beacon;

  constructor() {}

  function __dTAGfactory_init(
    address _manager, 
    address _impl
  ) internal onlyInitializing {
    gameManager = _manager;
    beacon = new UpgradeableBeacon(_impl, _manager);
  }

  function mint(address _creator, bytes memory _data) internal returns (address) {

    BeaconProxy proxy = new BeaconProxy(
      address(beacon),
      _data
    );

    uint256 tokenId = tokenHeight;

    tokenToElement[tokenId] = ElementStruct({
      creator: _creator,
      element: address(proxy)
    });

    _safeMint(_creator, tokenId);

    emit ElementCreated(tokenId, address(proxy), _creator);

    tokenHeight++;

    return address(proxy);
  }

  function getElement(uint256 _tokenId) public view returns (address) {
    require(_tokenId < tokenHeight, "Element does not exist");
    return tokenToElement[_tokenId].element;
  }

  function getCreator(uint256 _tokenId) public view returns (address) {
    require(_tokenId < tokenHeight, "Element does not exist");
    return tokenToElement[_tokenId].creator;
  }


  /** ERC standard(s) compliance functions */

  function supportsInterface(bytes4 interfaceId) 
    public view 
    override(ERC165Upgradeable, ERC721Upgradeable) 
    returns (bool) {
    return interfaceId == type(IdTAGfactory).interfaceId 
      || super.supportsInterface(interfaceId);
  }

  uint256[50] private __gap;
}
