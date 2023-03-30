package Blocks.Observer{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class EastObserver extends BlockBase{
		private var power:Number;
		
		private var isInit:Boolean;
		const initTimer:Timer = new Timer(100, 0);
		const observeTimer:Timer = new Timer(1000, 0);
		
		public function EastObserver(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the observer visuals 
			super(inputtedColumn, inputtedRow, this, ["Transmitter"]); //See above
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			Main.blockContainer.addChild(visual); //See above
			
			power = 0;
			
			isInit = false;
			initTimer.addEventListener(TimerEvent.TIMER, InitComplete);
			initTimer.reset();
			initTimer.start();
		}
		
		override public function BlockUpdate(updater, updateType):void{ //Checks if the block being observed updated
			if(isInit && updater.column == column + 1 && updater.row == row){
				if(power == 0){
					power++;
					
					var target:Object = TileDatabase.GetTile(column - 1, row); //See above
					if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1){ //See above
						target.subOccupiedBlock.TransmitSignal(1, this, [-1, 0]); //See above
					}
					if(target != null && target.occupiedBlock != null && target.occupiedBlock != target.subOccupiedBlock && target.occupiedBlock.specialTags.indexOf("Receiver") != -1){ //See above
						target.occupiedBlock.TransmitSignal(1, this, [-1, 0]); //See above
					}
					
					
					observeTimer.addEventListener(TimerEvent.TIMER, ObserveComplete);
					observeTimer.reset();
					observeTimer.start();
					
					visual.powerIndicator.gotoAndStop(2);
				}else{
					observeTimer.reset();
					observeTimer.start();
				}
				
				for(var i:Number = 0; i < Main.blockList.length; i++){
					Main.blockList[i].BlockUpdate(this, "Signal");
				}
			}
			
			visual.VisualUpdate();
		}
		
		function InitComplete(e:TimerEvent){
			isInit = true;
			initTimer.removeEventListener(TimerEvent.TIMER, InitComplete);
		}
		
		function ObserveComplete(e:TimerEvent){
			observeTimer.stop();
			visual.powerIndicator.gotoAndStop(1);
			
			var target:Object = TileDatabase.GetTile(column - 1, row); //See above
			if(target != null && target.subOccupiedBlock != null && target.subOccupiedBlock.specialTags.indexOf("Receiver") != -1){ //See above
				target.subOccupiedBlock.TransmitSignal(-1, this, [-1, 0]); //See above
			}
			if(target != null && target.occupiedBlock != null && target.occupiedBlock.specialTags.indexOf("Receiver") != -1){ //See above
				target.occupiedBlock.TransmitSignal(-1, this, [-1, 0]); //See above
			}
			observeTimer.removeEventListener(TimerEvent.TIMER, ObserveComplete);
			power = 0;
		}
		
		override public function DeleteBlock():void{ //Deletes the observer
			super.DeleteBlock(); //See above
			initTimer.removeEventListener(TimerEvent.TIMER, InitComplete);
			observeTimer.removeEventListener(TimerEvent.TIMER, ObserveComplete);
		}

	}	
}