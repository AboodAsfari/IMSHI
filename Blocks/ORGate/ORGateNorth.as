package Blocks.ORGate{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	public class ORGateNorth extends BlockBase{
		public var poweredBy:Array; //An array of power sources powering this wire
		public var power:Number; //The amount of power this wire has
		public var eastInput:Number;
		public var southInput:Number;
		public var westInput:Number;
		
		public function ORGateNorth(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the rock visuals 
			super(inputtedColumn, inputtedRow, this, ["Sub-Block", "Receiver", "Transmitter", "Unbiased"]); //See above
					
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			
			TileDatabase.GetTile(column, row).subOccupiedBlock = this; //See above
			
			poweredBy = []; //See above
			power = 0; //See above
			
			eastInput = 0;
			southInput = 0;
			westInput = 0;
			
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
			if(sourceDirection[1] != -1){
				if(strength == 1){ //See above
					poweredBy.push(signalSource); //See above
				}else{ //See above
					poweredBy.removeAt(poweredBy.indexOf(signalSource)); //See above
				}
				
				if(sourceDirection[0] == 1){
					westInput += strength;
					if((westInput == 1 && strength == 1) || (westInput == 0 && strength == -1)){
						for(var a:Number = 0; a < Main.blockList.length; a++){ //See above
							Main.blockList[a].BlockUpdate(this, "Signal"); //See above
						}
					}
				}else if(sourceDirection[1] == 1){
					eastInput += strength;
					if((eastInput == 1 && strength == 1) || (eastInput == 0 && strength == -1)){
						for(var b:Number = 0; b < Main.blockList.length; b++){ //See above
							Main.blockList[b].BlockUpdate(this, "Signal"); //See above
						}
					}
				}else{
					southInput += strength;
					if((southInput == 1 && strength == 1) || (southInput == 0 && strength == -1)){
						for(var c:Number = 0; c < Main.blockList.length; c++){ //See above
							Main.blockList[c].BlockUpdate(this, "Signal"); //See above
						}
					}
				}
				
				var target = TileDatabase.GetTile(column, row - 1); //See above
				if(westInput != 0 || eastInput != 0 || southInput != 0){
					if(power == 0){
						power++;
						if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1){
							target.subOccupiedBlock.TransmitSignal(1, this, [0, -1]);
						}
						if(target != null && target.occupiedBlock != null && target.occupiedBlock != target.subOccupiedBlock && target.occupiedBlock.specialTags.indexOf("Receiver") != -1){
							target.occupiedBlock.TransmitSignal(1, this, [0, -1]); //See above
						}
						for(var d:Number = 0; d < Main.blockList.length; d++){ //See above
							Main.blockList[d].BlockUpdate(this, "Signal"); //See above
						}
					}
				}else if(power == 1){
					power--;
					if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1){
						target.subOccupiedBlock.TransmitSignal(-1, this, [0, -1]); //See above
					}
					if(target != null && target.occupiedBlock != null && target.occupiedBlock != target.subOccupiedBlock && target.occupiedBlock.specialTags.indexOf("Receiver") != -1){
						target.occupiedBlock.TransmitSignal(-1, this, [0, -1]); //See above
					}
					for(var e:Number = 0; e < Main.blockList.length; e++){ //See above
						Main.blockList[e].BlockUpdate(this, "Signal"); //See above
					}
				}

				
				BlockUpdate(this, "Signal"); //See above
			}
		}
		
		override public function BlockUpdate(updater, updateType):void{ //Updates the wire visuals
			visual.VisualUpdate(); //See above
		}

	}	
}