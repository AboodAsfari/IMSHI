package{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Dictionary;
	import BlockVisuals.*;
	
	public class MapEditor{
		public static var mapGrid:MovieClip; //Declares the map grid container
		public static var offsetX:Number = 0; //Declares the grid offset variables
		public static var offsetY:Number = 0; //See above
		public static var tileData:Array = []; //Declares the data arrays
		public static var blockData:Array = []; //See above
		private static var gridList:Array = []; //Declares the array for grid tiles
		private static var blockIconIDList:Dictionary = new Dictionary();
		
		private static var timeSinceSave:Number; //Declares the variable to store the time since last saving
		
		private static var editor:MovieClip = Main.mapEditorUI; //Declares the variable for the editor UI
		
		public static var rightDown:Boolean; //Booleans to check if specific events are active
		public static var middleDown:Boolean; //See above
		public static var leftDown:Boolean; //See above
		public static var ctrlDown:Boolean; //See above
		public static var navMode:Boolean; //See above
		public static var buildMode:Boolean; //See above
		public static var paused:Boolean; //See above
		
		public static var selectedBlockID:Number = 0; //Declares a variable that will determine the block placed
		public static var selectedItem:MovieClip; //A variable that will store the visual for the selected item
		public static var hoveredTile:Object; //A variable that will store the hovered item
		
		private static var buttonWhiteList:Array; //Declares the buttonWhiteList, and the other relevant button-related arrays
		private static var buttonClickFunctions:Array = [[ItemPanel, TilesMode, BuildMode, 0, 0, 0, 0], [Pause, Save, ExitPanel, SavePanel, Exit, ExitPanel]]; //See above
		private static var isHover:Array = [[false, false, false, false, false, false, false], [false, false, false, false, false, false]]; //See above
		
		public static var actionHistory:Array; //An array of arrays to track actions, in order to CTRL-Z them
		public static var deleteType:String; //An array of arrays to track actions, in order to CTRL-Z them
		
		private static function EditorSetup():void{
			mapGrid = new MovieClip(); //Makes a new movieclip
			
			//Defines the buttonWhiteList
			buttonWhiteList = [[editor.itemPanel.tilesButton, editor.itemPanel.blocksButton],
			[Main.editorPause.resumeButton, Main.editorPause.saveButton, Main.editorPause.quitButton, Main.editorPause.pauseSavePanel.confirmSaveButton, Main.editorPause.exitEditor.exitButton, Main.editorPause.exitEditor.cancelButton]];
			
			for(var a:Number = 0; a < 15; a++){ //Loops through the number of rows
				for(var b:Number = 0; b < 25; b++){ //Loops through the number of columns
					gridList.push(new GridTile(b, a)); //Makes a GridTile
				}
			}
			
			var row:Number = 0;
			var column:Number = 1;
			
			for(var c:Number = 0; c < TileDatabase.tileDatabase.length; c++){ //Makes an icon for every tile
				if(column == 6){
					row++;
					column = 1;
				}
				var tileIconClass:Class = TileDatabase.GetIconClass(c); //See above
				var tileIcon:MovieClip = new tileIconClass(); //See above
				editor.itemPanel.tilesPanel.addChild(tileIcon); //See above
				buttonWhiteList[0].push(tileIcon); //See above
				tileIcon.x = 85 * (column-1) - 10; //See above
				tileIcon.y = row * 80; //See above
				column ++;
			}
			
			row = 0;
			column = 1;
			
			for(var d:Number = 0; d < BlockDatabase.blockDatabase.length; d++){ //Makes an icon for every block
				if(BlockDatabase.blockDatabase[d][4]){
					if(column == 6){
						row++;
						column = 1;
					}
					var blockIconClass:Class = BlockDatabase.GetIconClass(d); //See above
					var blockIcon:MovieClip = new blockIconClass(); //See above
					editor.itemPanel.blockPanel.addChild(blockIcon); //See above
					buttonWhiteList[0].push(blockIcon); //See above
					blockIcon.x = (85 * (column-1)) + 0.5*(64-blockIcon.width) - 10; //See above
					blockIcon.y = (row * 80) + 0.5*(64-blockIcon.height); //See above
					column ++;
					
					blockIconIDList[blockIcon] = d;
				}
			}
			
			
		}
		
		public static function EditMap(mapName):void{ 
			if(mapGrid == null){ //Sets up the editor if it hasn't been setup yet
				EditorSetup(); //See above
			}
			
			paused = false; //Resets the relevant variables
			ctrlDown = false; //See above
			timeSinceSave = 0; //See above
			
			actionHistory = []; //Clears the actionHistory array
			
			editor.itemPanel.gotoAndStop(1); //Resets the states of UI panels, and shows them, whilst removing main menu UI elements
			Main.editorPause.gotoAndStop(1); //See above
			Main.editorPause.exitEditor.visible = false; //See above
			Main.stageRef.removeChild(Main.mainMenu); //See above
			Main.stageRef.removeChild(Main.mapEditorBrowser); //See above
			Main.stageRef.removeChild(Main.playMapBrowser); //See above
			Main.stageRef.removeChild(Main.settingsMenu); //See above
			Main.AddToStage(mapGrid); //See above
			Main.AddToStage(Main.mainGame); //See above
			Main.mainGame.addChild(Main.blockContainer); //See above
			Main.mainGame.addChild(Main.subBlockContainer); //See above
			Main.AddToStage(Main.mapEditorUI); //See above
			Main.AddToStage(Main.editorPause); //See above
			
			if(selectedItem != null){ //If a selectedItem already exists
				editor.removeChild(selectedItem); //Deletes the selectedItem
				buttonWhiteList[0].removeAt(0); //See above
			}
			
			selectedItem = new PlainsIcon(); //Sets the selected item to the plains icon
			buttonWhiteList[0].insertAt(0, selectedItem); //See above
			editor.addChild(selectedItem); //See above
			selectedItem.x = 1500; //See above
			selectedItem.y = 7; //See above
			
			editor.mapName.text = Main.selectedMap; //Updates the map name
			
			var map:Object = Main.GetMap(mapName, "Custom Maps"); //Generates the map
			for(var a:Number = 0; a < map.tileData.length; a++){ //See above
				selectedBlockID = map.tileData[a][0]; //See above
				NewTile(map.tileData[a][1] - offsetX, map.tileData[a][2] - offsetY, false); //See above
				
				if(a == map.tileData.length - 1){ //See above
					TileDatabase.UpdateBorders(); //See above
					for(var b:Number = 0; b < map.blockData.length; b++){ //See above
						selectedBlockID = map.blockData[b][0]; //See above
						if(BlockDatabase.blockDatabase[selectedBlockID][5]){
							NewBlock(map.blockData[b][1], map.blockData[b][2], false, true); //See above
						}else{
							NewBlock(map.blockData[b][1], map.blockData[b][2], false, false); //See above
						}
						
						if(map.blockData[b][0] == 0){ //See above
							offsetX = map.blockData[b][1] - 13; //See above
							offsetY = map.blockData[b][2] - 7; //See above
							Main.mainGame.x = (Math.abs(offsetX) - 1) * 64; //See above
							Main.mainGame.y = (Math.abs(offsetY) - 1) * 64; //See above
						}
						if(b == map.blockData.length - 1){ //See above
							Main.loadingScreen.visible = false; //See above
						}
					}
				}
			}
			
			TilesMode(); //Sets the build mode to tiles
			
			Main.stageRef.addEventListener(Event.ENTER_FRAME, HoverChecker); //Adds the relevant event listeners
			Main.stageRef.addEventListener(MouseEvent.CLICK, Clicked); //See above
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
			Main.stageRef.addEventListener(KeyboardEvent.KEY_UP, KeyReleased); //See above
			
			Main.stageRef.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, RightDown); //See above
			Main.stageRef.addEventListener(MouseEvent.RIGHT_MOUSE_UP, RightUp); //See above
			Main.stageRef.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, MiddleDown); //See above
			Main.stageRef.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, MiddleUp); //See above
			Main.stageRef.addEventListener(MouseEvent.MOUSE_DOWN, LeftDown); //See above
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, LeftUp); //See above
			Main.stageRef.addEventListener(MouseEvent.MOUSE_WHEEL, ItemVariant); //See above
		}
		
		public static function NewTile(column, row, reversible):void{ //Makes a new tile, and adds it to the tile list
			Main.PlaySound(Block); //See above
			
			var tileClass:Class = TileDatabase.GetClass(selectedBlockID);  //See above
			var tile:EditorTile = new EditorTile(column + offsetX, row + offsetY, tileClass) //See above
			Main.tileList.push(tile); //See above
			TileDatabase.UpdateBorders(); //See above
				
			tileData.push([TileDatabase.GetID(tileClass), column + offsetX, row + offsetY]); //See above
			if(reversible && actionHistory.length > 0){ //See above
				actionHistory[actionHistory.length-1].push(tile.DeleteTile); //See above
			}
		}
		
		public static function NewBlock(column, row, reversible, subBlock):void{ //Makes a new block, and adds it to the block list
			var blockClass:Class = BlockDatabase.GetVisualClass(selectedBlockID); //See above
			var hasPlayer:Boolean = false; //See above
			for(var a:Number = 0; a < blockData.length; a++){ //See above
				if(blockData[a][0] == 0){ //See above
					hasPlayer = true; //See above
					break; //See above
				}
			}
		
			if(blockClass != Player || !hasPlayer){ //See above
				Main.PlaySound(Block); //See above
				var block:MovieClip = new blockClass(TileDatabase.GetTile(column, row)); //See above
				Main.blockList.push(block); //See above
				
				if(!subBlock){
					if(BlockDatabase.blockDictX[column] != null && BlockDatabase.blockDictX[column].length > 0){ //See above
						BlockDatabase.blockDictX[column].push(block); //See above
					}else{ //See above
						BlockDatabase.blockDictX[column] = [block]; //See above
					}
					
					if(BlockDatabase.blockDictY[row] != null && BlockDatabase.blockDictY[row].length > 0){ //See above
						BlockDatabase.blockDictY[row].push(block); //See above
					}else{
						BlockDatabase.blockDictY[row] = [block]; //See above
					}
					
					Main.blockContainer.addChild(block); //See above
					
					if(reversible){ //See above
						actionHistory[actionHistory.length-1].push(TileDatabase.GetTile(column,row).DeleteBlock); //See above
					}
				}else{
					if(BlockDatabase.subBlockDictX[column] != null && BlockDatabase.subBlockDictX[column].length > 0){ //See above
						BlockDatabase.subBlockDictX[column].push(block); //See above
					}else{ //See above
						BlockDatabase.subBlockDictX[column] = [block]; //See above
					}
					
					if(BlockDatabase.subBlockDictY[row] != null && BlockDatabase.subBlockDictY[row].length > 0){ //See above
						BlockDatabase.subBlockDictY[row].push(block); //See above
					}else{
						BlockDatabase.subBlockDictY[row] = [block]; //See above
					}
					
					Main.subBlockContainer.addChild(block); //See above
					
					if(reversible){ //See above
						actionHistory[actionHistory.length-1].push(TileDatabase.GetTile(column,row).DeleteSubBlock); //See above
					}
				}
				
				AnimateIn(); //See above
				
				blockData.push([BlockDatabase.GetID(blockClass), column, row]); //See above
				
				function AnimateIn(){ //See above
					block.scaleX = block.scaleY = 1.1; //See above
					block.addEventListener(Event.ENTER_FRAME, Animate); //See above
					function Animate(e:Event){ //See above
						block.scaleX = block.scaleY -= 0.05; //See above
						if(block.scaleX <= 1){ //See above
							block.removeEventListener(Event.ENTER_FRAME, Animate); //See above
						}
					}
				}
				
				for(var b:Number = 0; b < Main.blockList.length; b++){ //See above
					Main.blockList[b].VisualUpdate(); //See above
				}
			}
		}
		
		private static function HoverChecker(e:Event):void{ //Checks if a button is being hovered over and updates save time
			if(timeSinceSave != 0){ //See above
				timeSinceSave += (1/60); //See above
			}
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //See above
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //See above
					if(buttonWhiteList[a][b].currentFrame < 3 && buttonWhiteList[a][b].visible){ //See above
						if(buttonWhiteList[a][b].hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true) && (!paused || a == 1) && (!Main.editorPause.pauseSavePanel.visible || b == 3) && (!Main.editorPause.exitEditor.visible || b > 3)){ //See above
							buttonWhiteList[a][b].gotoAndStop(2); //See above
						
							if(!isHover[a][b]){ //See above
								if((a != 0 || Main.editorPause.currentFrame != 15) && (buttonWhiteList[a][b] != Main.editorPause.pauseSavePanel.confirmSaveButton || Main.editorPause.pauseSavePanel.visible)&& (a != 1 || b < 4 || Main.editorPause.exitEditor.visible) && (a != 0 || b < 3)){ //See above
									Main.PlaySound(ButtonHover); //See above
									isHover[a][b] = true; //See above
								}
							}
						
							if(a == 0 && b > TileDatabase.tileDatabase.length + 2){ //See above
								if(editor.itemPanel.blockPanel.visible){ //See above
									if(!isHover[a][b]){ //See above
										isHover[a][b] = true; //See above
										Main.PlaySound(ButtonHover); //See above
									}
									editor.itemPanel.itemName.text = BlockDatabase.GetName(blockIconIDList[buttonWhiteList[a][b]]); //See above
								}
							}else if(a == 0 && b > 2 && editor.itemPanel.tilesPanel.visible){ //See above
								if(!isHover[a][b]){ //See above
									isHover[a][b] = true; //See above
									Main.PlaySound(ButtonHover); //See above
								}
								editor.itemPanel.itemName.text = TileDatabase.GetName(b-3); //See above
							}
						}else{
							buttonWhiteList[a][b].gotoAndStop(1); //See above
							if(isHover[a][b]){ //See above
								isHover[a][b] = false; //See above
							}
						}
					}else if(!buttonWhiteList[a][b].hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true)){ //See above
						buttonWhiteList[a][b].gotoAndStop(1); //See above
					}
				}
			}
		}

		private static function Clicked(e:MouseEvent):void{ //Runs functions when a button is pressed
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //See above
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //See above
					if(buttonWhiteList[a][b] == e.target && !paused && a != 1){ //See above
						if(a == 0 && b > TileDatabase.tileDatabase.length + 2){ //See above
							Main.PlaySound(OptionButton); //See above
							
							selectedBlockID = blockIconIDList[buttonWhiteList[a][b]];; //See above
							var blockClass:Class = BlockDatabase.GetIconClass(selectedBlockID); //See above
							
							editor.removeChild(selectedItem); //See above
							buttonWhiteList[0].removeAt(0); //See above
							
							selectedItem = new blockClass(); //See above
							buttonWhiteList[0].insertAt(0, selectedItem); //See above
							editor.addChild(selectedItem); //See above
							selectedItem.x = 1500 + 0.5*(64-selectedItem.width); //See above
							selectedItem.y = 7 + 0.5*(64-selectedItem.width); //See above
						}else if(a == 0 && b > 2){ //See above
							Main.PlaySound(OptionButton); //See above
							
							var tileClass:Class = TileDatabase.GetIconClass(b-3); //See above
							selectedBlockID = b - 3; //See above
							
							editor.removeChild(selectedItem); //See above
							buttonWhiteList[0].removeAt(0); //See above
							
							selectedItem = new tileClass(); //See above
							buttonWhiteList[0].insertAt(0, selectedItem); //See above
							editor.addChild(selectedItem); //See above
							selectedItem.x = 1500 + 0.5*(64-selectedItem.width); //See above
							selectedItem.y = 7 + 0.5*(64-selectedItem.width); //See above
						}else{
							buttonClickFunctions[a][b](); //See above
						}
					}
				}
			}
		}
		
		private static function ItemPanel():void{ //Toggles the item panel
			Main.PlaySound(UISelect); //See above
			editor.itemPanel.play(); //See above
		}
		
		private static function TilesMode():void{ //Sets the build mode to tiles
			Main.PlaySound(UISelect); //See above
			
			buildMode = false; //See above
			editor.itemPanel.tilesPanel.visible = true; //See above
			editor.itemPanel.blockPanel.visible = false; //See above
			selectedBlockID = 0; //See above
			
			editor.removeChild(selectedItem); //See above
			buttonWhiteList[0].removeAt(0); //See above
							
			selectedItem = new PlainsIcon(); //See above
			buttonWhiteList[0].insertAt(0, selectedItem); //See above
			editor.addChild(selectedItem); //See above
			selectedItem.x = 1500 + 0.5*(64-selectedItem.width); //See above
			selectedItem.y = 7 + 0.5*(64-selectedItem.width); //See above
			
			editor.itemPanel.itemName.text = "Plains"; //See above
		}
		
		private static function BuildMode():void{ //Sets the build mode to blocks
			Main.PlaySound(UISelect); //See above
			
			buildMode = true; //See above
			editor.itemPanel.tilesPanel.visible = false; //See above
			editor.itemPanel.blockPanel.visible = true; //See above
			selectedBlockID = 0; //See above
			
			editor.removeChild(selectedItem); //See above
			buttonWhiteList[0].removeAt(0); //See above
							
			selectedItem = new PlayerIcon(); //See above
			buttonWhiteList[0].insertAt(0, selectedItem); //See above
			editor.addChild(selectedItem); //See above
			selectedItem.x = 1500 + 0.5*(64-selectedItem.width); //See above
			selectedItem.y = 7 + 0.5*(64-selectedItem.width); //See above
			
			editor.itemPanel.itemName.text = "Player"; //See above
		}
		
		private static function KeyPressed(e:KeyboardEvent):void{ //Used to pause/unpause
			if(e.keyCode == 27){ //See above
				if(Main.editorPause.pauseSavePanel.visible){ //See above
					SavePanel(); //See above
				}else if(Main.editorPause.exitEditor.visible){ //See above
					ExitPanel(); //See above
				}else{
					Pause(); //See above
				}
			}else if(e.controlKey){ //See above
				ctrlDown = true; //See above
				if(e.keyCode == 90 && actionHistory.length > 0 && !leftDown){ //See above
					for(var i:Number = 0; i < actionHistory[actionHistory.length-1].length; i++){ //See above
						if(actionHistory[actionHistory.length-1][i].length > 1){ //See above
							actionHistory[actionHistory.length-1][i](false, false); //See above
						}else{
							actionHistory[actionHistory.length-1][i](false); //See above
						}
					}
					
					actionHistory.removeAt(actionHistory.length-1); //See above
				}
			}
		}
		
		private static function KeyReleased(e:KeyboardEvent):void{ //Sets ctrlDown to false
			if(e.controlKey || e.keyCode == 17){ //See above
				ctrlDown = false; //See above
			}
		}
		
		private static function Pause():void{ //Pauses/unpauses the game
			Main.editorPause.play(); //See above
			if(Main.editorPause.currentFrame < 15){ //See above
				Main.PlaySound(UIIn); //See above
				paused = true; //See above
			}else{
				Main.PlaySound(UIOut); //See above
				paused = false; //See above
			}
		}
		
		private static function Save():void{ //Saves the map
			Main.PlaySound(OptionButton); //See above
			
			var map:Object = { //See above
				levelName: Main.selectedMap, //See above
				tileData: tileData, //See above
				blockData: blockData //See above
			}
			
			var hasPlayer:Boolean = false; //See above
			var hasGoal:Boolean = false; //See above
			for(var i:Number = 0; i < blockData.length; i++){ //See above
				if(blockData[i][0] == 0){ //See above
					hasPlayer = true; //See above
				}else if(blockData[i][0] == 2){ //See above
					hasGoal = true; //See above
				}
			}
			
			if(hasPlayer && hasGoal){ //See above
				Main.SaveMap(map); //See above
				timeSinceSave = 1/60; //See above
				Main.editorPause.pauseSavePanel.saveMessage.text = "Map saved successfully!"; //See above
			}else{
				if(hasPlayer){ //See above
					Main.editorPause.pauseSavePanel.saveMessage.text = "Missing a goal to save the map."; //See above
				}else if(hasGoal){ //See above
					Main.editorPause.pauseSavePanel.saveMessage.text = "Missing a player to save the map."; //See above
				}else{
					Main.editorPause.pauseSavePanel.saveMessage.text = "Missing a player and a goal to save the map."; //See above
				}
				Main.PlaySound(ErrorAudio); //See above
			}
					
			SavePanel(); //See above
		}
		
		private static function SavePanel():void{ //Toggles save panel visibility
			if(!Main.editorPause.pauseSavePanel.visible){ //See above
				Main.editorPause.pauseSavePanel.visible = true; //See above
			}else{ //See above
				Main.editorPause.pauseSavePanel.visible = false; //See above
				Main.PlaySound(OptionButton); //See above
			}
		}
		
		private static function ExitPanel():void{ //Toggles the exit panel
			if(!Main.editorPause.exitEditor.visible){ //See above
				Main.PlaySound(OptionButton); //See above
				Main.editorPause.exitEditor.visible = true; //See above
				if(timeSinceSave == 0){ //See above
					Main.editorPause.exitEditor.exitMessage.text = "Time since last save: N/A"; //See above
				}else{ //See above
					Main.stageRef.addEventListener(Event.ENTER_FRAME, SaveTimerUpdate); //See above
				}
			}else{ //See above
				Main.editorPause.exitEditor.visible = false; //See above
				Main.PlaySound(OptionButton); //See above
			}
		}
		
		private static function SaveTimerUpdate(e:Event):void{ //Updates the time since last save text
			Main.editorPause.exitEditor.exitMessage.text = "Time since last save: " + Main.CalculateTime(timeSinceSave); //See above
		}
		
		private static function Exit():void{ //Exits back to the main menu
			Main.PlaySound(UIOut); //See above
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, HoverChecker); //See above
			Main.stageRef.removeEventListener(MouseEvent.CLICK, Clicked); //See above
			Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
			
			Main.stageRef.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, RightDown); //See above
			Main.stageRef.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, RightUp); //See above
			Main.stageRef.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, MiddleDown); //See above
			Main.stageRef.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, MiddleUp); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, LeftDown); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, LeftUp); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_WHEEL, ItemVariant); //See above
			
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, SaveTimerUpdate); //See above
			
			for(var i:Number = Main.tileList.length; i > 0; i--){ //See above
				Main.tileList[i-1].DeleteTile(true, true); //See above
				if(i == 1){ //See above
					MainMenuHandler.MainMenu(); //See above
				}
			}
		}
		
		private static function RightDown(e:MouseEvent):void{ //Sets rightDown to true
			rightDown = true; //See above
			deleteType = "None";
		}
		
		private static function RightUp(e:MouseEvent):void{ //Sets rightDown to false
			rightDown = false; //See above
		}
		
		private static function LeftDown(e:MouseEvent):void{ //Sets leftDown to true, and adds a new list to actionHistory
			actionHistory.push([]); //See above
			leftDown = true; //See above
			for(var a:Number = 0; a < buttonWhiteList[1].length; a++){ //See above
				if(buttonWhiteList[1][a] == e.target && (!Main.editorPause.pauseSavePanel.visible || a == 3) && (!Main.editorPause.exitEditor.visible || a > 3)){ //See above
					buttonWhiteList[1][a].gotoAndStop(3); //See above
				}
			}
		}
		
		private static function LeftUp(e:MouseEvent):void{ //Runs button code
			if(actionHistory.length > 0 && actionHistory[actionHistory.length-1].length == 0){ //See above
				actionHistory.removeAt(actionHistory.length-1); //See above
			}
			leftDown = false; //See above
			for(var a:Number = 0; a < buttonWhiteList[1].length; a++){ //See above
				if(buttonWhiteList[1][a] == e.target && Main.editorPause.currentFrame == 15 && (!Main.editorPause.pauseSavePanel.visible || a == 3) && (!Main.editorPause.exitEditor.visible || a > 3) && e.target.currentFrame == 3){ //See above
					buttonWhiteList[1][a].gotoAndStop(2); //See above
					buttonClickFunctions[1][a](); //See above
				}
			}
		}
		
		private static function MiddleDown(e:MouseEvent):void{ //Starts navMode
			middleDown = true; //See above
			navMode = true; //See above
			
			var initGameX = Main.mainGame.x; //See above
			var initGameY = Main.mainGame.y; //See above
			var initMouseX = Main.stageRef.mouseX; //See above
			var initMouseY = Main.stageRef.mouseY; //See above
			var initOffsetX = offsetX; //See above
			var initOffsetY = offsetY; //See above
			
			Main.stageRef.addEventListener(Event.ENTER_FRAME, MoveMap); //See above
			function MoveMap(e:Event):void{ //See above
				Main.mainGame.x = initGameX + 64 * Math.ceil((Main.stageRef.mouseX - initMouseX) / 64); //See above
				Main.mainGame.y = initGameY + 64 * Math.ceil((Main.stageRef.mouseY - initMouseY) / 64);  //See above
				offsetX = initOffsetX - Math.ceil((Main.stageRef.mouseX - initMouseX) / 64); //See above
				offsetY = initOffsetY - Math.ceil((Main.stageRef.mouseY - initMouseY) / 64); //See above
				
				if(!navMode){  //See above
					Main.stageRef.removeEventListener(Event.ENTER_FRAME, MoveMap); //See above
				}
			}
		}
		
		private static function MiddleUp(e:MouseEvent):void{ //Stops navMode
			middleDown = false; //See above
			navMode = false; //See above
		}
		
		private static function ItemVariant(e:MouseEvent):void{ //Switches to another variant of the selected block if applicable
			if(buildMode){ //See above
				if(e.delta < 0 && BlockDatabase.blockDatabase[selectedBlockID+1] != null && !BlockDatabase.blockDatabase[selectedBlockID+1][4] && buildMode){
					selectedBlockID++; //See above
				}else if(e.delta > 0 && BlockDatabase.blockDatabase[selectedBlockID] != null && !BlockDatabase.blockDatabase[selectedBlockID][4] && buildMode){
					selectedBlockID--; //See above
				}else if(e.delta < 0 && !BlockDatabase.blockDatabase[selectedBlockID][4] && buildMode){ //See above
					for(var a:Number = selectedBlockID; a > 0; a--){ //See above
						if(BlockDatabase.blockDatabase[a-1][4]){ //See above
							selectedBlockID = a - 1; //See above
							break; //See above
						}
					}
				}else if(e.delta > 0 && BlockDatabase.blockDatabase[selectedBlockID][4] && BlockDatabase.blockDatabase[selectedBlockID+1] != null && !BlockDatabase.blockDatabase[selectedBlockID+1][4] && buildMode){
					for(var b:Number = selectedBlockID+1; b < BlockDatabase.blockDatabase.length; b++){ //See above
						if(BlockDatabase.blockDatabase[b][4]){ //See above
							selectedBlockID = b - 1; //See above
							break; //See above
						}else if(!BlockDatabase.blockDatabase[b][4] && b + 1 == BlockDatabase.blockDatabase.length){ //See above
							selectedBlockID = b; //See above
							break; //See above
						}
					}
				}
				
				var blockClass:Class = BlockDatabase.GetIconClass(selectedBlockID); //See above
								
				editor.removeChild(selectedItem); //See above
				buttonWhiteList[0].removeAt(0); //See above
								
				selectedItem = new blockClass(); //See above
				buttonWhiteList[0].insertAt(0, selectedItem); //See above
				editor.addChild(selectedItem); //See above
				selectedItem.x = 1500 + 0.5*(64-selectedItem.width); //See above
				selectedItem.y = 7 + 0.5*(64-selectedItem.width); //See above
				
				for(var i:Number = 0; i < Main.tileList.length; i++){
					Main.tileList[i].ResetPreview();
				}
			}
		}

	}	
}