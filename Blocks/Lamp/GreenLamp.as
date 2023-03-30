package Blocks.Lamp{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	public class GreenLamp extends BlockBase{
		public var poweredBy:Array; //An array of power sources powering this wire
		private var power:Number; //The amount of power this wire has
		
		public function GreenLamp(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the lamp visuals 
			super(inputtedColumn, inputtedRow, this, ["Receiver", "Lamp"]); //See above
					
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			
			poweredBy = []; //See above
			power = 0; //See above
			
			Main.blockContainer.addChild(visual); //See above
		}
		
		public function TransmitSignal(strength, signalSource, sourceDirection):void{ //Transmits a power signal
			power += strength; //See above
			sourceDirection = [sourceDirection[0] * -1, sourceDirection[1] * -1]; //See above
			if(strength == 1){ //See above
				poweredBy.push(signalSource); //See above
			}else{ //See above
				poweredBy.removeAt(poweredBy.indexOf(signalSource)); //See above
			}
			
			if(power == 1 && strength == 1 || power == 0 && strength == -1){
				for(var b:Number = 0; b < Main.blockList.length; b++){ //See above
					Main.blockList[b].BlockUpdate(this, "Signal"); //See above
				}
			}
			
			var target:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				target = TileDatabase.GetTile(column + neighboringTiles[a][0], row + neighboringTiles[a][1]); //See above
				if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Lamp") != -1 && (neighboringTiles[a][0] != sourceDirection[0] || neighboringTiles[a][1] != sourceDirection[1]) && (target.subOccupiedBlock.specialTags.indexOf("Unbiased") != -1 || ((strength == -1 && target.subOccupiedBlock.poweredBy.indexOf(signalSource) != -1) || (strength == 1 && target.subOccupiedBlock.poweredBy.indexOf(signalSource) == -1)))){ //See above
					target.subOccupiedBlock.TransmitSignal(strength, signalSource, neighboringTiles[a]); //See above
				}
				
				if(target != null && target.occupiedBlock != null && target.occupiedBlock.specialTags.indexOf("Lamp") != -1 && (neighboringTiles[a][0] != sourceDirection[0] || neighboringTiles[a][1] != sourceDirection[1]) && (target.occupiedBlock.specialTags.indexOf("Unbiased") != -1 || ((strength == -1 && target.occupiedBlock.poweredBy.indexOf(signalSource) != -1) || (strength == 1 && target.occupiedBlock.poweredBy.indexOf(signalSource) == -1)))){ //See above
					target.occupiedBlock.TransmitSignal(strength, signalSource, neighboringTiles[a]); //See above
				}
			}
			
			if(power > 0){
				visual.bulb.gotoAndStop(1);
				visual.bulb.leftExtension.gotoAndStop(1);
				visual.bulb.rightExtension.gotoAndStop(1);
				visual.bulb.topExtension.gotoAndStop(1);
				visual.bulb.bottomExtension.gotoAndStop(1);
				visual.bulb.northEast.gotoAndStop(1);
				visual.bulb.northWest.gotoAndStop(1);
				visual.bulb.southEast.gotoAndStop(1);
				visual.bulb.southWest.gotoAndStop(1);
				visual.powerIndicator.gotoAndStop(2);
			}else{
				visual.bulb.gotoAndStop(2);
				visual.bulb.leftExtension.gotoAndStop(2);
				visual.bulb.rightExtension.gotoAndStop(2);
				visual.bulb.topExtension.gotoAndStop(2);
				visual.bulb.bottomExtension.gotoAndStop(2);
				visual.bulb.northEast.gotoAndStop(2);
				visual.bulb.northWest.gotoAndStop(2);
				visual.bulb.southEast.gotoAndStop(2);
				visual.bulb.southWest.gotoAndStop(2);
				visual.powerIndicator.gotoAndStop(1);
			}
		}
		
		override public function BlockUpdate(updater, updateType):void{ //Updates the wire visuals
			if(updateType != "Signal"){
				visual.VisualUpdate(); //See above
			}
		}

	}	
}