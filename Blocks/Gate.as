package Blocks{
	import flash.events.Event;
	
	public class Gate extends BlockBase{
		private var checkCounter:Number;
		public var poweredBy:Array;
		private var power:Number;
		private var visualState:String;
		
		public function Gate(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the gates's visuals 
			super(inputtedColumn, inputtedRow, this, ["Sub-Block", "Receiver", "Immovable"]); //See above
			checkCounter = 0;
				
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above			
				
			poweredBy = []; //See above
			power = 0; //See above
			visualState = "Off";
			
			TileDatabase.GetTile(column, row).subOccupiedBlock = this; //See above
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			
			Main.subBlockContainer.addChild(visual); //See above
			Main.stageRef.addEventListener(Event.ENTER_FRAME, GateAnimator);
		}
		
		public function TransmitSignal(strength, signalSource, sourceDirection):void{ //Transmits a power signal
			power += strength; //See above
			sourceDirection = [sourceDirection[0] * -1, sourceDirection[1] * -1]; //See above
			if(strength == 1){ //See above
				poweredBy.push(signalSource); //See above
			}else{ //See above
				poweredBy.removeAt(poweredBy.indexOf(signalSource)); //See above
			}
			
			if((strength == 1 && power == 1) || (strength == -1 && power == 0)){
				for(var i:Number = 0; i < Main.blockList.length; i++){ //See above
					Main.blockList[i].BlockUpdate(this, "Signal"); //See above
				}
			}
		}
		
		override public function BlockUpdate(updater, updateType):void{ //Checks if the gate should open or attempt to close
			visual.VisualUpdate();
		}
		
		override public function DeleteBlock():void{ //Deletes the gate
			super.DeleteBlock(); //See above
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, GateAnimator);
		}
		
		override public function Move(xChange, yChange, resetPos):void{ //Moves the block
			for(var a:Number = 0; a < Main.blockList.length; a++){ //See above
				Main.blockList[a].BlockUpdate(this, "BlockExit"); //See above
			}
			
			if(resetPos){ //See above
				TileDatabase.GetTile(column, row).subOccupiedBlock = null; //See above
			}
					
			column += xChange; //See above
			row += yChange; //See above
					
			TileDatabase.GetTile(column, row).subOccupiedBlock = this; //See above
					
			visual.x = (column * TileDatabase.tileSize) + 0.5*(64-visual.width); //See above
			visual.y = (row * TileDatabase.tileSize) + 0.5*(64-visual.height); //See above
			
			for(var i:Number = 0; i < Main.blockList.length; i++){ //See above
				Main.blockList[i].BlockUpdate(this, "BlockEnter"); //See above
			}
		}
		
		private function GateAnimator(e:Event){ //Animates the gate when needed
			if(TileDatabase.GetTile(column, row).occupiedBlock != null && TileDatabase.GetTile(column, row).occupiedBlock != this){
				if(visual.currentFrame < 12){ //See above
					visual.stop(); //See above
					visual.gotoAndPlay(11+(12-visual.currentFrame)); //See above
				}else if(visual.currentFrame == 1){ //See above
					visual.gotoAndPlay(1); //See above
				}
				visualState = "On"; //See above
			}else if(power > 0 && (visualState == "Off" || (visualState == "On" && visual.currentFrame < 11))){ //See above
				visualState = "On"; //See above
				TileDatabase.GetTile(column, row).occupiedBlock = null; //See above
			}else if(TileDatabase.GetTile(column, row).occupiedBlock == null){ //See above
				if(visual.currentFrame > 11){ //See above
					visual.stop(); //See above
					visual.gotoAndPlay(20-(visual.currentFrame-1)); //See above
				}
				visualState = "Off"; //See above
				TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			}
			
			if(power > 0 && visual.powerIndicator != null){ //See above
				visual.powerIndicator.gotoAndStop(2); //See above
			}else if(visual.powerIndicator != null){ //See above
				visual.powerIndicator.gotoAndStop(1); //See above
			}
		}
		
	}	
}