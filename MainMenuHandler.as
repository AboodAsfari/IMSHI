package{
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.desktop.NativeApplication;
	import flash.filesystem.*;
	import flash.utils.Timer;
	import flash.utils.Dictionary;
	
	public class MainMenuHandler{
		private static var levelButtons:Array; //Declares the array that will store all the campaign select buttons 
		private static var buttonWhiteList:Array; //Declares the array that will store all the buttons in the main menu
		private static var buttonClickFunctions:Array = [[PlayMapBrowser, MapEditorBrowser, QuitGame, SettingsMenu, HelpMenu], [EditMap, RenameMap, DeleteMapPanel, MapEditorBrowser, NewMap, 0, 0, 0, 0], [ChangeName, RenameMap], [DeleteMap, DeleteMapPanel], [CustomMode, PlayGame, PlayMapBrowser, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [CampaignMode, PlayGame, PlayMapBrowser, 0, 0, 0, 0], [ChangeUp, ChangeDown, ChangeRight, ChangeLeft, 0, ResetSave], [ResetData, ResetSave], [ArchivesScreen, BackGuide, NextGuide], [GuideScreen, 0, 0, 0, 0, 0, 0, 0, 0]]; //Declares ands sets the array that stores all the functions that will run when a button is pressed 
		private static var isHover:Array = [[false, false, false, false], [false, false, false, false, false, false, false, false, false], [false, false], [false, false], [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false], [false, false, false, false, false, false, false], [false, false, false, false, false, false], [false, false], [false, false, false], [false, false, false, false, false, false, false, false, false]]; //Declares and sets the array that will store the hover state of a button
		
		private static const panelList:Array = [Main.mapEditorBrowser.panelOne, Main.mapEditorBrowser.panelTwo, Main.mapEditorBrowser.panelThree, Main.mapEditorBrowser.panelFour]; //Declares and sets the array that stores all the map editor browser panels
		
		private static var selectedMap:Object; //Declares the selected map variable
		private static var selectedPanel:MovieClip; //Declares the selected map panel variable
		private static var mapListPage:Number; //Declares the map list page 
		private static var newMapCreation:Boolean; //Declares the boolean to check if a new map is being created
		private static var changingBindings:Boolean; //Declares the boolean to check if a key bind is being changed
		private static var changingVolume:Boolean; //Declares the boolean to check if the volume is being changed
		private static var subMenu:Boolean; //Declares the boolean to check if a sub menu is open
		
		private static var editorBrowser:MovieClip; //Declares the variable that will store the map editor browser
		private static var playBrowser:MovieClip; //Declares the variable that will store the map browser
		
		private static function InitMenu():void{ //Runs once to set up the main menu 
			editorBrowser = Main.mapEditorBrowser; //Defines the editor browser
			playBrowser = Main.playMapBrowser; //Defines the map browser
			
			levelButtons = [playBrowser.campaignScreen.levelOne, playBrowser.campaignScreen.levelTwo, playBrowser.campaignScreen.levelThree, playBrowser.campaignScreen.levelFour, playBrowser.campaignScreen.levelFive, playBrowser.campaignScreen.levelSix, playBrowser.campaignScreen.levelSeven, playBrowser.campaignScreen.levelEight, playBrowser.campaignScreen.levelNine, playBrowser.campaignScreen.levelTen, playBrowser.campaignScreen.levelEleven, playBrowser.campaignScreen.levelTwelve, playBrowser.campaignScreen.levelThirteen, playBrowser.campaignScreen.levelFourteen, playBrowser.campaignScreen.levelFifteen]; //Defines the campaign buttons array
	         
            //Defines all the main menu buttons, with sub-arrays in the array used as a way to know what ui panel a button belongs to
			buttonWhiteList = [[Main.mainMenu.playButton, Main.mainMenu.createButton, Main.mainMenu.quitButton, Main.mainMenu.settingsButton, Main.mainMenu.helpButton], 
			[editorBrowser.editMapButton, editorBrowser.renameMapButton, editorBrowser.deleteMapButton, editorBrowser.exitBrowserButton, editorBrowser.newMapButton, editorBrowser.panelOne, editorBrowser.panelTwo, editorBrowser.panelThree, editorBrowser.panelFour],
			[editorBrowser.mapRenamePanel.confirmRenameButton, editorBrowser.mapRenamePanel.cancelRenameButton],
			[editorBrowser.mapDeletePanel.confirmDeleteButton, editorBrowser.mapDeletePanel.cancelDeleteButton],
			[playBrowser.campaignScreen.customButton, playBrowser.campaignScreen.playMap, playBrowser.campaignScreen.exitBrowser, playBrowser.campaignScreen.levelOne, playBrowser.campaignScreen.levelTwo, playBrowser.campaignScreen.levelThree, playBrowser.campaignScreen.levelFour, playBrowser.campaignScreen.levelFive, playBrowser.campaignScreen.levelSix, playBrowser.campaignScreen.levelSeven, playBrowser.campaignScreen.levelEight, playBrowser.campaignScreen.levelNine, playBrowser.campaignScreen.levelTen, playBrowser.campaignScreen.levelEleven, playBrowser.campaignScreen.levelTwelve, playBrowser.campaignScreen.levelThirteen, playBrowser.campaignScreen.levelFourteen, playBrowser.campaignScreen.levelFifteen],
			[playBrowser.customScreen.campaignButton, playBrowser.customScreen.playMap, playBrowser.customScreen.exitBrowser, playBrowser.customScreen.customMapOne, playBrowser.customScreen.customMapTwo, playBrowser.customScreen.customMapThree, playBrowser.customScreen.customMapFour],
			[Main.settingsMenu.keyBindOne, Main.settingsMenu.keyBindTwo, Main.settingsMenu.keyBindThree, Main.settingsMenu.keyBindFour, Main.settingsMenu.sliderContainer.volumeButtonSFX, Main.settingsMenu.resetDataButton],
			[Main.settingsMenu.resetSave.resetButton, Main.settingsMenu.resetSave.cancelButton],
			[Main.helpScreen.guideScreen.archivesButton, Main.helpScreen.guideScreen.backPage, Main.helpScreen.guideScreen.nextPage],
			[Main.helpScreen.archivesScreen.guideButton, Main.helpScreen.archivesScreen.playerIcon, Main.helpScreen.archivesScreen.dummyIcon, Main.helpScreen.archivesScreen.goalIcon, Main.helpScreen.archivesScreen.rockIcon, Main.helpScreen.archivesScreen.crateIcon, Main.helpScreen.archivesScreen.wireIcon, Main.helpScreen.archivesScreen.junctionIcon, Main.helpScreen.archivesScreen.plateIcon, Main.helpScreen.archivesScreen.delayerIcon, Main.helpScreen.archivesScreen.flipFlopIcon, Main.helpScreen.archivesScreen.observerIcon, Main.helpScreen.archivesScreen.ANDIcon, Main.helpScreen.archivesScreen.ORIcon, Main.helpScreen.archivesScreen.XORIcon, Main.helpScreen.archivesScreen.gateIcon, Main.helpScreen.archivesScreen.teleporterIcon, Main.helpScreen.archivesScreen.pistonIcon, Main.helpScreen.archivesScreen.lampIcon]];
		
			Main.settingsMenu.keyBindOne.bindText.text = "UP: " + String.fromCharCode(Main.upKey); //Sets the keybind text and disables mouse interactions with it
			Main.settingsMenu.keyBindOne.bindText.mouseEnabled = false; //See above
			Main.settingsMenu.keyBindTwo.bindText.text = "DOWN: " + String.fromCharCode(Main.downKey); //See above
			Main.settingsMenu.keyBindTwo.bindText.mouseEnabled = false; //See above
			Main.settingsMenu.keyBindThree.bindText.text = "RIGHT: " + String.fromCharCode(Main.rightKey); //See above
			Main.settingsMenu.keyBindThree.bindText.mouseEnabled = false; //See above
			Main.settingsMenu.keyBindFour.bindText.text = "LEFT: " + String.fromCharCode(Main.leftKey); //See above
			Main.settingsMenu.keyBindFour.bindText.mouseEnabled = false; //See above
			changingBindings = false; //Sets changingBindings to false
			
			Main.settingsMenu.sliderContainer.volumeButtonSFX.x = (1 - Main.gameVolume.volume) * -502.25; //Sets the x of the volume slider depending on the game volume
			Main.settingsMenu.volumeText.text = String(Math.ceil(Main.gameVolume.volume * 100)) + "%"; //Sets the volume text to the game volume
			changingVolume = false; //Sets changingVolume to false
		}
		
		public static function MainMenu():void{ 
			if(buttonWhiteList == null){ //If the buttonwhitelist isn't defined, then the menu hasn not been set up yet
				InitMenu(); //Set up the menu
			}
			
			editorBrowser.gotoAndStop(1); //Resets the ui's states and adds them to the stage
			playBrowser.gotoAndStop(1); //See above
			Main.settingsMenu.changeKeyPanel.visible = false; //See above
			Main.AddToStage(Main.mainMenu); //See above
			Main.AddToStage(editorBrowser); //See above
			Main.AddToStage(Main.settingsMenu); //See above
			Main.AddToStage(Main.helpScreen); //See above
			Main.AddToStage(playBrowser); //See above
			const removeList:Array = [MapEditor.mapGrid, Main.mainGame, Main.mapEditorUI, Main.editorPause, Main.playPause, Main.levelClear]; //A list of ui elements to remove from the stage
			for(var i:Number = 0; i < removeList.length; i++){ //Loops through the remove list
				if(removeList[i] != null && Main.stageRef.contains(removeList[i])){ //If the movieclip is on the stage
					Main.stageRef.removeChild(removeList[i]); //Remove it from the stage
				}
			}
			
			subMenu = false; //Sets subMenu to false
			
			Main.stageRef.addEventListener(Event.ENTER_FRAME, HoverChecker); //Adds an ENTER_FRAME listener to check hover status
			Main.stageRef.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //Adds a MOUSE_DOWN listener 
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, MouseUp); //Adds a MOUSE_UP listener
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //Adds a KEY_DOWN listener to exit ui easily
		}
		
		private static function HoverChecker(e:Event):void{ //Runs every frame
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //Loops through all of buttonWhiteList
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //Loops through every object inside the lists inside buttonWhiteList
					if(!changingBindings && !changingVolume){ //If bindings and volume are not being changed 
						if(selectedPanel != buttonWhiteList[a][b]){ //If the currently selected map panel is not this button
							if(buttonWhiteList[a][b].currentFrame < 3 && buttonWhiteList[a][b].visible){ //If the frame of the button is less than 3 and it is visible
								if(buttonWhiteList[a][b].hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true) && (!editorBrowser.mapRenamePanel.visible || a == 2) && (!editorBrowser.mapDeletePanel.visible || a == 3) && (buttonWhiteList[a][b].currentFrame != 5 || a != 4 || b < 3) && (!Main.settingsMenu.resetSave.visible || a == 7) && (!subMenu || a != 0)){ //If the button is being hovered over and there is no ui above it
									if(!isHover[a][b]){ //If the button state is false
										isHover[a][b] = true; //Set the button state to true
										if((a != 7 || Main.settingsMenu.resetSave.visible) && (a != 2 || editorBrowser.mapRenamePanel.visible) && (a != 3 || editorBrowser.mapDeletePanel.visible) && (a != 4 || playBrowser.campaignScreen.visible) && (a != 5 || playBrowser.customScreen.visible) && buttonWhiteList[a][b] != Main.settingsMenu.sliderContainer.volumeButtonSFX){ //If the button should play a sound
											Main.PlaySound(ButtonHover); //The hover sound is played
										}
										
										if(a == 1 && b > 4){ //If the hovered button is a editor browser map panel
											editorBrowser.mapName.text = panelList[b - 5].mapName.text; //Update the map name header
											
											var editorMapStatList:Array = Main.saveFile.mapData[panelList[b - 5].mapName.text]; //Gets the map data
											if(editorMapStatList != null){ //If the map has data
												editorBrowser.mapInfo.text = "Fastest time: " + Main.CalculateTime(editorMapStatList[0]) + "\nTotal time: " + Main.CalculateTime(editorMapStatList[1]) + "\n\nLeast Moves: " + editorMapStatList[2] + "\nTotal Moves: " + editorMapStatList[3] + "\n\nTotal Solves: " + editorMapStatList[4]; //The data is put in the map description
											}else{ //Otherwise
												editorBrowser.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //Sets all map info to N/A
											}
										}else if(a == 4 && b > 2 && playBrowser.campaignScreen.visible){ //If the hovered button is a campaign panel
											playBrowser.campaignScreen.mapName.text = Main.campaign[b-3 + (15 * (mapListPage-1))]; //Update the map name header
											
											var campaignMapStatList:Array = Main.saveFile.campaignMapData[Main.campaign[b-3 + (15 * (mapListPage-1))]]; //Gets the map data
											if(campaignMapStatList != null){ //If the map has data
												playBrowser.campaignScreen.mapInfo.text = "Fastest time: " + Main.CalculateTime(campaignMapStatList[0]) + "\nTotal time: " + Main.CalculateTime(campaignMapStatList[1]) + "\n\nLeast Moves: " + campaignMapStatList[2] + "\nTotal Moves: " + campaignMapStatList[3] + "\n\nTotal Solves: " + campaignMapStatList[4]; //The data is put in the map description
											}else{ //Otherwise
												playBrowser.campaignScreen.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //Sets all map info to N/A
											}
										}else if(a == 5 && b > 2 && playBrowser.customScreen.visible){ //If the hovered button is a custom map panel
											var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); //Gets the custom map directory
											var files:Array = mapList.getDirectoryListing(); //Gets a list of all custom maps

											playBrowser.customScreen.mapName.text = Main.GetMapByFile(files[b-3 + (4 * (mapListPage-1))]).levelName; //Update the map name header
											
											var customMapStatList:Array = Main.saveFile.mapData[Main.GetMapByFile(files[b-3 + (4 * (mapListPage-1))]).levelName]; //Gets the map data
											if(customMapStatList != null){ //If the map has data
												playBrowser.customScreen.mapInfo.text = "Fastest time: " + Main.CalculateTime(customMapStatList[0]) + "\nTotal time: " + Main.CalculateTime(customMapStatList[1]) + "\n\nLeast Moves: " + customMapStatList[2] + "\nTotal Moves: " + customMapStatList[3] + "\n\nTotal Solves: " + customMapStatList[4]; //The data is put in the map description
											}else{ //Otherwise
												playBrowser.customScreen.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //Sets all map info to N/A
											}
										}else if(a == 9 && b > 0){
											Main.helpScreen.archivesScreen.blockName.text = BlockDatabase.nonVariantList[b-1][3];
											Main.helpScreen.archivesScreen.blockInfo.text = BlockDatabase.nonVariantList[b-1][6];
											Main.helpScreen.archivesScreen.selectedIcon.gotoAndStop(b);
										}
									}
									
									buttonWhiteList[a][b].gotoAndStop(2); //Changes the button frame to hovering
								}else{ //If the button is not being hovered over
									if(selectedMap != null){ //If there is a selected map
										var statList:Array = Main.saveFile.mapData[selectedMap.levelName]; //Get the map stats for the selected map
									}
									
									if(isHover[a][b]){ //If the hover state is true
										isHover[a][b] = false; //Make the hover state false
										
										if(a == 1 && b > 4){ //If the button is a editor browser map panel
											editorBrowser.mapName.text = selectedMap.levelName; //Update the map name and description

											if(statList != null){ //See above
												editorBrowser.mapInfo.text = "Fastest time: " + Main.CalculateTime(statList[0]) + "\nTotal time: " + Main.CalculateTime(statList[1]) + "\n\nLeast Moves: " + statList[2] + "\nTotal Moves: " + statList[3] + "\n\nTotal Solves: " + statList[4]; //See above
											}else{ //See above
												editorBrowser.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //See above
											}
										}else if(a == 4 && b > 2){ //If the button is a campaign level panel
											statList = Main.saveFile.campaignMapData[selectedMap.levelName]; //Get the map stats for the selected map
											playBrowser.campaignScreen.mapName.text = selectedMap.levelName; //Update the map name and description

											if(statList != null){ //See above
												playBrowser.campaignScreen.mapInfo.text = "Fastest time: " + Main.CalculateTime(statList[0]) + "\nTotal time: " + Main.CalculateTime(statList[1]) + "\n\nLeast Moves: " + statList[2] + "\nTotal Moves: " + statList[3] + "\n\nTotal Solves: " + statList[4]; //See above
											}else{ //See above
												playBrowser.campaignScreen.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //See above
											}
										}else if(a == 5 && b > 3 && playBrowser.customScreen.visible){ //If the button is a custom level panel
											playBrowser.customScreen.mapName.text = selectedMap.levelName; //Update the map name and description

											if(statList != null){ //See above
												playBrowser.customScreen.mapInfo.text = "Fastest time: " + Main.CalculateTime(statList[0]) + "\nTotal time: " + Main.CalculateTime(statList[1]) + "\n\nLeast Moves: " + statList[2] + "\nTotal Moves: " + statList[3] + "\n\nTotal Solves: " + statList[4]; //See above
											}else{ //See above
												playBrowser.customScreen.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //See above
											}
										}
									}
									
									buttonWhiteList[a][b].gotoAndStop(1); //Changes the button frame to not hovering
								}
							}else if(!buttonWhiteList[a][b].hitTestPoint(Main.stageRef.mouseX, Main.stageRef.mouseY, true) && (buttonWhiteList[a][b].currentFrame != 5 || a != 4 || b < 3)){ //If not hovering but the button frame is on clicked
								buttonWhiteList[a][b].gotoAndStop(1); //Changes the button frame to not hovering
							}
						}else{ //if the button is the selected map button
							buttonWhiteList[a][b].gotoAndStop(4); //Changes the button frame to pressed/selected
						}
					}
					
					if(levelButtons.indexOf(buttonWhiteList[a][b]) != -1 && playBrowser.campaignScreen.visible && playBrowser.currentFrame == 15 && buttonWhiteList[a][b].visible){ //If the button is a campaign button
						var index:Number = levelButtons.indexOf(buttonWhiteList[a][b]); //Gets the index of the button in the levelButtons array
						levelButtons[index].levelIcon.gotoAndStop(index + 1 + (15 * (mapListPage-1))); //Changes the button image to the correct campaign image
					}
				}
			}
		}

		private static function MouseDown(e:MouseEvent):void{ //Whenever the left mouse button goes from up to down
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //Loops through every button in buttonWhiteList
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //See above
					if(buttonWhiteList[a][b] == e.target && (!editorBrowser.mapRenamePanel.visible || a == 2) && (!editorBrowser.mapDeletePanel.visible || a == 3) && (buttonWhiteList[a][b].currentFrame != 5 || a != 4 || b < 3) && !changingBindings && !changingVolume && (!Main.settingsMenu.resetSave.visible || a == 7) && (a != 9|| b == 0)){ //If the target is this button and there is no ui above the button
						buttonWhiteList[a][b].gotoAndStop(3); //Changes the button frame to pressing
						if(a == 6 && b == 4){ //If the button is the volume slider
							ChangeVolume(); //Start changing the game volume
						}
					}
				}
			}
		}
		
		private static function MouseUp(e:MouseEvent):void{ //Whenever the left mouse button goes from down to up
			for(var a:Number = 0; a < buttonWhiteList.length; a++){ //Loops through every button in buttonWhiteList
				for(var b:Number = 0; b < buttonWhiteList[a].length; b++){ //See above
					if(buttonWhiteList[a][b] == e.target && (!editorBrowser.mapRenamePanel.visible || a == 2) && (!editorBrowser.mapDeletePanel.visible || a == 3) && (buttonWhiteList[a][b].currentFrame != 5 || a != 4 || b < 3) && e.target.currentFrame == 3 && (!Main.settingsMenu.resetSave.visible || a == 7)){ //If the target is this button and there is no ui above the button
						buttonWhiteList[a][b].gotoAndStop(2); //Changes the button frame to pressing
						var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); //Gets the custom map directory
						var files:Array = mapList.getDirectoryListing(); //Gets a list of all custom maps
						
						if(a == 1 && b > 4){ //If the pressed button is a map editor map panel
							if(selectedPanel != buttonWhiteList[a][b]){ //If the currently selected button is not this button
								Main.PlaySound(OptionButton); //Play a sound 
								
								selectedMap = Main.GetMapByFile(files[b - 5 + (4 * (mapListPage-1))]); //Change the selected map to the map that this button represents
								selectedPanel = buttonWhiteList[a][b]; //Sets the currently selected button to this one
							}
						}else if(a == 4 && b > 2){ //If the pressed button is a campaign level map panel
							if(selectedPanel != buttonWhiteList[a][b]){ //If the currently selected button is not this button
								Main.PlaySound(OptionButton); //Play a sound 
								
								selectedMap = Main.GetMap(Main.campaign[b-3 + (15 * (mapListPage-1))], "Campaign"); //Change the selected map to the map that this button represents
								selectedPanel = buttonWhiteList[a][b]; //Sets the currently selected button to this one
							}
						}else if(a == 5 && b > 2){ //If the pressed button is a custom level map panel
							if(selectedPanel != buttonWhiteList[a][b]){ //If the currently selected button is not this button
								Main.PlaySound(OptionButton); //Play a sound 
								
								selectedMap = Main.GetMapByFile(files[b-3 + (4 * (mapListPage-1))]); //Change the selected map to the map that this button represents
								selectedPanel = buttonWhiteList[a][b]; //Sets the currently selected button to this one
							}
						}else if(a != 6 || b != 4){ //If the button is not the volume slider
							buttonClickFunctions[a][b](); //Runs the corresponding button function
						}
					}
				}
			}
		}
		
		private static function KeyPressed(e:KeyboardEvent):void{ //Whenever a key is pressede
			if(e.keyCode == 27){ //If the key is ESC
				if(editorBrowser.mapRenamePanel.visible){ //If the rename panel is visible
					RenameMap(); //Toggle the rename panel
				}else if(editorBrowser.mapDeletePanel.visible){ //If the map delete panel is visible
					DeleteMapPanel(); //Toggle the map delete panel
				}else if(editorBrowser.currentFrame == 15){ //If the editor browser is currently on screen
					MapEditorBrowser(); //Toggle the map editor browser
				}else if(playBrowser.currentFrame == 15){ //If the map browser is currently on screen
					PlayMapBrowser(); //Toggle the map browser
				}else if(Main.settingsMenu.resetSave.visible){ //If the reset save panel is visible
					ResetSave(); //Toggle the reset save panel
				}else if(Main.settingsMenu.currentFrame == 15 && !changingBindings && !changingVolume){ //If the settings menu is currently on screen and neither the volume or keybinds are being changed
					SettingsMenu(); //Toggle the settingds menu
				}else if(Main.helpScreen.currentFrame == 15){
					HelpMenu();
				}
			}else if(e.keyCode == 13){ //If the key is ENTER
				if(editorBrowser.mapRenamePanel.visible){ //If the rename panel is visible
					ChangeName(); //Rename the map
				}
			}
		}
		
		private static function PlayGame():void{ //Plays a map
			var mapList:File = File.applicationDirectory.resolvePath("Custom Maps");  //Gets the custom map directory
			var files:Array = mapList.getDirectoryListing(); //Gets a list of custom maps
			
			if(files.length > 0 || playBrowser.campaignScreen.visible){ //If there is at least one custom map or the campaign screen is visible
				Main.PlaySound(UISelect); //Play a sound
				
				Main.loadingScreen.visible = true; //Makes the loading screen visible 
				var loadingTimer:Timer = new Timer(500, 0); //Makes timer with a delay of 500ms
				loadingTimer.start(); //Starts the timer
				loadingTimer.addEventListener(TimerEvent.TIMER, OpenMap); //Adds a TIMER listener 
				Main.stageRef.removeEventListener(Event.ENTER_FRAME, HoverChecker); //Removes all main menu listeners
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //See above
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, MouseUp); //See above
				Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_WHEEL, ChangePlayPage); //See above
				function OpenMap(e:TimerEvent){ //Runs after 500ms
					loadingTimer.removeEventListener(TimerEvent.TIMER, OpenMap); //See above
					
					Main.selectedMap = selectedMap.levelName; //Sets the Main class selected map to the local selected map
					if(playBrowser.campaignScreen.visible){ //If the campaign screen is visible
						LevelHandler.LoadMap(Main.selectedMap, "Campaign"); //Load a new map as a campaign level
					}else{ //Otherwise
						LevelHandler.LoadMap(Main.selectedMap, "Custom Maps"); //Loads a new map as a custom level
					}
				}
			}
		}
		
		private static function PlayMapBrowser():void{ //Toggles the map browser			
			if(playBrowser.currentFrame < 15){ //If the browser is not on screen
				subMenu = true; //subMenu is set to true
				Main.PlaySound(UIIn); //A sound is played
				CampaignMode(); //The browser is set to campaign mode
				Main.stageRef.addEventListener(MouseEvent.MOUSE_WHEEL, ChangePlayPage); //The page change listener is added
			}else{ //Otherwise, the browser is on screen
				subMenu = false; //subMenu is set to false
				Main.PlaySound(UIOut); //A sound is played
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_WHEEL, ChangePlayPage); //The page change listener is removed
			}
			playBrowser.play(); //The playBrowser clip plays
		}
		
		private static function CampaignMode():void{ //Sets the map browser to campaign mode
			if(playBrowser.currentFrame == 15){ //If this function is called while the panel is on screen
				Main.PlaySound(NormalButton); //Play a sound
			}
			
			mapListPage = 1; //Sets the map page to 1
			selectedMap = Main.GetMap(Main.campaign[0], "Campaign"); //Sets the selected map to the first campaign level
			selectedPanel = buttonWhiteList[4][3]; //Sets the selected panel to the first campaign level
			
			playBrowser.campaignScreen.visible = true; //Shows the campaign screen
			playBrowser.customScreen.visible = false; //Hides the custom screen
			
			UpdateCampaign(); //Updates the campaign screen
		}
		
		private static function CustomMode():void{ //Sets the map browser to custom mode
			Main.PlaySound(NormalButton); //Plays a sound
			
			var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); 
			var files:Array = mapList.getDirectoryListing();
			
			mapListPage = 1; //Sets the map page to 1
			if(files.length > 0){ //If there is at least 1 custom map
				selectedMap = Main.GetMapByFile(files[0]); //Sets the selected map to the first custom level
				selectedPanel = buttonWhiteList[5][3]; //Sets the selected panel to the first custom level
			}
			playBrowser.campaignScreen.visible = false; //Hides the campaign screen
			playBrowser.customScreen.visible = true; //Shows the custom screen
			
			UpdateCustom(); //Updates the custom screen
		}
		
		private static function UpdateCampaign():void{ //Updates the campaign screen
			for(var i:Number = 0; i < levelButtons.length; i++){ //Loops through all campaign levels
				if(Main.campaign[i + (15 * (mapListPage-1))] != null){ //If the map exists
					levelButtons[i].visible = true; //Show the button
					if(i != 0){ //If the campaign panel isn't the first one
						playBrowser.campaignScreen.campaignArrow.visible = true; //Show the campaign arrow
						playBrowser.campaignScreen.campaignArrow.gotoAndStop(i); //Set the campaign arrow to the current level
					}else{ //If the campaign panel is the first one
						playBrowser.campaignScreen.campaignArrow.visible = false; //Hide the campaign arrow
					}
					
					if(Main.saveFile.campaignData.length < i + (15 * (mapListPage-1))){ //If the previous level has not been beaten
						levelButtons[i].gotoAndStop(5); //Set the level icon to locked
					}else{ //If the previous level has been beaten
						levelButtons[i].gotoAndStop(1); //Set the level icon to unlocked
					}
				}else{ //If the map doesn't exist
					levelButtons[i].visible = false; //Hide the button
				}
			}
			
			if(Main.campaign.length > 15){ //If the campaign is longer than 15 levels long
				playBrowser.campaignScreen.pageNumber.text = "Page " + mapListPage; //Update the page text
				playBrowser.campaignScreen.pageNumber.visible = true; //Show the page text
			}else{
				playBrowser.campaignScreen.pageNumber.visible = false; //Hides the page text
			}
			
			playBrowser.campaignScreen.mapName.text = selectedMap.levelName; //Updates the map name text

			var statList:Array = Main.saveFile.campaignMapData[selectedMap.levelName]; //Gets the stats for the selected map
			if(statList != null){ //If the map has stats
				playBrowser.campaignScreen.mapInfo.text = "Fastest time: " + Main.CalculateTime(statList[0]) + "\nTotal time: " + Main.CalculateTime(statList[1]) + "\n\nLeast Moves: " + statList[2] + "\nTotal Moves: " + statList[3] + "\n\nTotal Solves: " + statList[4]; //Updates the map stats
			}else{ //Otherwise
				playBrowser.campaignScreen.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //Sets all map data to N/A
			}
		}
		
		private static function UpdateCustom():void{ //Updates the campaign screen
			const buttonList:Array = [playBrowser.customScreen.customMapOne, playBrowser.customScreen.customMapTwo, playBrowser.customScreen.customMapThree, playBrowser.customScreen.customMapFour]; //Declares and defines an array with the custom map panels
			var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); //Get the custom map directory
			var files:Array = mapList.getDirectoryListing(); //Get a list of all custom maps
			
			if(files.length == 0){ //If theres no maps
				playBrowser.customScreen.mapName.text = "NO MAPS"; //Update the map text to say that
				playBrowser.customScreen.mapInfo.text = "Create a map to view information about it."; //See above
			}
			
			for(var i:uint = 0; i < 4; i++){ //Loops through all custom map panels
				buttonList[i].visible = false; //Hides the panel
				if(files[i + (4 * (mapListPage-1))] != null){ //If the file exists
					buttonList[i].visible = true; //Shows the panel
					var map:Object = Main.GetMapByFile(files[i + (4 * (mapListPage-1))]); //Gets the map using the file
					buttonList[i].mapName.text = map.levelName; //Updates the panel map name accordingly
					buttonList[i].mapName.mouseEnabled = false; //See above
				}
			}
			
			if(files.length > 4){ //If there is more than 4 custom maps
				playBrowser.customScreen.pageNumber.text = "Page " + mapListPage; //Shows the page number and sets the text
				playBrowser.customScreen.pageNumber.visible = true; //See above
			}else{
				playBrowser.customScreen.pageNumber.visible = false; //Hides the page number
			}
			
			if(files.length > 0){ //If there is at least one custom map
				playBrowser.customScreen.mapName.text = selectedMap.levelName; //The map name is updated to the selected map
				
				var statList:Array = Main.saveFile.mapData[selectedMap.levelName]; //Gets the map stats
				if(statList != null){ //If the map has stats
					playBrowser.customScreen.mapInfo.text = "Fastest time: " + Main.CalculateTime(statList[0]) + "\nTotal time: " + Main.CalculateTime(statList[1]) + "\n\nLeast Moves: " + statList[2] + "\nTotal Moves: " + statList[3] + "\n\nTotal Solves: " + statList[4]; //Sets the map description to the map stats
				}else{ //Otherwise
					playBrowser.customScreen.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //Sets the map description to N/A
				}
			}
		}
		
		private static function ChangePlayPage(e:MouseEvent):void{ //Runs when the middle mouse wheel is scrolled
			var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); //Gets the custom map directory
			var files:Array = mapList.getDirectoryListing(); //Gets all custom maps
			
			if(Main.campaign.length > 15 && playBrowser.campaignScreen.visible){ //If the campaign screen is visible and there is more than 15 levels
				if(e.delta < 0 && mapListPage < Math.ceil(Main.campaign.length / 15)){ //If the player scrolls down and can increase the page
					mapListPage ++; //Increases the page
					selectedMap = Main.GetMap(Main.campaign[(mapListPage-1) * 15], "Campaign"); //Sets the new selected map
					selectedPanel = buttonWhiteList[4][3]; //Sets the new selected panel
					UpdateCampaign(); //Updates the campaign info
					
					Main.PlaySound(PageChange); //Plays a sound
				}else if(e.delta > 0 && mapListPage != 1){ //If the player scrolls up and can decrease the page
					mapListPage --; //Decreases the page
					selectedMap = Main.GetMap(Main.campaign[(mapListPage-1) * 15], "Campaign"); //Sets the new selected map
					selectedPanel = buttonWhiteList[4][3]; //Sets the new selected panel
					UpdateCampaign(); //Updates the campaign info
					
					Main.PlaySound(PageChange); //Plays a sound
				}
			}else if(files.length > 4 && playBrowser.customScreen.visible){ //If theres more than 4 custom maps and the custom screen is visible
				if(e.delta < 0 && mapListPage < Math.ceil(files.length / 4)){ //If the player scrolls down and can increase the page
					mapListPage ++; //Increases the page
					selectedMap = Main.GetMapByFile(files[(mapListPage-1) * 4]); //Sets the new selected map
					selectedPanel = buttonWhiteList[5][3]; //Sets the new selected panel
					UpdateCustom(); //Updates the custom info
					
					Main.PlaySound(PageChange); //Plays a sound
				}else if(e.delta > 0 && mapListPage != 1){ //If the player scrolls up and can decrease the page
					mapListPage --; //Decreases the page
					selectedMap = Main.GetMapByFile(files[(mapListPage-1) * 4]); //Sets the new selected map
					selectedPanel = buttonWhiteList[5][3]; //Sets the new selected panel
					UpdateCustom(); //Updates the custom info
					
					Main.PlaySound(PageChange); //Plays a sound
				}
			}
		}
		
		private static function MapEditorBrowser():void{ //Toggles the map editor browser
			if(editorBrowser.currentFrame < 15){ //If the browser is not currently on screen
				Main.PlaySound(UIIn); //Plays a sound
				subMenu = true; //Sets subMenu to true
				
				mapListPage = 1; //Sets the map list page to 1
				var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); //Gets the custom map directory
				var files:Array = mapList.getDirectoryListing(); //Gets a list of all custom maps
				if(files.length > 0){ //If theres at least 1 map
					selectedMap = Main.GetMapByFile(files[0]); //The selected map is set to the first one
					selectedPanel = panelList[0]; //The selected panel is set to the first one
				}
				UpdateMapBrowser(); //Updates the map browser
				
				Main.stageRef.addEventListener(MouseEvent.MOUSE_WHEEL, ChangeEditorPage); //Adds a MOUSE_WHEEL listener to change the map page
			}else{
				subMenu = false; //Sets subMenu to false
				Main.PlaySound(UIOut); //Plays a sound
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_WHEEL, ChangeEditorPage); //Removes the MOUSE_WHEEL listener
			}
			
			editorBrowser.play(); //Plays the editorBrowser movieclip
		}
		
		private static function ChangeEditorPage(e:MouseEvent):void{ //Runs when the mouse wheel is scrolled
			var mapList:File = File.applicationDirectory.resolvePath("Custom Maps");  //Gets the custom map directory
			var files:Array = mapList.getDirectoryListing(); //Gets all custom maps
			if(files.length > 4 && !editorBrowser.mapRenamePanel.visible && !editorBrowser.mapRenamePanel.visible){ //If theres more than 4 maps and theres no other ui visible
				if(e.delta < 0 && mapListPage < (Math.ceil(files.length / 4))){ //If the player scrolls down and can increase the page
					mapListPage ++; //Increases the page
					selectedMap = Main.GetMapByFile(files[0 + ((mapListPage-1) * 4)]); //Sets the new selected map
					selectedPanel = panelList[0]; //Sets the new selected panel
					UpdateMapBrowser(); //Updates the map browser
					 
					Main.PlaySound(PageChange); //Plays a sound
				}else if(e.delta > 0 && mapListPage != 1){ //If the player scrolls up and can decrease the page
					mapListPage --; //Decreases the page
					selectedMap = Main.GetMapByFile(files[0 + ((mapListPage-1) * 4)]); //Sets the new selected map
					selectedPanel = panelList[0]; //Sets the new selected panel
					UpdateMapBrowser(); //Updates the map browser
					
					Main.PlaySound(PageChange); //Plays a sound
				}
			}
		}
		
		private static function RenameMap():void{ //Toggles the rename map panel
			if(!editorBrowser.mapRenamePanel.visible){ //If the panel is not visible
				if(newMapCreation){ //If a new map is being created
					Main.PlaySound(NormalButton); //Plays a sound
					
					Main.stageRef.focus = editorBrowser.mapRenamePanel.mapNameChanger; //Sets the focus to the input text
					editorBrowser.mapRenamePanel.mapNameChanger.text = ""; //Resets the input text
					editorBrowser.mapRenamePanel.visible = true; //Shows the input text
				}else if(panelList[0].visible){ //Else, if at least one map exists
					Main.PlaySound(NormalButton); //Plays a sound
					
					Main.stageRef.focus = editorBrowser.mapRenamePanel.mapNameChanger; //Sets the focus to the input text
					editorBrowser.mapRenamePanel.mapNameChanger.text = editorBrowser.mapName.text; //Sets the input text to the current map name
					editorBrowser.mapRenamePanel.visible = true; //Shows the inpput rexr
				}
			}else{ //If the panel is visible
				if(newMapCreation){ //If a new map is being created
					Main.PlaySound(UIBack); //Plays a sound
					
					newMapCreation = false; //A new map is no longer being created
					editorBrowser.mapRenamePanel.visible = false; //Hides the panel
				}else if(panelList[0].visible){ //If at least one map exists
					Main.PlaySound(UIBack); //Plays a sound
					
					editorBrowser.mapRenamePanel.visible = false; //Hides the panel
				}
			}
		}
		
		private static function ChangeName():void{ //Confirms setting/changing the map name 
			var dir:File = new File(File.applicationDirectory.nativePath).resolvePath("Custom Maps"); //Gets the custom map directory
			var newFileDir:File = dir.resolvePath(editorBrowser.mapRenamePanel.mapNameChanger.text + ".data"); //Gets the new file directory
			const characterWhitelist:String = "abcdefghijklmonpqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"; //Gets the allowed characters
			var isAlphanumeric:Boolean = true; //Declares the isAlphanumeric variable, to check if the inputted name is valid
			
			for(var i:Number = 0; i <editorBrowser.mapRenamePanel.mapNameChanger.length; i++){ //Loops through the inputted string
				if(characterWhitelist.indexOf(editorBrowser.mapRenamePanel.mapNameChanger.text.charAt(i)) == -1){ //If any character in the string is not valid
					isAlphanumeric = false; //isAlphamumeric is set to false
					break; //The loop is stopped
				}
			}
			
			if(!isAlphanumeric){ //If the string is not alphanumeric
				Main.PlaySound(ErrorAudio); //Plays a sound
				editorBrowser.mapRenamePanel.renameWarning.mouseEnabled = false; //Shows and updates the error text
				editorBrowser.mapRenamePanel.renameWarning.warningText.text = "Map name has to be alphanumeric."; //See above
				editorBrowser.mapRenamePanel.renameWarning.gotoAndPlay(1); //See above
			}else if(editorBrowser.mapRenamePanel.mapNameChanger.length == 0){ //If the inputted text is empty		
				Main.PlaySound(ErrorAudio); //Plays a sound
				editorBrowser.mapRenamePanel.renameWarning.mouseEnabled = false; //Shows and updates the error text
				editorBrowser.mapRenamePanel.renameWarning.warningText.text = "Map name cannot be empty."; //See above
				editorBrowser.mapRenamePanel.renameWarning.gotoAndPlay(1); //See above
			}else if(newFileDir.exists){ //If the inputted name is already in use
				Main.PlaySound(ErrorAudio); //Plays a sound
				editorBrowser.mapRenamePanel.renameWarning.mouseEnabled = false; //Shows and upadtes the error text
				editorBrowser.mapRenamePanel.renameWarning.warningText.text = "Map name in use."; //See above
				editorBrowser.mapRenamePanel.renameWarning.gotoAndPlay(1); //See above
			}else{ //If the name is valid
				Main.PlaySound(UISelect); //Plays a sound
				
				var saveFile:Object; //Declares a saveFile variable
				
				if(newMapCreation){ //If a new map is being made
					newMapCreation = false; //A new map is no longer being made
					saveFile = { //Creates a new empty save file for the map
						levelName: editorBrowser.mapRenamePanel.mapNameChanger.text, //See above
						tileData: [[0, 1, 1], [0, 2, 1]], //See above
						blockData: [[0, 1, 1], [2, 2, 1]] //See above
					}
					Main.SaveMap(saveFile); //Saves the map
					
					var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); //Gets the custom map directory
					var files:Array = mapList.getDirectoryListing(); //Gets a list of all maps
					selectedMap = saveFile; //Sets the selected map to the newly created map
					Main.selectedMap = selectedMap.levelName; //Sets the Main selected map to the local selected map
					
					Main.loadingScreen.visible = true; //Shows the loading screen
					var loadingTimer:Timer = new Timer(500, 0); //Creates a new timer with a delay of 500ms
					loadingTimer.start(); //Starts the timer
					loadingTimer.addEventListener(TimerEvent.TIMER, OpenMap); //Adds a TIMER listener, which will run after 500ms
					Main.stageRef.removeEventListener(Event.ENTER_FRAME, HoverChecker); //Removes all main menu listeners
					Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //See above
					Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, MouseUp); //See above
					Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
					Main.stageRef.removeEventListener(MouseEvent.MOUSE_WHEEL, ChangeEditorPage); //See above
					function OpenMap(e:TimerEvent){ 
						loadingTimer.removeEventListener(TimerEvent.TIMER, OpenMap); //Removes all the main menu listeners
						MapEditor.EditMap(Main.selectedMap); //Starts running the map editor code
					}
				}else{ //If a new map is not being made
					Main.PlaySound(UISelect); //Plays a sound
					
					var file:File = dir.resolvePath(editorBrowser.mapName.text + ".data"); //Gets the old file
					file.moveTo(newFileDir, true); //Moves the old file to the new location
					
					saveFile = Main.GetMap(editorBrowser.mapRenamePanel.mapNameChanger.text, "Custom Maps"); //Sets the saveFile to the new map
					saveFile.levelName = editorBrowser.mapRenamePanel.mapNameChanger.text; //Updates the saveFile map name
					Main.SaveMap(saveFile); //Saves the map with it's new name
					
					if(selectedMap.levelName == editorBrowser.mapName.text){ //If the map is selected
						selectedMap = saveFile; //Updates the selectedMap variable
					}
				}
				
				UpdateMapBrowser(); //Updates the map browser
				editorBrowser.mapRenamePanel.visible = false; //Hides the map rename panel
			}
		}
		
		private static function DeleteMap():void{ //Deletes a map
			Main.PlaySound(UISelect); //Plays a sound
			
			var dir:File = new File(File.applicationDirectory.nativePath).resolvePath("Custom Maps"); //Gets the custom map directory
			var file:File = dir.resolvePath(editorBrowser.mapName.text + ".data"); //Gets the map file
			file.deleteFile(); //Deletes the file
				
			var files:Array = dir.getDirectoryListing(); //Gets all custom maps
			if(files[(mapListPage-1) * 4] == null && files.length > 0){ //If there is no maps on the current page anymore
				mapListPage --; //Decreases the map page
				selectedMap = Main.GetMapByFile(files[0 + ((mapListPage-1) * 4)]); //Sets the new selected map
				selectedPanel = panelList[0]; //Sets the new selected panel
				UpdateMapBrowser(); //Updates the map browser
			}else if(files.length > 0){ //If there is at least 1 file
				selectedMap = Main.GetMapByFile(files[0 + ((mapListPage-1) * 4)]); //Sets the new selected map
				selectedPanel = panelList[0]; //Sets the new selected panel
			}
			
			editorBrowser.mapDeletePanel.visible = false; //Hides the map delete panel
			UpdateMapBrowser(); //Updates the map browser
		}
		
		private static function DeleteMapPanel():void{ //Toggles the map delete panel
			if(panelList[0].visible){ //If there is at least one map
				if(!editorBrowser.mapDeletePanel.visible){ //If the delete panel isn't visible
					Main.PlaySound(NormalButton); //Plays a sound
					
					editorBrowser.mapDeletePanel.deleteText.text = "Delete " + editorBrowser.mapName.text + "?"; //Shows and updates the delete text
					editorBrowser.mapDeletePanel.visible = true; //See above
				}else{ //If the delete panel is visible
					Main.PlaySound(UIBack); //Plays a sound
					
					editorBrowser.mapDeletePanel.visible = false; //Hides the delete panel
				}
			}
		}
		
		private static function UpdateMapBrowser():void{ //Updates the map editor browser
			var mapList:File = File.applicationDirectory.resolvePath("Custom Maps"); //Gets the custom map directory
			var files:Array = mapList.getDirectoryListing(); //Gets all custom maps
			if(files.length < 5){ //if there are less than 5 maps
				editorBrowser.pageNumber.visible = false; //Hides the page number
			}else{ //If there are 5 or more maps
				if(files[(mapListPage-1) * 4] == null){ //If there is no maps on the page
					mapListPage --; //Decrease the map page 
				}
				editorBrowser.pageNumber.visible = true; //Show and update the map number
				editorBrowser.pageNumber.text = "PAGE " + mapListPage; //See above
			}
			
			if(files.length == 0){ //If there are no maps
				editorBrowser.mapName.text = "NO MAPS"; //Shows the map text as such
				editorBrowser.mapInfo.text = "Create a map to view information about it."; //See above
			}
			
			for(var i:uint = 0; i < 4; i++){ //Loops through all custom panels
				panelList[i].visible = false; //Hides the panel
				if(files[i + (4 * (mapListPage-1))] != null){ //If the file exists
					panelList[i].visible = true; //Shows the panel
					var map:Object = Main.GetMapByFile(files[i + (4 * (mapListPage-1))]); //Gets the map from the file
					panelList[i].mapName.text = map.levelName; //Shows and updates the map name text for the panel
					panelList[i].mapName.mouseEnabled = false; //See above
				}
			}
			
			if(files.length > 0){ //If there is at least one file
				editorBrowser.mapName.text = selectedMap.levelName; //Sets the map name to the selected map's name
				
				var statList:Array = Main.saveFile.mapData[selectedMap.levelName]; //Gets the map stats
				if(statList != null){ //If the map has stats
					editorBrowser.mapInfo.text = "Fastest time: " + Main.CalculateTime(statList[0]) + "\nTotal time: " + Main.CalculateTime(statList[1]) + "\n\nLeast Moves: " + statList[2] + "\nTotal Moves: " + statList[3] + "\n\nTotal Solves: " + statList[4]; //Updates the map description with the stats
				}else{ //Otherwise
					editorBrowser.mapInfo.text = "Fastest time: N/A \nTotal time: N/A \n\nLeast Moves: N/A \nTotal Moves: N/A \n\nTotal Solves: N/A"; //Updates the map description with N/A
				}
			}
		}
		
		private static function NewMap():void{ //Creates a new map
			Main.PlaySound(NormalButton); //Plays a sound
			
			newMapCreation = true; //newMapCreation becomes true
			RenameMap(); //RenameMap runs to set the map name
		}
		
		private static function EditMap():void{ //Enters the editor
			if(panelList[0].visible){ //If there is at least one map
				Main.PlaySound(UISelect); //Plays a sound
				
				Main.loadingScreen.visible = true; //Shows the loading screen
				var loadingTimer:Timer = new Timer(500, 0); //Makes a new timer with a delay of 500ms
				loadingTimer.start(); //Starts the timer
				loadingTimer.addEventListener(TimerEvent.TIMER, OpenMap); //Adds a TIMER listener than will run in 500ms
				Main.stageRef.removeEventListener(Event.ENTER_FRAME, HoverChecker); //Removes all main menu listeners
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown); //See above
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, MouseUp); //See above
				Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, KeyPressed); //See above
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_WHEEL, ChangeEditorPage); //See above
				function OpenMap(e:TimerEvent){ 
					loadingTimer.removeEventListener(TimerEvent.TIMER, OpenMap); //See above
					Main.selectedMap = editorBrowser.mapName.text; //Sets the selected map 
					MapEditor.EditMap(Main.selectedMap); //Opens the map editor
				}
			}
		}
		
		private static function SettingsMenu():void{ //Toggles the settings menu
			if(Main.settingsMenu.currentFrame < 15){ //If the menu is not on screen
				subMenu = true; //subMenu is set to true
				Main.PlaySound(UIIn); //Plays a sound
			}else{
				subMenu = false; //subMenu is set to false
				Main.PlaySound(UIOut); //Plays a sound
				changingBindings = false; //Settings related boolean are reset
				changingVolume = false; //See above
			}
			
			Main.settingsMenu.play(); //Plays the settingsMenu movieclip
		}
		
		private static function ChangeUp():void{ //Changes the up key bind
			Main.PlaySound(NormalButton); //Plays a sound
			Main.settingsMenu.keyBindOne.gotoAndStop(4); //Sets the key bind button to pressed
			changingBindings = true; //Sets changingBindings to true
			Main.settingsMenu.changeKeyPanel.visible = true; //The change key panel is shown
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //A listener is added to check for keyboard inputs
			function ChangeBind(e:KeyboardEvent){
				if(e.keyCode == 27){ //If the key pressed is ESC
					Main.PlaySound(OptionButton); //Plays a sound
					Main.settingsMenu.keyBindOne.gotoAndStop(2); //Resets the key bind button 
					
					changingBindings = false; //Sets changingBindings to false
					Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
					Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
				}else{ 
					const characterWhitelist:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"; //Declares and defines the accepted characters
					if(characterWhitelist.indexOf(String.fromCharCode(e.keyCode)) != -1){ //If the selected key is accepted
						Main.PlaySound(OptionButton); //Plays a sound
						Main.saveFile.upKey = e.keyCode; //Sets the up key to the pressed key
						Main.SaveData(); //Saves the game data
						
						Main.settingsMenu.keyBindOne.bindText.text = "UP: " + String.fromCharCode(Main.upKey); //Updates the key bind text
						Main.settingsMenu.keyBindOne.bindText.mouseEnabled = false; //See above
						Main.settingsMenu.keyBindOne.gotoAndStop(2); //See above
						
						changingBindings = false; //Sets changingBindings to false
						Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
						Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
					}else{
						Main.PlaySound(ErrorAudio); //Plays a sound
					}
				}
			}
		}
		
		private static function ChangeDown():void{ //Changes the down key bind
			Main.PlaySound(NormalButton); //Plays a sound
			Main.settingsMenu.keyBindTwo.gotoAndStop(4); //Sets the key bind button to pressed
			changingBindings = true; //Sets changingBindings to true
			Main.settingsMenu.changeKeyPanel.visible = true; //The change key panel is shown
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //A listener is added to check for keyboard inputs
			function ChangeBind(e:KeyboardEvent){
				if(e.keyCode == 27){ //If the key pressed is ESC
					Main.PlaySound(OptionButton); //Plays a sound
					Main.settingsMenu.keyBindTwo.gotoAndStop(2); //Resets the key bind button 
					
					changingBindings = false; //Sets changingBindings to false
					Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
					Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
				}else{ 
					const characterWhitelist:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"; //Declares and defines the accepted characters
					if(characterWhitelist.indexOf(String.fromCharCode(e.keyCode)) != -1){ //If the selected key is accepted
						Main.PlaySound(OptionButton); //Plays a sound
						Main.saveFile.downKey = e.keyCode; //Sets the down key to the pressed key
						Main.SaveData(); //Saves the game data
						
						Main.settingsMenu.keyBindTwo.bindText.text = "DOWN: " + String.fromCharCode(Main.downKey); //Updates the key bind text
						Main.settingsMenu.keyBindTwo.bindText.mouseEnabled = false; //See above
						Main.settingsMenu.keyBindTwo.gotoAndStop(2); //See above
						
						changingBindings = false; //Sets changingBindings to false
						Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
						Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
					}else{
						Main.PlaySound(ErrorAudio); //Plays a sound
					}
				}
			}
		}
		
		private static function ChangeRight():void{ //Changes the right key bind
			Main.PlaySound(NormalButton); //Plays a sound
			Main.settingsMenu.keyBindThree.gotoAndStop(4); //Sets the key bind button to pressed
			changingBindings = true; //Sets changingBindings to true
			Main.settingsMenu.changeKeyPanel.visible = true; //The change key panel is shown
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //A listener is added to check for keyboard inputs
			function ChangeBind(e:KeyboardEvent){
				if(e.keyCode == 27){ //If the key pressed is ESC
					Main.PlaySound(OptionButton); //Plays a sound
					Main.settingsMenu.keyBindThree.gotoAndStop(2); //Resets the key bind button 
					
					changingBindings = false; //Sets changingBindings to false
					Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
					Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
				}else{ 
					const characterWhitelist:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"; //Declares and defines the accepted characters
					if(characterWhitelist.indexOf(String.fromCharCode(e.keyCode)) != -1){ //If the selected key is accepted
						Main.PlaySound(OptionButton); //Plays a sound
						Main.saveFile.rightKey = e.keyCode; //Sets the right key to the pressed key
						Main.SaveData(); //Saves the game data
						
						Main.settingsMenu.keyBindThree.bindText.text = "DOWN: " + String.fromCharCode(Main.rightKey); //Updates the key bind text
						Main.settingsMenu.keyBindThree.bindText.mouseEnabled = false; //See above
						Main.settingsMenu.keyBindThree.gotoAndStop(2); //See above
						
						changingBindings = false; //Sets changingBindings to false
						Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
						Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
					}else{
						Main.PlaySound(ErrorAudio); //Plays a sound
					}
				}
			}
		}	
		
		private static function ChangeLeft():void{ //Changes the right key bind
			Main.PlaySound(NormalButton); //Plays a sound
			Main.settingsMenu.keyBindFour.gotoAndStop(4); //Sets the key bind button to pressed
			changingBindings = true; //Sets changingBindings to true
			Main.settingsMenu.changeKeyPanel.visible = true; //The change key panel is shown
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //A listener is added to check for keyboard inputs
			function ChangeBind(e:KeyboardEvent){
				if(e.keyCode == 27){ //If the key pressed is ESC
					Main.PlaySound(OptionButton); //Plays a sound
					Main.settingsMenu.keyBindFour.gotoAndStop(2); //Resets the key bind button 
					
					changingBindings = false; //Sets changingBindings to false
					Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
					Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
				}else{ 
					const characterWhitelist:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"; //Declares and defines the accepted characters
					if(characterWhitelist.indexOf(String.fromCharCode(e.keyCode)) != -1){ //If the selected key is accepted
						Main.PlaySound(OptionButton); //Plays a sound
						Main.saveFile.leftKey = e.keyCode; //Sets the left key to the pressed key
						Main.SaveData(); //Saves the game data
						
						Main.settingsMenu.keyBindFour.bindText.text = "DOWN: " + String.fromCharCode(Main.leftKey); //Updates the key bind text
						Main.settingsMenu.keyBindFour.bindText.mouseEnabled = false; //See above
						Main.settingsMenu.keyBindFour.gotoAndStop(2); //See above
						
						changingBindings = false; //Sets changingBindings to false
						Main.settingsMenu.changeKeyPanel.visible = false; //Hides the change key panel
						Main.stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, ChangeBind); //Removes the KEY_DOWN listener
					}else{
						Main.PlaySound(ErrorAudio); //Plays a sound
					}
				}
			}
		}
		
		private static function ChangeVolume():void{ //Changes the game volume
			Main.PlaySound(OptionButton); //Plays a sound
			changingVolume = true; //Sets changingVolume to false
			Main.stageRef.addEventListener(Event.ENTER_FRAME, ChooseVolume); //Adds an ENTER_FRAME listener to update the volume
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, StopVolume); //Adds a MOUSE_UP listener to stop changing the volume
			function ChooseVolume(e:Event){
				if(Main.settingsMenu.sliderContainer.mouseX - Main.settingsMenu.sliderContainer.volumeButtonSFX.width/2 > 0){ //If the mouse X is out of bounds the slider won't follow
					Main.settingsMenu.sliderContainer.volumeButtonSFX.x = 0; //See above
				}else if(Main.settingsMenu.sliderContainer.mouseX - Main.settingsMenu.sliderContainer.volumeButtonSFX.width/2 < -502.25){ //See above
					Main.settingsMenu.sliderContainer.volumeButtonSFX.x = -502.25; //See above
				}else{ 
					Main.settingsMenu.sliderContainer.volumeButtonSFX.x = Main.settingsMenu.sliderContainer.mouseX - Main.settingsMenu.sliderContainer.volumeButtonSFX.width/2; //The slider X changes relative to the mouse X
				}
				
				Main.saveFile.gameVolume = 1 - (Main.settingsMenu.sliderContainer.volumeButtonSFX.x / -502.25); //The game volume is updated
				Main.SaveData(); //The game data is saved

				Main.settingsMenu.volumeText.text = String(Math.ceil(Main.gameVolume.volume * 100)) + "%"; //The volume text is updated
			}
			function StopVolume(e:MouseEvent){
				Main.PlaySound(Block); //Plays a sound
				Main.SaveData(); //Saves the volume
				changingVolume = false; //Sets changingVolume to false
				Main.stageRef.removeEventListener(Event.ENTER_FRAME, ChooseVolume); //Removes the volume change listeners
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, StopVolume); //See above
			}
			
		}
		
		private static function ResetSave():void{ //Toggles the reset panel
			if(!Main.settingsMenu.resetSave.visible){ //If the panel is not visible
				Main.PlaySound(NormalButton); //Plays a sound
				Main.settingsMenu.resetSave.visible = true; //Shows the panel
			}else{
				Main.PlaySound(OptionButton); //Plays a sound
				Main.settingsMenu.resetSave.visible = false; //Hides the panel
			}
		}
		
		private static function ResetData():void{ //Resets the game data
			ResetSave(); //Toggles the reset panel
			Main.saveFile = { //Sets the save file to an blank save file
				campaignData:[], //See above
				mapData:new Dictionary(), //See above
				campaignMapData:new Dictionary(), //See above 
				gameVolume: 1, //See above
				upKey: 87, //See above
				downKey: 83, //See above
				rightKey: 68, //See above
				leftKey: 65 //See above
			}			
			Main.SaveData(); //Saves the data
			
			Main.settingsMenu.keyBindOne.bindText.text = "UP: " + String.fromCharCode(Main.upKey); //Updates all settings data
			Main.settingsMenu.keyBindTwo.bindText.text = "DOWN: " + String.fromCharCode(Main.downKey); //See above
			Main.settingsMenu.keyBindThree.bindText.text = "RIGHT: " + String.fromCharCode(Main.rightKey); //See above
			Main.settingsMenu.keyBindFour.bindText.text = "LEFT: " + String.fromCharCode(Main.leftKey); //See above
			Main.settingsMenu.volumeText.text = String(Math.ceil(Main.gameVolume.volume * 100)) + "%"; //See above
			Main.settingsMenu.sliderContainer.volumeButtonSFX.x = (1 - Main.gameVolume.volume) * - 502.25; //See above
		}
		
		private static function HelpMenu():void{ //Opens the help menu
			if(Main.helpScreen.currentFrame < 15){ //See above
				subMenu = true; //See above 
				Main.PlaySound(UIIn); //See above
				GuideScreen(); //See above 
			}else{ 
				subMenu = false; //See above 
				Main.PlaySound(UIOut); //See above 
			}
			Main.helpScreen.play(); //See above
		}
		
		private static function GuideScreen():void{ //Opens the guide section of the help menu
			if(Main.helpScreen.currentFrame == 15){ //See above
				Main.PlaySound(NormalButton); //See above 
			}
			
			BackGuide(); //See above
			
			Main.helpScreen.archivesScreen.visible = false; //See above
			Main.helpScreen.guideScreen.visible = true; //See above
		}
		
		private static function BackGuide():void{ //Goes to the first page of the guide
			Main.helpScreen.guideScreen.nextPage.visible = true; //See above
			Main.helpScreen.guideScreen.backPage.visible = false; //See above
			Main.helpScreen.guideScreen.createGuide.visible = false; //See above
			Main.helpScreen.guideScreen.playGuide.visible = true; //See above
			Main.helpScreen.guideScreen.pageNumber.text = "PAGE 1"; //See above
		}
		
		private static function NextGuide():void{ //Goes to the second page of the guide
			Main.helpScreen.guideScreen.nextPage.visible = false; //See above
			Main.helpScreen.guideScreen.backPage.visible = true; //See above
			Main.helpScreen.guideScreen.createGuide.visible = true; //See above
			Main.helpScreen.guideScreen.playGuide.visible = false; //See above
			Main.helpScreen.guideScreen.pageNumber.text = "PAGE 2"; //See above
		}
		
		private static function ArchivesScreen():void{ //Goes the archives section of the help menu
			if(Main.helpScreen.currentFrame == 15){ //See above
				Main.PlaySound(NormalButton); //See above
			}
			
			Main.helpScreen.archivesScreen.visible = true; //See above
			Main.helpScreen.guideScreen.visible = false; //See above
			
			Main.helpScreen.archivesScreen.blockName.text = BlockDatabase.nonVariantList[0][3]; //See above
			Main.helpScreen.archivesScreen.blockInfo.text = BlockDatabase.nonVariantList[0][6]; //See above
			Main.helpScreen.archivesScreen.selectedIcon.gotoAndStop(1); //See above
		}
		
		private static function QuitGame():void{ //Closes the AIR application
			Main.PlaySound(UISelect); //Plays a sound
			NativeApplication.nativeApplication.exit(); //Exits
		}

	}	
}