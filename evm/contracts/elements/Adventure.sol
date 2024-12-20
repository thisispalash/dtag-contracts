// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Utils} from "./Util.sol";

import {Room} from "./Room.sol";
import {Player} from "./Player.sol";


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


contract Adventure is ERC721 {

  public string title;
  public string description;

  internal address[] rooms;
  internal address[] items;
  internal address[] npcs;

  internal bool randomSpawn;
  internal address start_room;
  internal address end_room;
  public address achievement; // token received for reaching end_room

  uint256 public price;
  uint256 public tokenHeight;


  mapping(uint256 => address) owners;
  mapping(uint256 => GamePlay[]) plays;
  mapping(address => GamePlay[]) playerPlays;


  modifier isPurchased(address player) {
    require(
      IERC721().balanceOf(Player(player).human()) > 0, 
      "Player must purchase game to start"
    );
    _;
  }


  constructor(
    string memory _title, 
    string memory _description, 
    address[] memory _rooms, 
    bool _randomSpawn, 
    address _start_room, 
    address _end_room, 
    address _achievement, 
    uint256 _price
  ) {
    title = _title;
    description = _description;
    rooms = _rooms;
    ip = _ip;
    randomSpawn = _randomSpawn;
    start_room = _start_room;
    end_room = _end_room;
    achievement = _achievement;
    price = _price;
  }


  function purchase(address player) 
    public 
    payable 
    returns (uint256 tokenId) {

    require(msg.value >= price, "Too little money sent.");

    uint256 tokenId = tokenHeight++;
    owners[tokenId] = player;
    this._safeMint(Player(player).human(), tokenId);

    if (msg.value - price > 0) {
      payable(player).transfer(msg.value - price);
    }
  }

  function makeMove(
    address player, 
    CommandType command, 
    string memory args
  ) external 
    isPurchased(player) {

  }

  function startGame(address player) 
    internal 
    isPurchased(player) 
    returns (string memory) {
    
    require(rooms.length > 0, "Game must have at least one room");

    if (randomSpawn) {
      uint64 random = Utils.getRandom();
      uint64 spawn = random % rooms.length;
      return Room(rooms[spawn]).describe();
    }

    GamePlay memory play = playerPlays[player];

    return Room(start_room).describe();
  }

  function endGame(address player) external isPurchased(player) {
    Item(achievement).mint(Player(player).human());
  }
}
