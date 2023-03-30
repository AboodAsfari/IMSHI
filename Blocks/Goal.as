package Blocks{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class Goal extends BlockBase{

		public function Goal(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the goal visuals 
			super(inputtedColumn, inputtedRow, this, []); //See above
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
			
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			Main.blockContainer.addChild(visual); //See above
		}
		
		override public function Collision(collider):void{ //The level is cleared if a player interacts with the goal
			if(PlayerSpawn == getDefinitionByName(getQualifiedClassName(collider))){ //See above
				LevelHandler.moves++; //See above
				LevelHandler.LevelClear(); //See above
			}
		}

	}	
}