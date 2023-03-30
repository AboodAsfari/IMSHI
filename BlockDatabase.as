package{
	import Blocks.*;
	import Blocks.ANDGate.*;
	import Blocks.ORGate.*;
	import Blocks.XORGate.*;
	import Blocks.Teleporter.*;
	import Blocks.Piston.*;
	import Blocks.Observer.*;
	import Blocks.SignalDelayer.*;
	import Blocks.Wire.*;
	import Blocks.Lamp.*;
	import BlockVisuals.*;
	import BlockVisuals.ANDGate.*;
	import BlockVisuals.ORGate.*;
	import BlockVisuals.XORGate.*;
	import BlockVisuals.Teleporter.*;
	import BlockVisuals.Piston.*;
	import BlockVisuals.Observer.*;
	import BlockVisuals.SignalDelayer.*;
	import BlockVisuals.Wire.*;
	import BlockVisuals.Lamp.*;
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	
	public class BlockDatabase{
		public static var blockDatabase:Array; //Stores the block database
		public static var nonVariantList:Array = new Array(); //Stores the non variant block database
		public static var wireList:Array = new Array(); //Stores the non variant block database
		
		public static var blockDictX:Dictionary = new Dictionary(); //Dictionary that stores blocks based on their coordinates
		public static var blockDictY:Dictionary = new Dictionary(); //See above
		public static var subBlockDictX:Dictionary = new Dictionary(); //Dictionary that stores blocks based on their coordinates
		public static var subBlockDictY:Dictionary = new Dictionary(); //See above
					
		public static function CreateDatabase():void{ //Creates the database
			blockDatabase = new Array( //See above
				[PlayerSpawn, Player, PlayerIcon, "Player", true, false, "Shi is a mysterious creature. Nobody knows why he'll go to such lengths to reach his goal, or why he even aims to reach it. Almost like someone else is controlling him..."], //See above
				[Dummy, DummyVisual, DummyIcon, "Dummy", true, false, "The dummy is a phenomenon of this world, that seems to have a desire to follow the movements of the nearest creature."], //See above
				[Goal, GoalVisual, GoalIcon, "Goal", true, false, "Very little is known about this flag. It is myserious, even more so than that who craves it. One word can be seen on it, an order of sorts: 'IMSHI'."], //See above
				[Barricade, BarricadeVisual, BarricadeIcon, "Barricade", true, false, "This barricade has no special properties. It simply blocks the path. It's a wonder no one's thought to climb over it though."], //See above
				[Crate, CrateVisual, CrateIcon, "Crate", true, false, "Crates can be pushed, which may clear a path for you, or be used to activate a pressure plate, or even hold up a gate!"], //See above
				[YellowWire, YellowWireVisual, YellowWireIcon, "Wire", true, true, "Wire is the most important technical component in this world. It's what allows signals to be transmitted and is what makes islands so technologically advannced."], //See above
				[PinkWire, PinkWireVisual, PinkWireIcon, "Wire", false, true, "N/A"], //See above
				[GreenWire, GreenWireVisual, GreenWireIcon, "Wire", false, true, "N/A"], //See above
				[BlueWire, BlueWireVisual, BlueWireIcon, "Wire", false, true, "N/A"], //See above
				[RedWire, RedWireVisual, RedWireIcon, "Wire", false, true, "N/A"], //See above
				[Junction, JunctionVisual, JunctionIcon, "Wire Junction", true, true, "Junctions allow to stop two wire lines of the same color from intersecting, as well as converting wire of color A to color B."], //See above
				[PressurePlate, PressurePlateVisual, PressurePlateIcon, "Pressure Plate", true, true, "This technical component will power any wires or recieving components when stepped on. Similarly, it will stop powering it when stepped off of."], //See above
				[SignalDelayerOne, SignalDelayerOneVisual, SignalDelayerIcon, "Signal Delayer", true, true, "Delays a signal by 0.25-1.00 seconds. Placing a square of delayers may cause unexpected results."], //See above
				[SignalDelayerTwo, SignalDelayerTwoVisual, SignalDelayerIcon, "Signal Delayer", false, true, "N/A"], //See above
				[SignalDelayerThree, SignalDelayerThreeVisual, SignalDelayerIcon, "Signal Delayer", false, true, "N/A"], //See above
				[SignalDelayerFour, SignalDelayerFourVisual, SignalDelayerIcon, "Signal Delayer", false, true, "N/A"], //See above
				[TFlipFlop, TFlipFlopVisual, TFlipFlopIcon, "T Flip-Flop", true, true, "A T Flip-Flop is a unique power sources which toggles power states only when powered, and ignores negative transmissions."], //See above
				[EastObserver, EastObserverVisual, ObserverIcon, "Observer", true, false, "Observers constantly watch the state of one block, and output a signal on the opposite side when the block's state changes."], //See above
				[SouthObserver, SouthObserverVisual, ObserverIcon, "Observer", false, false, "N/A"], //See above
				[WestObserver, WestObserverVisual, ObserverIcon, "Observer", false, false, "N/A"], //See above
				[NorthObserver, NorthObserverVisual, ObserverIcon, "Observer", false, false, "N/A"], //See above
				[ANDGateEast, ANDGateEastVisual, ANDGateIcon, "AND Gate", true, true, "The AND logic gate emits a signal only when all connected inputs are in a powered state."], //See above
				[ANDGateSouth, ANDGateSouthVisual, ANDGateIcon, "AND Gate", false, true, "N/A"], //See above
				[ANDGateWest, ANDGateWestVisual, ANDGateIcon, "AND Gate", false, true, "N/A"], //See above
				[ANDGateNorth, ANDGateNorthVisual, ANDGateIcon, "AND Gate", false, true, "N/A"], //See above
				[ORGateEast, ORGateEastVisual, ORGateIcon, "OR Gate", true, true, "The OR logic gate emits a signal when one or more connected inputs are in a powered state. Can also be used to create a permanent signal."], //See above
				[ORGateSouth, ORGateSouthVisual, ORGateIcon, "OR Gate", false, true, "N/A"], //See above
				[ORGateWest, ORGateWestVisual, ORGateIcon, "OR Gate", false, true, "N/A"], //See above
				[ORGateNorth, ORGateNorthVisual, ORGateIcon, "OR Gate", false, true, "N/A"], //See above
				[XORGateEast, XORGateEastVisual, XORGateIcon, "XOR Gate", true, true, "The XOR logic gate emits a signal when only one connected input is in a powered state, no more. This can be used to create an inverter."], //See above
				[XORGateSouth, XORGateSouthVisual, XORGateIcon, "XOR Gate", false, true, "N/A"], //See above
				[XORGateWest, XORGateWestVisual, XORGateIcon, "XOR Gate", false, true, "N/A"], //See above
				[XORGateNorth, XORGateNorthVisual, XORGateIcon, "XOR Gate", false, true, "N/A"], //See above
				[Gate, GateVisual, GateIcon, "Door", true, true, "The door blocks off a path. When powered, it is possible to walk through the door. The door can also be held up if stood on, allowing it to remain open even when not powered."], //See above
				[YellowTeleporter, YellowTeleporterVisual, YellowTeleporterIcon, "Teleporter", true, true, "When powered, the teleporter will transport the block on it to another random unocupied teleporter of the same color."], //See above
				[PinkTeleporter, PinkTeleporterVisual, PinkTeleporterIcon, "Teleporter", false, true, "N/A"], //See above
				[GreenTeleporter, GreenTeleporterVisual, GreenTeleporterIcon, "Teleporter", false, true, "N/A"], //See above
				[BlueTeleporter, BlueTeleporterVisual, BlueTeleporterIcon, "Teleporter", false, true, "N/A"], //See above
				[RedTeleporter, RedTeleporterVisual, RedTeleporterIcon, "Teleporter", false, true, "N/A"], //See above
				[EastPiston, EastPistonVisual, PistonIcon, "Piston", true, false, "When powered, the piston will attempt to move a movable block. The piston itself is movable unless extended."], //See above
				[SouthPiston, SouthPistonVisual, PistonIcon, "Piston", false, false, "N/A"], //See above
				[WestPiston, WestPistonVisual, PistonIcon, "Piston", false, false, "N/A"], //See above
				[NorthPiston, NorthPistonVisual, PistonIcon, "Piston", false, false, "N/A"], //See above
				[YellowLamp, YellowLampVisual, YellowLampIcon, "Lamp Block", true, false, "The lamp block will connect to other lamp blocks, and can be powered from one source. When powered, lamps will light up."], //See above
				[PinkLamp, PinkLampVisual, PinkLampIcon, "Lamp Block", false, false, "N/A"], //See above
				[GreenLamp, GreenLampVisual, GreenLampIcon, "Lamp Block", false, false, "N/A"], //See above
				[BlueLamp, BlueLampVisual, BlueLampIcon, "Lamp Block", false, false, "N/A"], //See above
				[RedLamp, RedLampVisual, RedLampIcon, "Lamp Block", false, false, "N/A"] //See above
			);
			
			for(var i:Number = 0; i < blockDatabase.length; i++){
				if(blockDatabase[i][4]){
					nonVariantList.push(blockDatabase[i]);
				}
			}
			
			wireList = [YellowWireVisual, PinkWireVisual, GreenWireVisual, BlueWireVisual, RedWireVisual];
		}
		
		public static function GetClass(inputtedID):Class{ //Gets the class
			return blockDatabase[inputtedID][0]; //See above
		}
		
		public static function GetVisualClass(inputtedID):Class{ //Gets the visual class
			return blockDatabase[inputtedID][1]; //See above
		}
		
		public static function GetIconClass(inputtedID):Class{ //Gets the icon class
			return blockDatabase[inputtedID][2]; //See above
		}
		
		public static function GetName(inputtedID):String{ //Gets the block name
			return blockDatabase[inputtedID][3]; //See above
		}

		public static function GetID(inputtedClass){ //Gets the block ID
			for(var i:Number = 0; i < blockDatabase.length; i++){ //See above
				if(blockDatabase[i].indexOf(inputtedClass) != -1){ //See above
					return i; //See above
				}
			}
			
			return null; //See above
		}
		
		public static function GetBlock(inputtedX, inputtedY):MovieClip{ //Gets the block
			if(blockDictX[inputtedX] != null && blockDictX[inputtedX].length > 0 && blockDictY[inputtedY] != null && blockDictY[inputtedY].length > 0){ //See above
				for(var i:Number = 0; i < blockDictX[inputtedX].length; i++){ //See above
					if(blockDictY[inputtedY].indexOf(blockDictX[inputtedX][i]) != -1){ //See above
						return blockDictX[inputtedX][i]; //See above
					}
				}
			}
			
			return null; //See above
		}
		
		public static function GetSubBlock(inputtedX, inputtedY):MovieClip{ //Gets the block
			if(subBlockDictX[inputtedX] != null && subBlockDictX[inputtedX].length > 0 && subBlockDictY[inputtedY] != null && subBlockDictY[inputtedY].length > 0){ //See above
				for(var i:Number = 0; i < subBlockDictX[inputtedX].length; i++){ //See above
					if(subBlockDictY[inputtedY].indexOf(subBlockDictX[inputtedX][i]) != -1){ //See above
						return subBlockDictX[inputtedX][i]; //See above
					}
				}
			}
			
			return null; //See above
		}
		
	}
}