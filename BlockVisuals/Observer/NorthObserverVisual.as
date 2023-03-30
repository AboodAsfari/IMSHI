package BlockVisuals.Observer{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;	
	
	public class NorthObserverVisual extends MovieClip{
		public var script:Object;
		public const specialTags = ["Transmitter"];
		
		public function NorthObserverVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript;
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize); //See above
			this.wireBottom.visible = false;
			this.powerIndicator.gotoAndStop(1);
			
			this.wireBottom.gotoAndStop(1);
		}
		
		public function VisualUpdate():void{ //A placeholder function to update the block visuals
			this.wireBottom.visible = false;
			
			var neighboringWires:Array = []; //See above
			var currentTile:Object; //See above
			var currentBlock:Object; //See above
			var currentSubBlock:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				if(!Main.stageRef.contains(Main.mapEditorUI)){ //See above
					currentTile = TileDatabase.GetTile(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentTile != null){ //See above
						if((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Receiver") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Receiver") != -1)){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][1] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.wireBottom.visible = true;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.wireBottom.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}else{
					currentBlock = BlockDatabase.GetBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					currentSubBlock = BlockDatabase.GetSubBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentBlock != null || currentSubBlock != null){ //See above
						if((currentSubBlock != null && (currentSubBlock.specialTags.indexOf("Receiver") != -1 || currentSubBlock.specialTags.indexOf("Receiver") != -1)) || (currentBlock != null && (currentBlock.specialTags.indexOf("Receiver") != -1 || currentBlock.specialTags.indexOf("Receiver") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][1] == 1 && ((currentSubBlock != null && currentSubBlock.RequestConnection(this, script.column, script.row, ["Receiver"])) || (currentBlock != null && currentBlock.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.wireBottom.visible = true;
								if(currentSubBlock != null && currentSubBlock.specialTags.indexOf("Wire") != -1){
									this.wireBottom.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentSubBlock))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}
			}
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			if(connectionRole.indexOf("Transmitter") != -1 && row == script.row + 1 && column == script.column){
				return true;
			}else{
				return false;
			}
		}
		
		public function EditorDelete(){
			
		}

	}	
}