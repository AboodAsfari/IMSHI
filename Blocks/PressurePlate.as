package Blocks{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	public class PressurePlate extends BlockBase{
		private var power:Number;
		
		public function PressurePlate(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the plate's visuals 
			super(inputtedColumn, inputtedRow, this, ["Sub-Block", "Transmitter"]); //See above	
			
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			
			power = 0;
			
			TileDatabase.GetTile(column, row).subOccupiedBlock = this; //See above
								
			Main.subBlockContainer.addChild(visual); //See above
		}
		
		override public function DeleteBlock():void{ //Deletes the pressure plate
			super.DeleteBlock(); //See above
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
					
			visual.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width); //See above
			visual.y = (row * TileDatabase.tileSize) + (64-visual.height); //See above
			
			for(var i:Number = 0; i < Main.blockList.length; i++){
				Main.blockList[i].BlockUpdate(this, "BlockEnter");
			}
		}
		
		override public function BlockUpdate(updater, updateType):void{  //See above
			var collider:Object = TileDatabase.GetTile(column, row).occupiedBlock; //See above
			var target:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			if(collider != null && visual.currentFrame == 1){ //See above
				Main.PlaySound(StepOn); //See above
				visual.gotoAndStop(2); //See above
				power = 1; //See above
				for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
					target = TileDatabase.GetTile(column + neighboringTiles[a][0], row + neighboringTiles[a][1]); //See above
					if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1 && (target.subOccupiedBlock.specialTags.indexOf("Unbiased") != -1 || target.subOccupiedBlock.poweredBy.indexOf(this) == -1)){ //See above
						target.subOccupiedBlock.TransmitSignal(1, this, neighboringTiles[a]); //See above
					}
					
					if(target != null && target.occupiedBlock != null && target.occupiedBlock.specialTags.indexOf("Receiver") != -1 && (target.occupiedBlock.specialTags.indexOf("Unbiased") != -1 || target.occupiedBlock.poweredBy.indexOf(this) == -1)){ //See above
						target.occupiedBlock.TransmitSignal(1, this, neighboringTiles[a]); //See above
					}
				}
			}else if(TileDatabase.GetTile(column, row) != null && TileDatabase.GetTile(column, row).occupiedBlock == null && visual.currentFrame == 2){ //See above
				Main.PlaySound(StepOff);
				visual.gotoAndStop(1); //See above
				power = 0;
				for(var b:Number = 0; b < neighboringTiles.length; b++){ //See above
					target = TileDatabase.GetTile(column + neighboringTiles[b][0], row + neighboringTiles[b][1]); //See above
					if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1 && (target.subOccupiedBlock.specialTags.indexOf("Unbiased") != -1 || target.subOccupiedBlock.poweredBy.indexOf(this) != -1)){ //See above
						target.subOccupiedBlock.TransmitSignal(-1, this, neighboringTiles[b]); //See above
					}
					
					if(target != null && target.occupiedBlock != null && target.occupiedBlock.specialTags.indexOf("Receiver") != -1 && (target.occupiedBlock.specialTags.indexOf("Unbiased") != -1 || target.occupiedBlock.poweredBy.indexOf(this) != -1)){ //See above
						target.occupiedBlock.TransmitSignal(-1, this, neighboringTiles[b]); //See above
					}
				}
			}else if(visual.currentFrame == 2){ //See above
				for(var c:Number = 0; c < neighboringTiles.length; c++){ //See above
					target = TileDatabase.GetTile(column + neighboringTiles[c][0], row + neighboringTiles[c][1]); //See above
					if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1 && target.subOccupiedBlock.poweredBy.indexOf(this) == -1){ //See above
						target.subOccupiedBlock.TransmitSignal(1, this, neighboringTiles[c]); //See above
					}
					
					if(target != null && target.occupiedBlock != null && target.occupiedBlock.specialTags.indexOf("Receiver") != -1 && target.occupiedBlock.poweredBy.indexOf(this) == -1){ //See above
						target.occupiedBlock.TransmitSignal(1, this, neighboringTiles[c]); //See above
					}
				}
			}
			
			visual.VisualUpdate(); //See above
		}

	}	
}