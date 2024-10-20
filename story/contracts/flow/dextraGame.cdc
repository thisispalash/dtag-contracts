access(all) contract dextraGame {

  access(all) enum Errors {
    access(all) case invalidDirection
    access(all) case invalidCommand
  }

  access(all) enum Commands {
    access(all) case help
    access(all) case start
    access(all) case stop
    access(all) case go
    access(all) case use
    access(all) case chat
    access(all) case peek
  }

  access(all) enum ItemType {
    access(all) case health
    access(all) case energy
    access(all) case gamble
    access(all) case scry
    access(all) case achievement
    access(all) case plot
  }

  access(all) enum Condition {
    access(all) case itemExists
    access(all) case itemDNE
    access(all) case entry
    access(all) case exit
    access(all) case healthAbove
    access(all) case healthBelow
    access(all) case healthEqual
    access(all) case energyAbove
    access(all) case energyBelow
    access(all) case energyEqual
  }

  access(all) enum Effect {
    access(all) case death
    access(all) case healthIncrease
    access(all) case healthDecrease
    access(all) case energyIncrease
    access(all) case energyDecrease
    access(all) case teleport
    access(all) case getItem
  }

  access(all) enum EntityType {
    access(all) case dextra
  }

  /** end enums */

  access(all) struct Item {
    access(all) let name: String
    access(all) let description: String
    access(all) let type: ItemType
    access(all) let image_url: String
    access(all) let effect: Effect
    access(all) let cooldown: UInt64

    init(
      name: String,
      description: String,
      type: ItemType,
      image_url: String,
      effect: Effect,
      cooldown: UInt64
    ) {
      self.name = name
      self.description = description
      self.type = type
      self.image_url = image_url
      self.effect = effect
      self.cooldown = cooldown
    }

    access() fun use(user: Address) {
      // TODO: implement
    }
  }

  access(all) struct SimpleEntity {
    access(all) let name: String
    access(all) let description: String
    access(all) let type: EntityType
    access(all) let image_url: String
    access(all) let items: [Item]
    access(all) let conditions: String
    access(all) let difficulty: UInt8
    access(all) let personality: String

    init(
      name: String,
      description: String,
      image_url: String,
      items: [Item],
      conditions: String,
      difficulty: UInt8,
      personality: String
    ) {
      self.name = name
      self.description = description
      self.image_url = image_url
      self.items = items
      self.conditions = conditions
      self.difficulty = difficulty
      self.personality = personality
    }

    access(all) fun chat(user: Address) {
      // TODO: implement
    }
  }

  access(all) struct Exit {
    access(all) let direction: String
    access(all) let room: String
    access(all) let is_egg: Bool

    init(
      direction: String,
      room: String,
      is_egg: Bool
    ) {
      self.direction = direction
      self.room = room
      self.is_egg = is_egg
    }
  }

  access(all) struct Event {
    access(all) let condition: Condition
    access(all) let effect: Effect

    init(
      condition: Condition,
      effect: Effect
    ) {
      self.condition = condition
      self.effect = effect
    }
  }

  access(all) struct Room {
    access(all) let name: String
    access(all) let description: String
    access(all) let hidden_description: String
    access(all) let exits: [Exit]
    access(all) let entities: [SimpleEntity]
    access(all) let items: [String]
    access(all) let events: [Event]

    init(
      name: String,
      description: String,
      hidden_description: String,
      exits: [Exit],
      entities: [String],
      items: [String],
      events: [Event]
    ) {
      self.name = name
      self.description = description
      self.hidden_description = hidden_description
      self.exits = exits
      self.entities = entities
      self.items = items
      self.events = events
    }

    access(all) fun exit(dir: String) {
      for exit in self.exits {
        if exit.direction == dir {
          return exit.room
        }
      }
      return Errors.invalidDirection
    }
  }

  access(all) struct Adventure {
    access(all) let id: String
    access(all) let title: String
    access(all) let description: String
    access(all) let rooms: [Room]
    access(all) let items: [Item]
    access(all) let entities: [SimpleEntity]
    access(all) let start_room: String
    access(all) let end_room: String
    access(all) let random_spawn: Bool
    access(all) let random_items: Bool
    access(all) let cost: UFix64

    init(
      id: String,
      title: String,
      description: String,
      image_url: String,
      rooms: [Room],
      items: [Item],
      entities: [SimpleEntity],
      start_room: String,
      end_room: String,
      random_spawn: Bool,
      random_items: Bool,
      cost: UFix64
    ) {
      self.id = id
      self.title = title
      self.description = description
      self.rooms = rooms
      self.items = items
      self.entities = entities
      self.start_room = start_room
      self.end_room = end_room
      self.random_spawn = random_spawn
      self.random_items = random_items
      self.cost = cost
    }
  }

  access(all) struct Player {
    // the user's address on EVM
    access(self) let userId: String 
    
    access(self) let health: UInt8
    access(self) let energy: UInt8

    access(self) let moves: [String]
    access(self) let current_room: Room
  }


  init() {

  }


}