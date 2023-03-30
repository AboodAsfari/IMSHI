package BlockVisuals.Teleporter{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class GreenTeleporterVisual extends MovieClip{
		public var script:Object;
		public var connector:BottomPlugPreset;
		public const specialTags = ["Receiver"];
		
		public function GreenTeleporterVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript;
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize); //See above
			
			connector = new BottomPlugPreset();
			
			connector.x = (script.column * TileDatabase.tileSize); //See above
			connector.y = (script.row * TileDatabase.tileSize); //See above
			
			connector.wireRight.gotoAndStop(1);
			connector.wireLeft.gotoAndStop(1);
			connector.wireTop.gotoAndStop(1);
			connector.wireBottom.gotoAndStop(1);
		}
		
		public function VisualUpdate():void{ //A placeholder function to update the block visuals
			Main.subBlockContainer.addChildAt(connector, 0); //See above
			connector.wireRight.visible = false;
			connector.wireLeft.visible = false;
			connector.wireTop.visible = false;
			connector.rightBlocker.visible = true;
			connector.leftBlocker.visible = true;
			connector.topBlocker.visible = true;
		
			var neighboringWires:Array = []; //See above
			var currentTile:Object; //See above
			var occupiedBlock:Object; //See above
			var subOccupiedBlock:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				if(!Main.stageRef.contains(Main.mapEditorUI)){ //See above
					currentTile = TileDatabase.GetTile(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentTile != null){ //See above
						if((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								connector.wireRight.visible = true;
								connector.rightBlocker.visible = false;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								connector.wireLeft.visible = true;
								connector.leftBlocker.visible = false;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								connector.wireTop.visible = true;
								connector.topBlocker.visible = false;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}else{
					occupiedBlock = BlockDatabase.GetBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					subOccupiedBlock = BlockDatabase.GetSubBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(occupiedBlock != null || subOccupiedBlock != null){ //See above
						if((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Transmitter") != -1)){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((subOccupiedBlock != null && subOccupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (occupiedBlock != null && occupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								connector.wireRight.visible = true;
								connector.rightBlocker.visible = false;
								if(subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(subOccupiedBlock))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((subOccupiedBlock != null && subOccupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (occupiedBlock != null && occupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								connector.wireLeft.visible = true;
								connector.leftBlocker.visible = false;
								if(subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(subOccupiedBlock))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((subOccupiedBlock != null && subOccupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (occupiedBlock != null && occupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								connector.wireTop.visible = true;
								connector.topBlocker.visible = false;
								if(subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(subOccupiedBlock))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
				}
			}
			
			if(neighboringWires.length == 0 || (neighboringWires.length == 1 && neighboringWires[0][1] == 1)){
				connector.visible = false;
			}else{
				connector.visible = true;
			}
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			if(connectionRole.indexOf("Receiver") != -1){
				return true;
			}else{
				return false;
			}
		}
		
		public function EditorDelete(){
			Main.subBlockContainer.removeChild(connector);
		}

	}	
}