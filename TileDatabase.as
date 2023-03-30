package{
	import flash.utils.Dictionary;
	
	public class TileDatabase{
		public static var tileDatabase:Array; //Stores the tile database
		
		public static var tileDictX:Dictionary = new Dictionary(); //Dictionary that stores tiles based on their coordinates
		public static var tileDictY:Dictionary = new Dictionary(); //See above
		
		public static const tileSize:Number = 64; //The base tile size
					
		public static function CreateDatabase():void{ //Creates the tile database
			tileDatabase = new Array( //See above
				[PlainsTile, PlainsIcon, "Plains"], //See above
				[WastesTile, WastesIcon, "Wastes"], //See above
				[GlassTile, GlassIcon, "Glass"] //See above
			);
		}
		
		public static function GetID(inputtedClass){ //Gets the tile ID
			for(var i:Number = 0; i < tileDatabase.length; i++){ //See above
				if(tileDatabase[i].indexOf(inputtedClass) != -1){ //See above
					return i; //See above
				}
			}
			
			return null; //See above
		}
		
		public static function GetClass(inputtedID):Class{ //Gets the tile class
			return tileDatabase[inputtedID][0]; //See above
		}
		
		public static function GetIconClass(inputtedID):Class{ //Gets the tile icon class
			return tileDatabase[inputtedID][1]; //See above
		}
		
		public static function GetName(inputtedID):String{ //Gets the tile name
			return tileDatabase[inputtedID][2]; //See above
		}
		
		public static function GetTile(inputtedX, inputtedY):Object{ //Gets a tile
			if(tileDictX[inputtedX] != null && tileDictX[inputtedX].length > 0 && tileDictY[inputtedY] != null && tileDictY[inputtedY].length > 0){ //See above
				for(var i:Number = 0; i < tileDictX[inputtedX].length; i++){ //See above
					if(tileDictY[inputtedY].indexOf(tileDictX[inputtedX][i]) != -1){ //See above
						return tileDictX[inputtedX][i]; //See above
					}
				}
			}
			
			return null; //See above
		}
		
		public static function UpdateBorders():void{ //Updates all borders and the layering
			for(var a:Number = Main.tileList.length; a > 0; a--){ //See above
				Main.tileList[a-1].UpdateBorders(); //See above
			}
			
			var yList:Array = []; //See above
			var index:Number = 0; //See above
			for(var b:Object in tileDictY){ //See above
				yList.push(b); //See above
			}
			yList.sort(Array.NUMERIC); //See above
			
			for(var c:Number = 0; c < yList.length; c++){ //See above
				for(var d:Number = 0; d < tileDictY[yList[c]].length; d++){ //See above
					Main.mainGame.setChildIndex(tileDictY[yList[c]][d].tile, Main.mainGame.numChildren - 1) //See above
				}
			}
			
			Main.mainGame.setChildIndex(Main.subBlockContainer, Main.mainGame.numChildren - 1); //See above
			Main.mainGame.setChildIndex(Main.blockContainer, Main.mainGame.numChildren - 1); //See above
		}

	}	
}