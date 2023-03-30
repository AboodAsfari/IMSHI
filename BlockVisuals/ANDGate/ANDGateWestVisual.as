package BlockVisuals.ANDGate{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class ANDGateWestVisual extends MovieClip{
		public var script:Object;
		public const specialTags = ["Receiver", "Transmitter"];
		
		public function ANDGateWestVisual(inputtedScript):void{ //Sets the block coordinates
			script = inputtedScript;
			this.x = (script.column * TileDatabase.tileSize) + 0.5*(64-this.width); //See above
			this.y = (script.row * TileDatabase.tileSize) + 0.5*(64-this.height); //See above
			this.gotoAndStop(1); //See above
			this.connector.visible = false;
			
			this.connector.wireRight.gotoAndStop(1);
			this.connector.wireLeft.gotoAndStop(1);
			this.connector.wireTop.gotoAndStop(1);
			this.connector.wireBottom.gotoAndStop(1);
		}
		
		public function VisualUpdate():void{ //A placeholder function to update the block visuals
			this.connector.wireRight.visible = false;
			this.connector.wireLeft.visible = false;
			this.connector.wireTop.visible = false;
			this.connector.wireBottom.visible = false;
			this.northIndicator.gotoAndStop(3);
			this.southIndicator.gotoAndStop(3);
			this.eastIndicator.gotoAndStop(3);
			
			var neighboringWires:Array = []; //See above
			var currentTile:Object; //See above
			var occupiedBlock:Object; //See above
			var subOccupiedBlock:Object; //See above
			const neighboringTiles:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]]; //See above
			for(var a:Number = 0; a < neighboringTiles.length; a++){ //See above
				if(!Main.stageRef.contains(Main.mapEditorUI)){ //See above
					currentTile = TileDatabase.GetTile(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(currentTile != null){ //See above
						if((currentTile.subOccupiedBlock != null && (currentTile.subOccupiedBlock.specialTags.indexOf("Receiver") != -1 || currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1)) || (currentTile.occupiedBlock != null && (currentTile.occupiedBlock.specialTags.indexOf("Receiver") != -1 || currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireRight.visible = true;
								if(script.eastInput != 0){
									this.eastIndicator.gotoAndStop(2);
								}else{
									this.eastIndicator.gotoAndStop(1);
								}
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Receiver") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Receiver") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Receiver") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireLeft.visible = true;
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireTop.visible = true;
								if(script.northInput != 0){
									this.northIndicator.gotoAndStop(2);
								}else{
									this.northIndicator.gotoAndStop(1);
								}
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else if(neighboringTiles[a][1] == 1 && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (currentTile.occupiedBlock != null && currentTile.occupiedBlock.visual.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireBottom.visible = true;
								if(script.southInput != 0){
									this.southIndicator.gotoAndStop(2);
								}else{
									this.southIndicator.gotoAndStop(1);
								}
								if(currentTile.subOccupiedBlock != null && currentTile.subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireBottom.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(currentTile.subOccupiedBlock.visual))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
					
					if(script.power != 0){
						gateIndicator.gotoAndStop(2);
					}else{
						gateIndicator.gotoAndStop(1);
					}
				}else{
					occupiedBlock = BlockDatabase.GetBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					subOccupiedBlock = BlockDatabase.GetSubBlock(script.column + neighboringTiles[a][0], script.row + neighboringTiles[a][1]); //See above
					if(occupiedBlock != null || subOccupiedBlock != null){ //See above
						if((subOccupiedBlock != null && (subOccupiedBlock.specialTags.indexOf("Receiver") != -1 || subOccupiedBlock.specialTags.indexOf("Transmitter") != -1)) || (occupiedBlock != null && (occupiedBlock.specialTags.indexOf("Receiver") != -1 || occupiedBlock.specialTags.indexOf("Transmitter") != -1))){
							neighboringWires.push(neighboringTiles[a]); //See above
							if(neighboringTiles[a][0] == 1 && ((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((subOccupiedBlock != null && subOccupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (occupiedBlock != null && occupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireRight.visible = true;
								if(subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireRight.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(subOccupiedBlock))) + 1);
								}
							}else if(neighboringTiles[a][0] == -1 && ((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Receiver") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Receiver") != -1)) && ((subOccupiedBlock != null && subOccupiedBlock.RequestConnection(this, script.column, script.row, ["Receiver"])) || (occupiedBlock != null && occupiedBlock.RequestConnection(this, script.column, script.row, ["Receiver"])))){
								this.connector.wireLeft.visible = true;
								if(subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireLeft.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(subOccupiedBlock))) + 1);
								}
							}else if(neighboringTiles[a][1] == -1 && ((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((subOccupiedBlock != null && subOccupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (occupiedBlock != null && occupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireTop.visible = true;
								if(subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireTop.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(subOccupiedBlock))) + 1);
								}
							}else if(neighboringTiles[a][1] == 1 && ((subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Transmitter") != -1) || (occupiedBlock != null && occupiedBlock.specialTags.indexOf("Transmitter") != -1)) && ((subOccupiedBlock != null && subOccupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])) || (occupiedBlock != null && occupiedBlock.RequestConnection(this, script.column, script.row, ["Transmitter"])))){
								this.connector.wireBottom.visible = true;
								if(subOccupiedBlock != null && subOccupiedBlock.specialTags.indexOf("Wire") != -1){
									this.connector.wireBottom.gotoAndStop(BlockDatabase.wireList.indexOf(getDefinitionByName(getQualifiedClassName(subOccupiedBlock))) + 1);
								}
							}else{
								neighboringWires.removeAt(neighboringWires.indexOf(neighboringTiles[a])); //See above
							}
						}
					}
					
					this.gateIndicator.gotoAndStop(1);
				}
			}
			
			if(neighboringWires.length == 0){
				this.connector.visible = false;
			}else{
				this.connector.visible = true;
			}
		}
		
		public function RequestConnection(requester, column, row, connectionRole):Boolean{
			if(script.column - column == 1 && connectionRole.indexOf("Transmitter") != -1){
				return true;
			}else if(script.column - column != 1 && connectionRole.indexOf("Receiver") != -1){
				return true;
			}else{
				return false;
			}
		}
		
		public function EditorDelete(){
			
		}

	}	
}