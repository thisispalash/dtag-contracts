import dextraGame from "./Game.cdc"

access(all) contract dextraEngine {

  // revertibleRandom is a function on the VRF contract
  // it returns a random 

  access(self) fun getRandom() : UInt64 {


    return revertibleRandom<UInt64>();
  }

  access(self) fun loadGame(game: dextraGame.Adventure)

}