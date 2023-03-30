package Blocks.Teleporter{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import Blocks.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class BlueTeleporter extends BlockBase{
		private var visualState:String;
		
		public var poweredBy:Array;
		private var power:Number;
		private var teleportWait:Boolean;
		private var teleportTarget:Object;
		private var expectedTeleport:Array;
		private static var teleporterList:Array =  [];
		
		public function BlueTeleporter(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the yellow plate's visuals 
			super(inputtedColumn, inputtedRow, this, ["Sub-Block", "Receiver"]); //See above
				
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above			
			visualState = "Off";
			
			poweredBy = []; //See above
			power = 0; //See above
			teleporterList.push(this);
			expectedTeleport = [];
			
			TileDatabase.GetTile(column, row).subOccupiedBlock = this; //See above
			
			Main.blockContainer.addChild(visual); //See above
			
			Main.stageRef.addEventListener(Event.ENTER_FRAME, TeleporterAnimator);
			visual.gotoAndStop(1);
		}
		
		public function TransmitSignal(strength, signalSource, sourceDirection):void{ //Transmits a power signal
			power += strength; //See above
			sourceDirection = [sourceDirection[0] * -1, sourceDirection[1] * -1]; //See above
			if(strength == 1){ //See above
				poweredBy.push(signalSource); //See above
			}else{ //See above
				poweredBy.removeAt(poweredBy.indexOf(signalSource)); //See above
			}
			
			if(power == 1 && strength == 1 && TileDatabase.GetTile(column, row).occupiedBlock != null && TileDatabase.GetTile(column, row).occupiedBlock.specialTags.indexOf("Immovable") == -1){
				var concatList:Array = teleporterList.concat();
				teleportWait = true;
				GetTeleporter();
				function GetTeleporter(){
					var randomTeleporter:Object = concatList[Math.floor(Math.random() * (concatList.length - 0.01))];
					var tile:Object = TileDatabase.GetTile(randomTeleporter.column, randomTeleporter.row);
					if(randomTeleporter == this || tile.occupiedBlock != null){
						concatList.removeAt(concatList.indexOf(randomTeleporter));
						if(concatList.length > 0){
							GetTeleporter();
						}	
					}else{
						if(teleportWait){
							var teleportTimer:Timer = new Timer(100, 0);
							teleportTimer.addEventListener(TimerEvent.TIMER, ActivateTeleport);
							teleportTimer.start();
						}else{
							randomTeleporter.Teleport(TileDatabase.GetTile(column, row).occupiedBlock);
							//if(expectedTeleport.inde)
							expectedTeleport.removeAt(expectedTeleport.indexOf(TileDatabase.GetTile(column, row).occupiedBlock));
						}
						
						function ActivateTeleport(e:TimerEvent){
							if(tile.occupiedBlock != null){
								concatList.removeAt(concatList.indexOf(randomTeleporter));
								if(concatList.length > 0){
									teleportWait = false;
									GetTeleporter();
								}	
							}else{
								randomTeleporter.Teleport(TileDatabase.GetTile(column, row).occupiedBlock);
								expectedTeleport.removeAt(expectedTeleport.indexOf(TileDatabase.GetTile(column, row).occupiedBlock));
							}
							teleportTimer.removeEventListener(TimerEvent.TIMER, ActivateTeleport);
						}
					}
				}
			}
			
			BlockUpdate(this, "Signal"); //See above
		}
		
		override public function BlockUpdate(updater, updateType):void{ //Checks if the gate should open or attempt to close
			if(updateType == "BlockEnter" && expectedTeleport.indexOf(updater) != -1 && (updater.column != column || updater.row != row)){
				expectedTeleport.removeAt(expectedTeleport.indexOf(updater));
			}
			if(updateType == "BlockEnter" && updater.column == column && updater.row == row){
				Main.blockContainer.addChild(visual);
			}
			
			if(power > 0 && expectedTeleport.indexOf(updater) != -1 && updateType == "BlockEnter"){ //See above
				var concatList:Array = teleporterList.concat();
				teleportWait = true;
				GetTeleporter();
				function GetTeleporter(){
					var randomTeleporter:Object = concatList[Math.floor(Math.random() * (concatList.length - 0.01))];
					var tile:Object = TileDatabase.GetTile(randomTeleporter.column, randomTeleporter.row);
					if(randomTeleporter == this || tile.occupiedBlock != null){
						concatList.removeAt(concatList.indexOf(randomTeleporter));
						if(concatList.length > 0){
							GetTeleporter();
						}	
					}else{
						if(teleportWait){
							var teleportTimer:Timer = new Timer(100, 0);
							teleportTimer.addEventListener(TimerEvent.TIMER, ActivateTeleport);
							teleportTimer.start();
						}else{
							randomTeleporter.Teleport(updater);
							expectedTeleport.removeAt(expectedTeleport.indexOf(updater));
						}
						
						function ActivateTeleport(e:TimerEvent){
							if(tile.occupiedBlock != null){
								concatList.removeAt(concatList.indexOf(randomTeleporter));
								if(concatList.length > 0){
									teleportWait = false;
									GetTeleporter();
								}	
							}else{
								randomTeleporter.Teleport(updater);
								expectedTeleport.removeAt(expectedTeleport.indexOf(updater));
							}
							teleportTimer.removeEventListener(TimerEvent.TIMER, ActivateTeleport);
						}
					}
				}
			}
			
			if(updateType == "BlockEnter" && ((Math.abs(updater.row - row) == 1 && Math.abs(updater.column - column) == 0) || (Math.abs(updater.row - row) == 0 && Math.abs(updater.column - column) == 1)) && TileDatabase.GetTile(updater.column, updater.row).occupiedBlock == updater && updater.specialTags.indexOf("Immovable") == -1 && expectedTeleport.indexOf(updater) == -1 && (TileDatabase.GetTile(updater.column, updater.row).subOccupiedBlock == null || BlueTeleporter != getDefinitionByName(getQualifiedClassName(TileDatabase.GetTile(updater.column, updater.row).subOccupiedBlock)) || TileDatabase.GetTile(updater.column, updater.row).subOccupiedBlock.power == 0)){
				expectedTeleport.push(updater);
			}
			
			visual.VisualUpdate();
		}
		
		override public function DeleteBlock():void{ //Deletes the gate
			super.DeleteBlock(); //See above
			teleporterList = [];
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, TeleporterAnimator);
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, StopTrail);
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
		
		public function Teleport(block){
			visualState = "Teleport";
			visual.gotoAndPlay(29);
			
			if(block != null && block.specialTags.indexOf("Immovable") == -1){
				teleportTarget = block;
				if(PlayerSpawn == getDefinitionByName(getQualifiedClassName(block))){
					Main.mainGame.x = (Math.abs(column - 13) - 1) * 64; //See above
					Main.mainGame.y = (Math.abs(row - 7) - 1) * 64; //See above
					Main.stageRef.addEventListener(Event.ENTER_FRAME, StopTrail);
				}
				block.Move(column - block.column, row - block.row, true);
				Main.blockContainer.addChild(visual);
			}
		}
		
		private function StopTrail(e:Event){
			if(teleportTarget.trail.isPlaying){
				teleportTarget.trail.gotoAndStop(14);
				Main.stageRef.removeEventListener(Event.ENTER_FRAME, StopTrail);
			}
		}
		
		private function TeleporterAnimator(e:Event){
			if(power > 0 && (visualState == "Off" || (visualState == "On" && (visual.currentFrame > 28 || visual.currentFrame == 1)))){
				visualState = "On";
				visual.gotoAndPlay(1);
				for(var a:Number = 0; a < Main.blockList.length; a++){ //See above
					Main.blockList[a].BlockUpdate(this, "Signal"); //See above
				}
			}else if(power == 0 && visualState == "On"){
				visualState = "Off";
				visual.gotoAndPlay(47);
				for(var b:Number = 0; b < Main.blockList.length; b++){ //See above
					Main.blockList[b].BlockUpdate(this, "Signal"); //See above
				}
			}else if(visualState == "Teleport" && visual.currentFrame < 29){
				visualState = "On";
			}
		}
		
	}	
}