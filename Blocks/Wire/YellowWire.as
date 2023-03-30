package Blocks.Wire{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	public class YellowWire extends BlockBase{
		public var poweredBy:Array; //An array of power sources powering this wire
		private var power:Number; //The amount of power this wire has
		
		public function YellowWire(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the rock visuals 
			super(inputtedColumn, inputtedRow, this, ["Sub-Block", "Receiver", "Transmitter", "Wire", "Yellow"]); //See above
					
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			
			TileDatabase.GetTile(column, row).subOccupiedBlock = this; //See above
			
			poweredBy = []; //See above
			power = 0; //See above
			
			Main.subBlockContainer.addChild(visual); //See above
		}
		
		override public function Move(xChange, yChange, resetPos):void{ //Moves the block
			for(var a:Number = 0; a < Main.blockList.length; a++){ //See above
				Main.blockList[a].BlockUpdate(this, "BlockExit"); //See above
			}
			
			if(resetPos){
				TileDatabase.GetTile(column, row).subOccupiedBlock = null; //See above
			}
					
			column += xChange; //See above
			row += yChange; //See above
					
			TileDatabase.GetTile(column, row).subOccupiedBlock = this; //See above
					
			for(var i:Number = 0; i < Main.blockList.length; i++){ //See above
				Main.blockList[i].BlockUpdate(this, "BlockEnter"); //See above
			}
		}
		
		public function TransmitSignal(strength, signalSource, sourceDirection):void{ //Transmits a power signal
			power += strength; //See above
			sourceDirection = [sourceDirection[0] * -1, sourceDirection[1] * -1]; //See above
			if(strength == 1){ //See above
				poweredBy.push(signalSource); //See above
			}else{ //See above
				poweredBy.removeAt(poweredBy.indexOf(signalSource)); //See above
			}
				
			var target:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				target = TileDatabase.GetTile(column + neighboringTiles[a][0], row + neighboringTiles[a][1]); //See above
				if(target != null && target.subOccupiedBlock != null && (target.subOccupiedBlock.specialTags.indexOf("Wire") == -1 || target.subOccupiedBlock.specialTags.indexOf("Yellow") != -1) && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1 && (neighboringTiles[a][0] != sourceDirection[0] || neighboringTiles[a][1] != sourceDirection[1]) && (target.subOccupiedBlock.specialTags.indexOf("Unbiased") != -1 || ((strength == -1 && target.subOccupiedBlock.poweredBy.indexOf(signalSource) != -1) || (strength == 1 && target.subOccupiedBlock.poweredBy.indexOf(signalSource) == -1)))){ //See above
					target.subOccupiedBlock.TransmitSignal(strength, signalSource, neighboringTiles[a]); //See above
				}
				
				if(target != null && target.occupiedBlock != null && (target.occupiedBlock.specialTags.indexOf("Wire") == -1 || target.occupiedBlock.specialTags.indexOf("Yellow") != -1) && target.occupiedBlock.specialTags.indexOf("Receiver") != -1 && (neighboringTiles[a][0] != sourceDirection[0] || neighboringTiles[a][1] != sourceDirection[1]) && (target.occupiedBlock.specialTags.indexOf("Unbiased") != -1 || ((strength == -1 && target.occupiedBlock.poweredBy.indexOf(signalSource) != -1) || (strength == 1 && target.occupiedBlock.poweredBy.indexOf(signalSource) == -1)))){ //See above
					target.occupiedBlock.TransmitSignal(strength, signalSource, neighboringTiles[a]); //See above
				}
			}
			
			if(power == 1 && strength == 1 || power == 0 && strength == -1){
				for(var b:Number = 0; b < Main.blockList.length; b++){ //See above
					Main.blockList[b].BlockUpdate(this, "Signal"); //See above
				}
			}
		}
		
		override public function BlockUpdate(updater, updateType):void{ //Updates the wire visuals
			visual.VisualUpdate(); //See above
		}

	}	
}