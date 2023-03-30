package{
	import flash.display.Stage; 
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.filesystem.*;
	import flash.utils.Dictionary;
	import flash.display.StageDisplayState;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;

	public class Main extends MovieClip{
		public static var stageRef:Stage; //Declares the stage reference variable
		public static var mainGame:MovieClip; //Declares the main game content container
		public static var blockContainer:MovieClip; //Declares the block container 
		public static var subBlockContainer:MovieClip; //Declares the block container 
		public static var loadingScreen:LoadingScreen; //Declares the loading screen movieclip
		public static var mainMenu:MainMenu; //Declares the main menu movieclip
		public static var mapEditorBrowser:MapEditorBrowser; //Declares the map editor browser movieclip
		public static var playMapBrowser:PlayMapBrowser; //Declares the map browser movieclip
		public static var helpScreen:HelpScreen; //Declares the help screen movieclip
		public static var mapEditorUI:MapEditorUI; //Declares the map editor UI movieclip
		public static var editorPause:EditorPause; //Declares the editor pause movieclip
		public static var playPause:PlayPause; //Declares the in game pause movieclip
		public static var levelClear:LevelClear; //Declares the level clear UI movieclip
		public static var settingsMenu:SettingsMenu; //Declares the settings menu movieclip
		public static var blackScreen:BlackScreen; //Declares the black screen border movieclip
		
		public static var selectedMap:String; //Declares the selected map name variable
		
		public static var tileList:Array = []; //Declares the array where tiles will be stored
		public static var blockList:Array = []; //Declares the array where blocks will be stored
		
		public static var playerList:Array = []; //Declares the array where player and dummy blocks will be managed
		
		public static var saveFile:Object; //Declares the save file object
		public static var gameVolume:SoundTransform = new SoundTransform(); //Declares the volume controller
		public static var upKey:Number; //Declares the up key bind
		public static var downKey:Number; //Declares the down key bind
		public static var rightKey:Number; //Declares the right key bind
		public static var leftKey:Number; //Declares the left key bind

		public static const campaign:Array = ["cool thing", "brooo", "mm"]; //Declares and sets the campaign map list 
		
		public function Main():void{	//Runs on program startup
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; //Sets the display mode to fullscreen 
			
			stageRef = stage; //Defines the stage reference and all other movieclips/containers
			mainGame = new MovieClip(); //See above
			blockContainer = new MovieClip(); //See above
			subBlockContainer = new MovieClip(); //See above
			loadingScreen = new LoadingScreen(); //See above 
			mainMenu = new MainMenu(); //See above
			mapEditorBrowser = new MapEditorBrowser(); //See above
			playMapBrowser = new PlayMapBrowser(); //See above
			helpScreen = new HelpScreen(); //See above
			mapEditorUI = new MapEditorUI(); //See above
			editorPause = new EditorPause(); //See above
			playPause = new PlayPause(); //See above
			levelClear = new LevelClear(); //See above
			settingsMenu = new SettingsMenu(); //See above
			blackScreen = new BlackScreen(); //See above
			
			loadingScreen.visible = false; //Hides the loading screen 
		
			var dir:File = new File(File.applicationDirectory.nativePath); //Gets the application directory
			var file:File = dir.resolvePath("save.data"); //Gets the save file
			if(file.exists){ //If the file exists,
				LoadData(); //Load the data from it
			}else{ //Otherwise
				saveFile = { //Create a new save file with the default data:
					campaignData:[], //Empty campaign completion
					mapData:new Dictionary(), //No map statistics
					campaignMapData:new Dictionary(), //No campaign map statistics
					gameVolume: 1, //Full game volume
					upKey: 87, //W key to move up
					downKey: 83, //S key to move down
					rightKey: 68, //D key to move right
					leftKey: 65 //A key to move left
				}
				
				SaveData(); //Creates a new file with this data
			}
			
			TileDatabase.CreateDatabase(); //Initializes the tile database
			BlockDatabase.CreateDatabase(); //Initializes the block database
			MainMenuHandler.MainMenu(); //Goes to the main menu
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown); //Adds a KEY_DOWN listener 
		}
		
		private static function KeyDown(e:KeyboardEvent):void{
			if(e.keyCode == 27){ //If the key is ESC
				e.preventDefault(); //Then prevent the default function of going out of fullscreen
			}
		}
		
		public static function NewMap(mapName, mapFolder):void{ //Generates a map using the specified name and location
			var map:Object = GetMap(mapName, mapFolder); //Declares and defines a map variable, which is set to the map data object retrieved from the .data file
			
			for(var a:Number = 0; a < map.tileData.length; a++){ //Loops through every tile
				var tileClass:Object = TileDatabase.GetClass(map.tileData[a][0]); //Gets the class of the tile
				tileList.push(new Tile(map.tileData[a][1], map.tileData[a][2], tileClass)); //Creates a new tile, passing on it's class, column, and row
				
				if(a == map.tileData.length - 1){ //If the last tile has been instantiated
					TileDatabase.UpdateBorders(); //Update the tile borders and layering
					for(var b:Number = 0; b < map.blockData.length; b++){ //Loop through every block
						var blockClass:Class = BlockDatabase.GetClass(map.blockData[b][0]); //Get the class of the block
						blockList.push(new blockClass(map.blockData[b][1], map.blockData[b][2], map.blockData[b][0])); //Creates a new block, passing on it's class, column, and row		
						
						if(map.blockData[b][0] == 0){ //If the added block is a "Player" block
							mainGame.x = (Math.abs(map.blockData[b][1] - 13) - 1) * 64; //Then center the map around the player
							mainGame.y = (Math.abs(map.blockData[b][2] - 7) - 1) * 64; //See above
						}
						if(b == map.blockData.length - 1){ //If the last block has been instantiated
							loadingScreen.visible = false; //Hide the loading screen
							for(var c:Number = 0; c < blockList.length; c++){
								for(var d:Number = 0; d < blockList.length; d++){
									blockList[d].BlockUpdate(blockList[c], "BlockEnter");
								}
							}
						}
					}
				}
			}
		}
		
		
		public static function AddToGame(object){ //Remove this asap bro
			mainGame.addChild(object);
		}
		
		public static function AddToStage(object):void{ //Adds an object to the stage
			Main.stageRef.addChild(object); //Adds the object to the display list
			Main.stageRef.addChild(loadingScreen); //Sets the loading screen above the object
			Main.stageRef.addChild(blackScreen); //Sets the black screen above everything
		}
		
		public static function CalculateTime(initTime):String{ //Used to calculate time in text form given the number of seconds
			var timeText:String = ""; //Creates an empty string
			var time:Number = initTime; //Declares and defines the time variable to the inputter time
			if(86400 < time){ //If the time is greater than a day
				timeText += Math.floor(time / 86400) + ":"; //Adds the number of days to the string
				time -= 86400 * Math.floor(time / 86400); //Deducts the number of seconds from the timer
			}if(3600 < time){ //If the time is greater than an hour 
				if(Math.floor(time / 3600) < 10){timeText += 0;} //If the number is single digit, a zero is added
				timeText += Math.floor(time / 3600) + ":"; //Adds the number of hours to the string
				time -= 3600 * Math.floor(time / 3600); //Deducts the number of seconds from the timer
			}if(60 < time){ //If the time is greater than a minute
				if(Math.floor(time / 60) < 10){timeText += 0;} //If the number is single digit, a zero is added 
				timeText += Math.floor(time / 60) + ":"; //Adds the number of minutes to the string
				time -= 60  * Math.floor(time / 60); //Deducts the number of seconds from the timer
			}if(Math.floor(time) < 10){timeText += 0;} //If the number is single digit, a zero is added
			timeText += Math.floor(time) + " seconds."; //Adds the number of seconds to the string
			
			return timeText; //Returns the string
		}
		
		public static function SaveMap(saveObject):void{ //Saves the specified map
			var dir:File = new File(File.applicationDirectory.nativePath).resolvePath("Custom Maps"); //Gets the custom map directory
			dir.createDirectory(); //Creates the directory if it doesn't already exist for whatever reason
			
			var file:File = dir.resolvePath(saveObject.levelName + ".data"); //Sets the file directory
			var fileStream:FileStream = new FileStream(); //Starts a new file stream
			fileStream.open(file, FileMode.WRITE); //Opens the file using the stream in write mode
			fileStream.writeObject(saveObject); //Writes the map data onto the file
			fileStream.close(); //Closes the file stream
		}

		public static function GetMap(levelName, foldername):Object{ //Gets a map, given it's name and location
			var dir:File = new File(File.applicationDirectory.nativePath).resolvePath(foldername); //Gets the map directory
			dir.createDirectory(); //Creates the directory if it doesn't already exist for whatever reason
			
			var file:File = dir.resolvePath(levelName + ".data"); //Sets the file directory
			var fileStream:FileStream = new FileStream(); //Starts a new file stream
			fileStream.open(file, FileMode.READ); //Opens the file using the stream in read mode
			var savedObject:Object = fileStream.readObject(); //Reads the object and sets the save object to it
			fileStream.close(); //Closes the file stream

			return savedObject; //Returns the object
		}
		
		public static function GetMapByFile(file):Object{ //Gets a map, given the file
			var fileStream:FileStream = new FileStream(); //Starts a new file stream
			fileStream.open(file, FileMode.READ); //Opens the file using the stream in read mode
			var savedObject:Object = fileStream.readObject(); //Reads the object and sets the save object to it
			fileStream.close(); //Closes the file stream

			return savedObject; //Returns the object
		}
		
		public static function SaveData():void{ //Saves the main game data
			var dir:File = new File(File.applicationDirectory.nativePath); //Gets the application directory
			
			var file:File = dir.resolvePath("save.data"); //Gets the save data directory
			var fileStream:FileStream = new FileStream(); //Starts a new file stream
			fileStream.open(file, FileMode.WRITE); //Opens the file using the stream in write mode
			fileStream.writeObject(saveFile); //Writes the save data onto the file
			fileStream.close(); //Closes the file stream
			
			gameVolume.volume = saveFile.gameVolume; //Updates the save-related variables
			upKey = saveFile.upKey; //See above
			downKey = saveFile.downKey; //See above
			rightKey = saveFile.rightKey; //See above
			leftKey = saveFile.leftKey; //See above
		}
		
		public static function LoadData():void{ //Loads previously saved main game data
			var dir:File = new File(File.applicationDirectory.nativePath); //Gets the application directory
			
			var file:File = dir.resolvePath("save.data"); //Gets the save directory
			var fileStream:FileStream = new FileStream(); //Starts a new file stream
			fileStream.open(file, FileMode.READ); //Opens the file using the stream in read mode
			var savedObject = fileStream.readObject(); //Reads the object and sets the save object to it
			saveFile = savedObject; //Sets the save file to the save object
			
			gameVolume.volume = saveFile.gameVolume; //Updates the save-related variables
			upKey = saveFile.upKey; //See above
			downKey = saveFile.downKey; //See above
			rightKey = saveFile.rightKey; //See above
			leftKey = saveFile.leftKey; //See above
		}
		
		public static function PlaySound(soundClass):void{ //Plays the specified sound
			if(!loadingScreen.visible){ //If the loading screen is not visible
				var sound:Sound = new soundClass(); //A new sound is made
				var soundChannel:SoundChannel = new SoundChannel(); //A new sound channel is created
				soundChannel = sound.play(); //The sound plays
				if(soundChannel != null){
					soundChannel.soundTransform = gameVolume; //The sound volume is set to the game volume
				}
			}
		}
	}
}