// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {ERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {IItem} from "../_i/IItem.sol";
import {INPC} from "../_i/INPC.sol";
import {IDoorway} from "../_i/IDoorway.sol";
import {IRoom} from "../_i/IRoom.sol";
import {IAdventure} from "../_i/IAdventure.sol";
import {IPlayer} from "../_i/IPlayer.sol";

import {IdTAGelement} from "./IdTAGelement.sol";

abstract contract dTAGelement is 
  Initializable, 
  ERC165Upgradeable, 
  ERC721Upgradeable, 
  AccessControlUpgradeable, 
  ReentrancyGuardUpgradeable, 
  IdTAGelement 
{

  string public name;
  string public image;
  string public description;

  address public creator;
  address public gameManager;
  
  uint256 public price;
  uint256 public tokenHeight;
  mapping(uint256 tokenId => address) public owners;

  bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
  bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
  bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");

  modifier onlyManager() {
    _checkRole(MANAGER_ROLE);
    _;
  }

  modifier onlyManagerOrCreator() {
    _checkRole(MANAGER_ROLE);
    _checkRole(CREATOR_ROLE);
    _;
  }

  constructor() {}

  function __dTAGelement_init(
    address _creator, 
    address _manager,
    uint256 _price,
    string memory _name,
    string memory _image,
    string memory _description
  ) internal onlyInitializing {
    __ERC165_init();
    __AccessControl_init();
    __ReentrancyGuard_init();
    gameManager = _manager;
    creator = _creator;
    price = _price;
    name = _name;
    image = _image;
    description = _description;
    _grantRole(CREATOR_ROLE, _creator); // for withdrawals
    _grantRole(MANAGER_ROLE, _manager);
    _grantRole(WHITELIST_ROLE, _creator); // for IP protection
  }

  /** Element Functions */

  function mint(address to) internal payable {
    this.mint(to, tokenHeight++);
  }

  function mint(address to, uint256 tokenId) internal payable {
    
    require(msg.value >= price, "Insufficient funds sent");

    _safeMint(to, tokenId);
    owners[tokenId] = to;

    // ~6.25% to dTAG treasury for sponsoring gas
    if (price > 0) {
      uint256 treasuryAmount = price >> 4;
      payable(gameManager).transfer(treasuryAmount);
    }

    // Return any excess funds to the sender
    if (msg.value > price) {
      // should this be msg.sender?
      payable(msg.sender).transfer(msg.value - price);
    }

  }

  /// @notice Withdraws the balance of the game element to the creator of the element
  function withdraw() external onlyManagerOrCreator nonreentrant {
    payable(creator).transfer(address(this).balance);
  }

  /** Game Manager Functions */

  function updateManager(address _manager) external onlyManager {
    require(_manager != address(0), "New manager cannot be the zero address");
    _revokeRole(MANAGER_ROLE, gameManager);
    gameManager = _manager;
    _grantRole(MANAGER_ROLE, _manager);
  }


  /** Whitelist Functions 
   * 
   * The whitelist role is used to sync with IP protections from Story.
   * On licensing an element, the creator address is added to the whitelist.
   * 
   * Before an adventure is created, we check if the creator is on the whitelist to ensure IP protection.
   * 
   */

  /// @notice checks if a creator can include this item in their adventure
  function isWhitelisted(address _creator) public view returns (bool) {
    return hasRole(WHITELIST_ROLE, _creator);
  }

  function addToWhitelist(address _creator) external onlyManager {
    _grantRole(WHITELIST_ROLE, _creator);
  }

  function removeFromWhitelist(address _creator) external onlyManager {
    _revokeRole(WHITELIST_ROLE, _creator);
  }


  /** ERC standard(s) compliance functions */

  function supportsInterface(bytes4 interfaceId) 
    public view 
    virtual
    override(ERC165Upgradeable, ERC721Upgradeable, AccessControlUpgradeable) 
    returns (bool) {
    return 
      interfaceId == type(IdTAGelement).interfaceId 
      || super.supportsInterface(interfaceId);
  }

  uint256[50] private __gap;
}
