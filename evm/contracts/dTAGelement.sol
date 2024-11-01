// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC165Upgradeable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {IItem} from "../_i/IItem.sol";
import {INPC} from "../_i/INPC.sol";
import {IDoorway} from "../_i/IDoorway.sol";
import {IRoom} from "../_i/IRoom.sol";
import {IAdventure} from "../_i/IAdventure.sol";
import {IPlayer} from "../_i/IPlayer.sol";

abstract contract dTAGelement is Initializable, ERC721Upgradeable, AccessControlUpgradeable, ReentrancyGuardUpgradeable {

  address public creator;
  address public gameManager;
  
  uint256 public price;
  uint256 public tokenHeight;
  mapping(uint256 tokenId => address) public owners;

  bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
  bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
  bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");

  modifier onlyManagerOrCreator() {
    _checkRole(MANAGER_ROLE);
    _checkRole(CREATOR_ROLE);
    _;
  }

  constructor() {}

  function __dTAGelement_init(
    address _creator, 
    address _manager,
    uint256 _price
  ) internal onlyInitializing {
    __AccessControl_init();
    gameManager = _manager;
    creator = _creator;
    price = _price;
    _grantRole(CREATOR_ROLE, _creator); // for withdrawals
    _grantRole(MANAGER_ROLE, _manager);
    _grantRole(WHITELIST_ROLE, _creator); // for IP protection
  }

  /** Element Functions */

  function mint(address to) external payable {
    this.mint(to, tokenHeight++);
  }

  function mint(address to, uint256 tokenId) external payable {
    
    require(msg.value > price, "Insufficient funds sent");

    _safeMint(to, tokenId);
    owners[tokenId] = to;

    // ~6.25% to dTAG treasury for sponsoring gas
    uint256 treasuryAmount = msg.value >> 4;
    payable(gameManager).transfer(treasuryAmount);

    if (msg.value > price) {
      payable(msg.sender).transfer(msg.value - price);
    }

  }

  /// @notice Withdraws the balance of the game element to the creator of the element
  function withdraw() external onlyManagerOrCreator() {
    payable(creator).transfer(address(this).balance);
  }


  /** Game Manager Functions */

  function updateManager(address _manager) external onlyRole(MANAGER_ROLE) {
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
  function canInclude(address _creator) public view returns (bool) {
    return hasRole(WHITELIST_ROLE, _creator);
  }

  function addToWhitelist(address _creator) external onlyRole(MANAGER_ROLE) {
    _grantRole(WHITELIST_ROLE, _creator);
  }

  function removeFromWhitelist(address _creator) external onlyRole(MANAGER_ROLE) {
    _revokeRole(WHITELIST_ROLE, _creator);
  }


  /** ERC165 stuff */

  function _isItem() internal view returns (bool) {
    return IERC165Upgradeable(address(this)).supportsInterface(type(IItem).interfaceId);
  }

  function _isNPC() internal view returns (bool) {
    return IERC165Upgradeable(address(this)).supportsInterface(type(INPC).interfaceId);
  }

  function _isDoorway() internal view returns (bool) {
    return IERC165Upgradeable(address(this)).supportsInterface(type(IDoorway).interfaceId);
  }

  function _isRoom() internal view returns (bool) {
    return IERC165Upgradeable(address(this)).supportsInterface(type(IRoom).interfaceId);
  }

  function _isAdventure() internal view returns (bool) {
    return IERC165Upgradeable(address(this)).supportsInterface(type(IAdventure).interfaceId);
  }

  function _isPlayer() internal view returns (bool) {
    return IERC165Upgradeable(address(this)).supportsInterface(type(IPlayer).interfaceId);
  }

  function supportsInterface(bytes4 interfaceId) 
    public view 
    virtual
    override(AccessControlUpgradeable, ERC721Upgradeable) 
    returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  uint256[50] private __gap;
}
