// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract Utils {

  public constant address cadenceArch = 0x0000000000000000000000010000000000000001;

  function getRandom() public view returns (uint64) {

    (bool success, bytes memory data) = cadenceArch.call(abi.encodeWithSignature("revertibleRandom()"));
    require(success, "Failed to get random number");

    return abi.decode(data, (uint64));
  }

  function mint(address to, uint256 tokenId, address contract) public {
    IERC721(contract).mint(to, tokenId);
  }
}


contract Player is ERC721 {

  address owner;
  uint8 health;
  uint8 energy;
  address ip;

  constructor(address _owner, address _ip) {
    owner = _owner;
    health = 255;
    energy = 255;
    ip = _ip;
  }

  function health_up(uint8 value) external {
    health += value;
  }

  function health_down(uint8 value) external {
    health -= value;
  }

  function energy_up(uint8 value) external {
    energy += value;
  }

  function energy_down(uint8 value) external {
    energy -= value;
  }

  function owner() external view returns (address) {
    return owner;
  }

}


enum ItemAction {
  
  // Describes what lays beyond a direction
  PEEK_DOOR,

  // Chat with an NPC
  NPC_CHAT,

  // Increase health by {value}
  HEALTH,

  // Increase energy by {value}
  ENERGY,

  // May increase health or decrease it by {value}
  GAMBLE_HEALTH,
  
  // May increase energy or decrease it by {value}
  GAMBLE_ENERGY,

  // Simulate a gamble item, only positive outcome is applied
  SCRY,

  // Achievement item
  END_GAME
}


contract Item is ERC721 {

  string name;
  string image;
  string description;
  ItemAction action;
  uint8 value; // For certain actions
  uint8 cost; // Energy spent in using
  uint8 cooldown; // Turns to wait before using again
  address ip; // address of corresponding ip on story

  uint256 tokenHeight;

  constructor(
    string memory _name,
    string memory _image,
    string memory _description,
    uint8 _action,
    uint8 _value,
    uint8 _cost,
    uint8 _cooldown,
    address _ip
  ) {
    name = _name;
    image = _image;
    description = _description;
    value = _value;
    cost = _cost;
    cooldown = _cooldown;
    ip = _ip;
    for (uint8 i=0; i < 8; i++) {
      uint8 mask = 1 << i;
      if (_action & mask != 0) {
        action = ItemAction(i);
      }
    }
  }

  function use(address player) external {

    switch (action) {
      case ItemAction.PEEK_DOOR:
        break;
      case ItemAction.NPC_CHAT:
        revert('Not implemented');
        break;
      case ItemAction.HEALTH:
        Player(player).health_up(value);
        break;
      case ItemAction.ENERGY:
        Player(player).energy_up(value);
        break;
      case ItemAction.GAMBLE_HEALTH:
        uint64 random = Utils.getRandom();
        if (random & 1) { // that's odd
          Player(player).health_down(value);
        } else {
          Player(player).health_up(value);
        }
        break;
      case ItemAction.GAMBLE_ENERGY:
        uint64 random = Utils.getRandom();
        if (random & 1) { // that's odd
          Player(player).energy_down(value);
        } else {
          Player(player).energy_up(value);
        }
        break;
      case ItemAction.SCRY:
        uint64 random = Utils.getRandom();
        if (!(random & 1)) {
          Player(player).energy_up(value);
        }
        break;
      case ItemAction.END_GAME:
        Utils.mint(Player(player).owner(), tokenHeight++, address(this));
        break;
    }
  }

  function mint(address to) external {
    Utils.mint(to, tokenHeight++, address(this));
  }
}


enum CommandType {

  PICK,

  DROP,

  USE,

  START,

  GO,

  PEEK

}


contract Command {

  string name;
  address requires;
  address ip;
  CommandType ability;

  constructor(string memory _name, address _requires, address _ip, CommandType _ability) {
    name = _name;
    requires = _requires;
    ip = _ip;
    for (uint8 i=0; i < 6; i++) {
      uint8 mask = 1 << i;
      if (_ability & mask != 0) {
        ability = CommandType(i);
      }
    }
  }

  function execute(address game, address player, address args) external {

    switch (ability) {
      case CommandType.PICK:
        break;
      case CommandType.DROP:
        break;
      case CommandType.USE:
        break;
      case CommandType.START:
        Game(game).startGame(player);
        break;
      case CommandType.GO:
        Game(game).exitRoom(player, args);
        break;
      case CommandType.PEEK:
        if (IERC721().balanceOf(Player(player).owner()) > 0) {
          Game(game).peekDoor(player, args);
        }
        break;
    }
  }

}


contract Exit is ERC721 {

  string direction;
  address room;
  bool isEgg; // If true, the exit is an easter egg, ie, hidden
  address ip;

  uint256 tokenHeight;


  constructor(string memory _direction, address _room, bool _isEgg) {
    direction = _direction;
    room = _room;
    isEgg = _isEgg;
  }

  function peek(address player) external returns (string memory) {
    if (isEgg) {
      Utils.mint(Player(player).owner(), tokenHeight++, address(this));
    }
    return Room(room).description();
  }

}

contract Room is ERC721 {

  string name;
  private string description;
  address[] exits;
  address item;
  address ip;

  uint256 tokenHeight;

  constructor(string memory _name, string memory _description, address[] memory _exits, address _item, address _ip) {
    name = _name;
    description = _description;
    exits = _exits;
    item = _item;
    ip = _ip;
  }

  function peek(address player) external returns (string memory) {
    return description;
  }

  function pick(address player) external {
    if (item != address(0)) {
      Item(item).mint(Player(player).owner());
    }
  }

}

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
