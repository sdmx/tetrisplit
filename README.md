# TetriSplit
LiveSplit AutoSplitter for Tetris for the Nintendo Enterainment System

* [LiveSplit](http://livesplit.github.io/) - Here you can find out more about and download LiveSplit. It is a popular timer program typically used for speedruns.
* [ASL](https://github.com/LiveSplit/LiveSplit/blob/master/Documentation/Auto-Splitters.md) - Here you can find more information about ASL (basically C#) and autosplitters in general.

**Supported emulators:**

 * FCEUX 2.2.3

**Future Support Planned For:**

 * Nestopia 1.40+
 * BizHawk/NESHawk 2.3.1+
 
## Features

**Split by Lines**

 * Split every time the line count passes a 10s marker (10, 20, 30, etc). Designed for the **100 Lines** and **100 Lines, 0 Start** Categories.

**Start Enable**

* Automatically start a run as soon as Game Mode A level selection is made.

**Reset Enable**

* Kills a run on any game mode that isn't a currently running game. 
	* *Note: High Score, Ending and Pause screens all count as a current running game. This functionality is intentional, as an automatic reset does not allow you to save Gold Splits, if LiveSplit is configured to ask you if you want to save them.*

## Installation

* Go to "Edit Splits.." in LiveSplit
* Enter "Tetris (NES)" in the "Game Name" field. 
  * *Note: This must be entered correctly so Livesplit can load the correct component. You'll know you've got it right when the Description reads "TetriSplit"* 
* Click the "Activate" button to download and enable the Autosplitter
  * *Note: If you ever want to stop using TetriSplit, just click "Deactivate"*
  
## Set-up

* Go to "Edit Splits..." in LiveSplit
* Click "Settings" to enable the options you're interested in using.
  * *Note: If for some reason LiveSplit does not automatically load the script, click "Browse...", navigate to your Livesplit installation folder and and select the appropriate script from the "Components" folder.*

## Project Thanks

* The hardworking people at [Data Crystal](https://datacrystal.romhacking.net/wiki/Tetris_(NES):RAM_map) for providing the resources that made this project, and many like it, possible.
* [MeatFighter](https://meatfighter.com/nintendotetrisai) for their wonderful article on applying AI to Tetris

## Contact

If you find any bugs or would like to propose improvements, please feel free to reach out! 

* Look for SDMX on [Twitch](http://twitch.tv/sdmx) or [Twitter](https://twitter.com/sdmx) or leave me a message here!
