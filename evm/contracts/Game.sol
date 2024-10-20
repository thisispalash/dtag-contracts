// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.23;


contract Game is ERC721 {

  string title;
  string description;
  address[] rooms;
  address ip;
  bool randomSpawn;
  address start_room;
  address end_room;
  address achievement; // token received for reaching end_room
  uint256 price;

  uint256 tokenHeight;

  constructor(string memory _title, string memory _description, address[] memory _rooms, address _ip, bool _randomSpawn, address _start_room, address _end_room, address _achievement, uint256 _price) {
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

  modifier isPurchased(address player) {
    require(IERC721().balanceOf(Player(player).owner()) > 0, "Player must purchase game to start");
    _;
  }

  function purchase(address player) external payable {
    Utils.mint(Player(player).owner(), tokenHeight++, address(this));
  }

  function startGame(address player) external isPurchased(player) {
    require(rooms.length > 0, "Game must have at least one room");

    if (randomSpawn) {
      uint64 random = Utils.getRandom();
      uint64 spawn = random % rooms.length;
      return rooms[spawn];
    }
    
    return start_room;
  }
  
  function endGame(address player) external isPurchased(player) {
    Item(achievement).mint(Player(player).owner());
  }
}
