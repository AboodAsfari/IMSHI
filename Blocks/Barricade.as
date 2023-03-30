package Blocks{
	
	public class Barricade extends BlockBase{

		public function Barricade(inputtedColumn, inputtedRow, inputtedID):void{ //Sets up the barricade visuals 
			super(inputtedColumn, inputtedRow, this, ["Barricade"]); //See above
			TileDatabase.GetTile(column, row).occupiedBlock = this; //See above
	
			var blockClass:Class = BlockDatabase.GetVisualClass(inputtedID); //See above
			visual = new blockClass(this); //See above
			Main.blockContainer.addChild(visual); //See above
		}
		
		override public function BlockUpdate(updater, updateType):void{
			visual.VisualUpdate();
		}

	}	
}