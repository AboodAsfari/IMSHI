package Blocks.Piston{
	import flash.events.Event;
	
	public class SouthPiston extends BlockBase{	
		public var poweredBy:Array;
		private var power:Number;
		private var isInit:Boolean;
		private var visualState:String;
		private var fakePiston:Object;
		
		public function SouthPiston(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the yellow plate's visuals 
			super(inputtedColumn, inputtedRow, this, ["Receiver"]); //See above
				
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above			
				
			poweredBy = []; //See above
			power = 0; //See above
			visualState = "Off";
			isInit = false;
			
			fakePiston = {
				column: column,
				row: row + 1
			}
			
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			
			Main.blockContainer.addChild(visual); //See above
			Main.stageRef.addEventListener(Event.ENTER_FRAME, PistonAnimator);
		}
		
		public function TransmitSignal(strength, signalSource, sourceDirection):void{ //Transmits a power signal
			if(sourceDirection[1] != -1){
				power += strength; //See above
				sourceDirection = [sourceDirection[0] * -1, sourceDirection[1] * -1]; //See above
				if(strength == 1){ //See above
					poweredBy.push(signalSource); //See above
				}else{ //See above
					poweredBy.removeAt(poweredBy.indexOf(signalSource)); //See above
				}
				
				BlockUpdate(this, "Signal"); //See above
			}
		}
		
		override public function BlockUpdate(updater, updateType):void{ //Checks if the gate should open or attempt to close
			if(updater == this && updateType == "BlockEnter"){
				if(!isInit){
					isInit = true;
				}else{
					power = 0;
					poweredBy = [];
					for(var a:Number = 0; a < Main.blockList.length; a++){
						if(Main.blockList[a] != this){
							Main.blockList[a].BlockUpdate(this, "BlockEnter");
						}
					}
				}
			}
		}
		
		override public function DeleteBlock():void{ //Deletes the gate
			super.DeleteBlock(); //See above
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, PistonAnimator);
		}
		
		private function PistonAnimator(e:Event){
			if(power > 0 && (visualState == "Off" || (visualState == "On" && (visual.currentFrame > 8 || visual.currentFrame == 1)))){
				visualState = "On";
				var tile:Object = TileDatabase.GetTile(column, row + 1);
				if(tile != null && (tile.occupiedBlock == null || (tile.occupiedBlock.specialTags.indexOf("Immovable") == -1 && TileDatabase.GetTile(column, row + 2) != null && TileDatabase.GetTile(column, row + 2).occupiedBlock == null))){
					if(visual.currentFrame > 8){
						visual.stop();
						visual.gotoAndPlay(8+(9-visual.currentFrame));
					}else if(visual.currentFrame == 1){
						visual.gotoAndPlay(1);
					}
					specialTags.push("Immovable");
					if(tile.occupiedBlock != null){
						tile.occupiedBlock.Move(0, 1, true);
					}
					tile.occupiedBlock = this;
					visual.powerIndicator.gotoAndStop(2);
					for(var a:Number = 0; a < Main.blockList.length; a++){
						Main.blockList[a].BlockUpdate(fakePiston, "BlockEnter");
						Main.blockList[a].BlockUpdate(this, "Piston");
					}
				}
			}else if(power == 0 && (visualState == "On" || (visualState == "Off" && (visual.currentFrame > 1 || visual.currentFrame < 9)))){
				var retractionTile:Object = TileDatabase.GetTile(column, row + 1);
				if(visual.currentFrame < 9 && visual.currentFrame != 1){
					visual.stop();
					visual.gotoAndPlay(9+(8-visual.currentFrame));
					visual.powerIndicator.gotoAndStop(1);
					//specialTags.removeAt(specialTags.indexOf("Immovable"));
					if(TileDatabase.GetTile(fakePiston.column, fakePiston.row) != null && TileDatabase.GetTile(fakePiston.column, fakePiston.row).occupiedBlock == this){
						TileDatabase.GetTile(fakePiston.column, fakePiston.row).occupiedBlock = null;
					}
					for(var b:Number = 0; b < Main.blockList.length; b++){
						Main.blockList[b].BlockUpdate(fakePiston, "BlockExit");
						Main.blockList[b].BlockUpdate(this, "Piston");
					}
				}
				visualState = "Off";
			}
			
			if(visual.currentFrame == 1 && visualState == "Off" && specialTags.indexOf("Immovable") != -1){
				specialTags.removeAt(specialTags.indexOf("Immovable"));
				if(TileDatabase.GetTile(fakePiston.column, fakePiston.row) != null && TileDatabase.GetTile(fakePiston.column, fakePiston.row).occupiedBlock == this){
					TileDatabase.GetTile(fakePiston.column, fakePiston.row).occupiedBlock = null;
				}
			}
		}
		
		override public function Move(xChange, yChange, resetPos):void{ //Moves the block
			super.Move(xChange, yChange, resetPos);
			fakePiston.column += xChange;
			fakePiston.row += yChange;
		}	
		
	}	
}