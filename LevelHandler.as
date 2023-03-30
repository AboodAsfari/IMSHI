package{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class LevelHandler{
		private static var paused:Boolean; //A boolean to check if the game is paused
		private static var gameType:String; //The game type
		
		private static var buttonWhiteList:Array; //Declares the buttonWhiteList, and the other relevant button-related arrays
		private static var buttonClickFunctions:Array = [[PausePanel, ExitPanel], [ExitMap, ExitPanel], [NextLevel, RestartLevel, ExitMap]]; //See above
		private static var isHover:Array = [[false, false], [false, false], [false, false, false]]; //See above
		
		public static var moves:Number; //The number of moves
		public static var gameTime:Number; //The game timer
		public static var solved:Number; //If the puzzle is solved or not
		
		private static function GameSetup():void{ //Sets up the buttonWhiteList
			buttonWhiteList = [[Main.playPause.resumeButton, Main.playPause.exitButton], //See above 
			[Main.playPause.exitGame.exitButton, Main.playPause.exitGame.cancelButton], //See above
			[Main.levelClear.nextLevelButton, Main.levelClear.restartButton, Main.levelClear.quitButton]]; //See above
		}
		
		public static function LoadMap(mapName, mapFolder):void{ //Loads up a map
			if(buttonWhiteList == null){ //See above
				GameSetup(); //See above
			}
			
			paused = false; //See above
			gameType = mapFolder; //See above
			
			moves = 0; //See above
			gameTime = 0; //See above
			solved = 0; //See above
			
			Main.levelClear.gotoAndStop(1); //See above
			Main.playPause.gotoAndStop(1); //See above
			Main.playPause.exitGame.visible = false; //See above
			if(Main.stageRef.contains(Main.mainMenu)){ //See above
				Main.stageRef.removeChild(Main.mainMenu); //See above
				Main.stageRef.removeChild(Main.mapEditorBrowser); //See above
				Main.stageRef.removeChild(Main.playMapBrowser); //See above
				Main.stageRef.removeChild(Main.settingsMenu); //See above
			}
			Main.AddToStage(Main.mainGame); //See above
			Main.AddToStage(Main.playPause); //See above
			Main.AddToStage(Main.levelClear); //See above
			Main.mainGame.addChild(Main.blockContainer); //See above
			Main.mainGame.addChild(Main.subBlockContainer); //See above
			
			Main.NewMap(mapName, mapFolder); //See above
			
			Main.stageRef.addEventListener(Event.ENTER_FRAME, HoverChecker); //See above
			Main.stageRef.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //See above
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, MouseUp); //See above
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
		}
		
		private static function HoverChecker(e:Event):void{ //Checks if a button is being hovered over
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //See above
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //See above
					if(buttonWhiteList[a][b].currentFrame < 3 && buttonWhiteList[a][b].visible){ //See above
						if(buttonWhiteList[a][b].hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true) && (a == 1 || !Main.playPause.exitGame.visible)){ //See above
							buttonWhiteList[a][b].gotoAndStop(2); //See above
							if(!isHover[a][b]){ //See above
								isHover[a][b] = true; //See above
								if(a != 1 || Main.playPause.exitGame.visible){ //See above
									Main.PlaySound(ButtonHover); //See above
								}
							}
						}else{
							buttonWhiteList[a][b].gotoAndStop(1); //See above
							if(isHover[a][b]){ //See above
								isHover[a][b] = false; //See above
							}
						}
					}else if(!buttonWhiteList[a][b].hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true) && buttonWhiteList[a][b].currentFrame != 4){ //See above
						buttonWhiteList[a][b].gotoAndStop(1); //See above
					}
				}
			}
			
			gameTime += 1/60; //See above
		}

		private static function MouseDown(e:MouseEvent):void{ //Changes the frame of a button when pressed
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //See above
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //See above
					if(buttonWhiteList[a][b] == e.target && (a == 1 || !Main.playPause.exitGame.visible) && buttonWhiteList[a][b].currentFrame != 4){ //See above
						buttonWhiteList[a][b].gotoAndStop(3); //See above
					}
				}
			}
		}
		
		private static function MouseUp(e:MouseEvent):void{ //Runs the button functions
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //See above
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //See above
					if(buttonWhiteList[a][b] == e.target && (a == 1 || !Main.playPause.exitGame.visible) && buttonWhiteList[a][b].currentFrame == 3){ //See above
						buttonWhiteList[a][b].gotoAndStop(2); //See above
						buttonClickFunctions[a][b](); //See above
					}
				}
			}
		}
		
		private static function KeyPressed(e:KeyboardEvent):void{ //Moves the player and pauses
			if(e.keyCode == Main.leftKey && !paused){ //See above
				Main.playerList.sortOn("column", Array.NUMERIC); //See above
				for(var a:Number = 0; a < Main.playerList.length; a++){ //See above
					Main.playerList[a].MovePlayer(-1, 0); //See above
				}
				Main.PlaySound(Move); //See above
			}else if(e.keyCode == Main.rightKey && !paused){ //See above
				Main.playerList.sortOn("column", Array.NUMERIC | Array.DESCENDING); //See above
				for(var b:Number = 0; b < Main.playerList.length; b++){ //See above
					Main.playerList[b].MovePlayer(1, 0); //See above
				}
				Main.PlaySound(Move); //See above
			}else if(e.keyCode == Main.downKey && !paused){ //See above
				Main.playerList.sortOn("row", Array.NUMERIC | Array.DESCENDING); //See above
				for(var c:Number = 0; c < Main.playerList.length; c++){ //See above
					Main.playerList[c].MovePlayer(0, 1); //See above
				}
				Main.PlaySound(Move); //See above
			}else if(e.keyCode == Main.upKey && !paused){ //See above
				Main.playerList.sortOn("row", Array.NUMERIC); //See above
				for(var d:Number = 0; d < Main.playerList.length; d++){ //See above
					Main.playerList[d].MovePlayer(0, -1); //See above
				}
				Main.PlaySound(Move); //See above
			}else if(e.keyCode == 82 && !paused){ //See above
				paused = true;
				Main.PlaySound(UISelect); //See above
				var resetTimer:Timer = new Timer(100, 0);
				resetTimer.addEventListener(TimerEvent.TIMER, StartReset);
				resetTimer.start();
				function StartReset(e:TimerEvent){
					ResetMap(); //See above
					resetTimer.removeEventListener(TimerEvent.TIMER, StartReset);
				}
			}else if(e.keyCode == 27 && Main.levelClear.currentFrame == 1){  //See above
				if(!Main.playPause.exitGame.visible){ //See above
					PausePanel(); //See above
				}else{
					ExitPanel(); //See above
				}
			}
		}
		
		private static function PausePanel():void{ //Toggles the pause panel
			Main.playPause.play(); //See above
			if(Main.playPause.currentFrame < 15){ //See above
				paused = true; //See above
				Main.PlaySound(UIIn); //See above
			}else{
				paused = false; //See above
				Main.PlaySound(UIOut); //See above
			}
		}
		
		private static function ExitPanel():void{ //Toggles the exit panel
			if(Main.playPause.exitGame.visible){ //See above
				Main.playPause.exitGame.visible = false; //See above
				Main.PlaySound(OptionButton); //See above
			}else{
				Main.playPause.exitGame.visible = true; //See above
				Main.PlaySound(OptionButton); //See above
			}
		}
		
		private static function ResetMap():void{ //Resets the map
			SaveData();
			
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, HoverChecker); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, MouseUp); //See above
			Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
						
			for(var a:Number = Main.tileList.length; a > 0; a--){ //See above
				Main.tileList[a-1].DeleteTile(); //See above
				if(a == 1){ //See above
					for(var b:Number = Main.blockList.length; b > 0; b--){ //See above
						Main.blockList[b-1].DeleteBlock(); //See above
						if(b == 1){
							LoadMap(Main.selectedMap, gameType); //See above
						}
					}
				}
			}
		}
		
		private static function ExitMap():void{ //Exits the map
			SaveData();
			Main.PlaySound(UIOut); //See above
			
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, HoverChecker); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, MouseUp); //See above
			Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
						
			for(var a:Number = Main.tileList.length; a > 0; a--){ //See above
				Main.tileList[a-1].DeleteTile(); //See above
				if(a == 1){ //See above
					for(var b:Number = Main.blockList.length; b > 0; b--){ //See above
						Main.blockList[b-1].DeleteBlock(); //See above
						if(b == 1){
							MainMenuHandler.MainMenu(); //See above
						}
					}
				}
			}
		}
		
		public static function LevelClear():void{ //Runs when the level is complete
			Main.PlaySound(LevelCleared); //See above
			solved = 1; //See above
			
			Main.levelClear.clearMoves.text = moves + " Moves"; //See above
			Main.levelClear.clearTime.text = Main.CalculateTime(gameTime); //See above
			
			if(gameType == "Campaign" && Main.selectedMap != Main.campaign[Main.campaign.length-1]){ //See above
				Main.saveFile.campaignData.push(1); //See above
				Main.levelClear.nextLevelButton.gotoAndStop(1); //See above
			}else{
				Main.levelClear.nextLevelButton.gotoAndStop(4); //See above
			}
			
			SaveData(); //See above
			ResetData();
			
			Main.levelClear.gotoAndPlay(1); //See above
			paused = true; //See above
		}
		
		private static function RestartLevel():void{ //Restarts the level
			Main.PlaySound(UISelect); //See above
			Main.levelClear.gotoAndPlay(15); //See above
			ResetMap(); //See above
			
			var moveCooldown:Timer = new Timer(270, 0); //See above
			moveCooldown.start(); //See above
			moveCooldown.addEventListener(TimerEvent.TIMER, CanMove); //See above
			function CanMove(e:TimerEvent){ //See above
				paused = false; //See above
				moveCooldown.removeEventListener(TimerEvent.TIMER, CanMove); //See above
			}
		}
		
		private static function NextLevel():void{ //Goes to the next level
			Main.PlaySound(UISelect); //See above
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, HoverChecker); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //See above
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, MouseUp); //See above
			Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
						
			for(var i:Number = Main.tileList.length; i > 0; i--){ //See above
				Main.tileList[i-1].DeleteTile(); //See above
				if(i == 1){ //See above
					Main.selectedMap = Main.campaign[Main.campaign.indexOf(Main.selectedMap)+1] //See above
					LoadMap(Main.selectedMap, "Campaign"); //See above
				}
			}
		}
		
		private static function SaveData():void{ //Saves the map stats
			if(gameType == "Campaign"){
				if(Main.saveFile.campaignMapData[Main.selectedMap] != null){ //See above
					Main.saveFile.campaignMapData[Main.selectedMap][3] += moves; //See above
					if(Main.saveFile.campaignMapData[Main.selectedMap][2] > moves){ //See above
						Main.saveFile.campaignMapData[Main.selectedMap][2] = moves; //See above
						Main.levelClear.movesRecord.visible = true; //See above
					}else{
						Main.levelClear.movesRecord.visible = false; //See above
					}
					
					Main.saveFile.campaignMapData[Main.selectedMap][1] += gameTime; //See above
					if(Main.saveFile.campaignMapData[Main.selectedMap][0] > gameTime){ //See above
						Main.saveFile.campaignMapData[Main.selectedMap][0] = gameTime; //See above
						Main.levelClear.timeRecord.visible = true; //See above
					}else{
						Main.levelClear.timeRecord.visible = false; //See above
					}
					
					Main.saveFile.campaignMapData[Main.selectedMap][4] += solved; //See above
				}else{
					Main.saveFile.campaignMapData[Main.selectedMap] = [gameTime, gameTime, moves, moves, solved]; //Fastest time, total time, fastest moves, total moves, total solves

					Main.levelClear.movesRecord.visible = true; //See above
					Main.levelClear.timeRecord.visible = true; //See above
				}
				
				Main.SaveData(); //See above
			}else{
				if(Main.saveFile.mapData[Main.selectedMap] != null){ //See above
					Main.saveFile.mapData[Main.selectedMap][3] += moves; //See above
					if(Main.saveFile.mapData[Main.selectedMap][2] > moves){ //See above
						Main.saveFile.mapData[Main.selectedMap][2] = moves; //See above
						Main.levelClear.movesRecord.visible = true; //See above
					}else{
						Main.levelClear.movesRecord.visible = false; //See above
					}
					
					Main.saveFile.mapData[Main.selectedMap][1] += gameTime; //See above
					if(Main.saveFile.mapData[Main.selectedMap][0] > gameTime){ //See above
						Main.saveFile.mapData[Main.selectedMap][0] = gameTime; //See above
						Main.levelClear.timeRecord.visible = true; //See above
					}else{
						Main.levelClear.timeRecord.visible = false; //See above
					}
					
					Main.saveFile.mapData[Main.selectedMap][4] += solved; //See above
				}else{
					Main.saveFile.mapData[Main.selectedMap] = [gameTime, gameTime, moves, moves, solved]; //Fastest time, total time, fastest moves, total moves, total solves

					Main.levelClear.movesRecord.visible = true; //See above
					Main.levelClear.timeRecord.visible = true; //See above
				}
				
				Main.SaveData(); //See above
			}
		}
		
		private static function ResetData():void{ //Resets the game stat data
			moves = 0; //See above
			gameTime = 0; //See above
			solved = 0; //See above
		}
		
	}
}