// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {IItem} from "../_i/IItem.sol";
import {IDoorway} from "../_i/IDoorway.sol";
import {IPlayer} from "../_i/IPlayer.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {ItemType, ItemAction} from "../dTAGconstants.sol";
import {dTAGelement} from "../dTAGelement.sol";
import {dTAGutils} from "../dTAGutils.sol";


contract Item is Initializable, dTAGelement, IItem {

  ItemProperties public properties;

  mapping(address player => uint256) public useTurn;

  constructor() {}

  function initialize(
    address _creator,
    address _manager,
    string memory _name,
    string memory _image,
    string memory _description,
    uint8 _cost,
    uint8 _cooldown,
    ItemType _itemType,
    ItemAction _itemAction,
    uint8 _value,
    address _related
  ) external initializer {
    __ERC721_init(_name, "dTAGi");
    __dTAGelement_init(_creator, _manager, uint256(0), _name, _image, _description);
    _assign(_itemType, _itemAction, _value, _related, _cost, _cooldown);

    ItemInitialized(
      _creator, 
      _manager, 
      _name, 
      _image, 
      _description, 
      _cost, 
      _cooldown, 
      _itemType, 
      _itemAction, 
      _value, 
      _related
    );
  }


  function use(address player) external onlyRole(MANAGER_ROLE) nonReentrant {

    /// @dev no check for player ownership as some items can be _used_ without ownership

    require(
      IPlayer(player).energy() >= properties.cost,
      "Player does not have enough energy to use this item"
    );

    uint256 turn = IPlayer(player).turn();

    // don't verify cooldown if item has never been used
    if (useTurn[player] > 0) {
      require(
        turn > useTurn[player] + properties.cooldown,
        "Item is on cooldown"
      );
    }

    IPlayer(player).energy_down(properties.cost);
    useTurn[player] = turn;

    if (properties.itemAction == ItemAction.HEALTH_UP) {
      IPlayer(player).health_up(properties.value);
    }

    else if (properties.itemAction == ItemAction.HEALTH_DOWN) {
      IPlayer(player).health_down(properties.value);
    }

    else if (properties.itemAction == ItemAction.ENERGY_UP) {
      IPlayer(player).energy_up(properties.value);
    }

    else if (properties.itemAction == ItemAction.ENERGY_DOWN) {
      IPlayer(player).energy_down(properties.value);
    }

    else if (properties.itemAction == ItemAction.GAMBLE_HEALTH) {
      uint64 random = dTAGutils.getRandom();
      if (random & 1) { // that's odd
        IPlayer(player).health_down(properties.value);
      } else {
        IPlayer(player).health_up(properties.value);
      }
    }

    else if (properties.itemAction == ItemAction.GAMBLE_ENERGY) {
      uint64 random = dTAGutils.getRandom();
      if (random & 1) { // that's odd
        IPlayer(player).energy_down(properties.value);
      } else {
        IPlayer(player).energy_up(properties.value);
      }
    }

    else if (properties.itemAction == ItemAction.VIBES) {
      uint64 random = dTAGutils.getRandom();
      if (!(random & 1)) {
        // TODO: implement increase stat
      }
    }

    else if (properties.itemAction == ItemAction.PEEK_DOOR) {
      IDoorway(properties.related).peek(player);
    }

    else {
      revert("This item action is invalid. Not sure how this happened.");
    }

    emit ItemUsed(player, tokenId, turn);

  }

  function itemAction() public view returns (ItemAction) {
    return properties.itemAction;
  }

  function itemType() public view returns (ItemType) {
    return properties.itemType;
  }

  function describe() public view override returns (string memory) {
    /// TODO
  }


  function _assign(
    ItemType _itemType, 
    ItemAction _itemAction, 
    uint8 _value,
    address _related,
    uint8 _cost,
    uint8 _cooldown
  ) private {

    if (_itemType == ItemType.DOORWAY) {
      require(_related != address(0), "Doorway item must have a related doorway");
      require(_isDoorway(_related), "Related address is not a doorway");
    
      properties = ItemProperties({
        itemType: _itemType,
        itemAction: _itemAction,
        value: uint8(0),
        related: _related,
        cost: _cost,
        cooldown: _cooldown
      });
    }

    else if (_itemType == ItemType.STAT) {
      require(_value > 0, "Stat item must affect a stat!");

      properties = ItemProperties({
        itemType: _itemType,
        itemAction: _itemAction,
        value: _value,
        related: address(0),
        cost: _cost,
        cooldown: _cooldown
      });
    }

    else if (_itemType == ItemType.GAMBLE) {
      require(_value > 0, "Gamble item must have a value!");

      properties = ItemProperties({
        itemType: _itemType,
        itemAction: _itemAction,
        value: _value,
        related: address(0),
        cost: _cost,
        cooldown: _cooldown
      });
    }

    else if (_itemType == ItemType.VIBE) {
      require(_related != address(0), "Vibe item must have a related gamble item");
      require(
        _isItem(_related) && IItem(_related).itemType() == ItemType.GAMBLE,
        "Related address is not a valid gamble item"
      );

      properties = ItemProperties({
        itemType: _itemType,
        itemAction: _itemAction,
        value: uint8(0),
        related: _related,
        cost: _cost,
        cooldown: _cooldown
      });
    }

    else if (_itemType == ItemType.ACHIEVEMENT) {
      require(_itemAction == ItemAction.NONE, "Achievement item cannot have an action");

      properties = ItemProperties({
        itemType: _itemType,
        itemAction: _itemAction,
        value: uint8(0),
        related: address(0),
        cost: uint8(0),
        cooldown: uint8(0)
      });
    }

    else {
      revert("This item type is invalid. Not sure how this happened.");
    }

  }


  /** ERC related Functions */

  function supportsInterface(bytes4 interfaceId) 
    public view 
    override(dTAGelement)
    returns (bool) {
    return 
      interfaceId == type(IItem).interfaceId
      || super.supportsInterface(interfaceId);
  }

  uint256[50] private __gap;
}
