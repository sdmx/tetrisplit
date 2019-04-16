state("FCEUX", "2.2.3")
{
    // base address = 0x3B1388
	byte lineCount01 : 0x3B1388, 0x50;
	byte lineCount02 : 0x3B1388, 0x51;
	byte levelCount : 0x3B1388, 0x0064;
	byte score01 : 0x3B1388, 0x0053;
	byte score02 : 0x3B1388, 0x0054;
	byte score03 : 0x3B1388, 0x0055; 
	byte gameMode : 0x3B1388, 0x00C0;
	byte gameOver :0x3B1388, 0x0400;

	//byte gameStatus : 0x3B1388, 0x0001F0;
}

state("nestopia")
{
    // base address = 0x1b2bcc, 0, 8, 0xc, 0xc, 0x68;
	byte lineCount01 : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xB8;	// 0x50;
	byte lineCount02 : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xB9; 	// 0x51;
	byte levelCount : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xCC;  	// 0x0064;
	byte score01 : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xBB; 		// 0x0053;
	byte score02 : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xBC; 		// 0x0054;
	byte score03 : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0xBD;		// 0x0055; 
	byte gameMode : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x128; 	// 0x00C0;
	byte gameOver : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x468; 	// 0x0400;

	//byte gameStatus : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x258; 	// 0x0001F0;

}

init
{
	vars.Score = new Dictionary<byte, bool>();
		vars.Score.Add(1, false);
		vars.Score.Add(2, false);
		vars.Score.Add(3, false);
	refreshRate = 60;
}

split
{
	// Split on every 100 Lines. We're only looking at the integer in lineCount02, as that's the hundreds column.
	if(settings["CountBy100Lines"] && ((current.lineCount02 != old.lineCount02) && (current.lineCount02 == 1 ))){
		return(true);
	}

	// Split on every 10 Lines. Given the values are stored in literal HEX, we must take the modulus of 16 for each DEC value. We also split on the linecount02 populated with a 1, which indicates the hundreds colums of lines. To be clear, we're only tracking the 100 Lines category here.
	if(settings["CountBy10Lines"] && ((current.lineCount01%16) < (old.lineCount01%16) && (current.lineCount01 != 0 )) || ((current.lineCount02 == 1  ) && (current.lineCount02 < 16 ) && (current.score01 != 0))){
		return(true);
	}

	// Split on each new level. Given levels increment in single values, we can be confident this split can only occur when the levelCount value is incremented.
	if(settings["CountByLevels"] && (old.levelCount < current.levelCount) && (old.levelCount != current.levelCount)){
		return(true);
	}

	//Split on every 300K Points. Since the score is stored in a bigendian fashion, score03 is the 30 in 300,000. So we just need to monitor when score03 passes 48. 	 
	if( settings["scoreAttack300K"] && (current.score03 >= 48) && ( current.score03 != old.score03 )) {
		return(true);
	}


	//Split on every 300K Points. Since the score is stored in a bigendian fashion, score03 is the 30 in 300,000. So we just need to monitor when score03 passes 48. 	 
	if( settings["scoreAttack100K"]) {
		if (current.score03 >= 16 && vars.Score[1] == false) {
			vars.Score[1] = true;
			return(true);
		}
		else if (current.score03 >= 32 && vars.Score[2] == false){
			vars.Score[2] = true;
			return(true);
		}
		else if (current.score03 >= 48 && vars.Score[3] == false){
			vars.Score[3] = true;
			return(true);
		}
	}
}

start
{
	// Start run when values for score and lines are 0 and the game mode is 4, indicating a game in play.
	if(settings["start"] && (current.lineCount01 == 0) && (current.score01 == 0) && (current.score02 == 0) && (current.gameMode == 4)){
		return(true);
	}
}

reset
{
	// Reset on a game mode that is not gameplay. Big ups to MeatFighter for publishing game mode values.
	if(settings["reset"] && ( current.gameMode == 1 ) || (current.gameMode == 2 ) ||  (current.gameMode == 3 ) || (current.gameMode == 5 )){
		return(true);
	}
}

startup
{
	settings.Add("SplitByLines", true, "Split by Number of Lines");
	settings.SetToolTip("SplitByLines", "by Number of Lines");
	settings.Add("CountBy100Lines", true, "100 Lines", "SplitByLines");
	settings.SetToolTip("CountBy100Lines", "Split on or after 100 Lines.");
	settings.Add("CountBy10Lines", false, "10 Lines", "SplitByLines");
	settings.SetToolTip("CountBy10Lines", "Split after every 10 Line Marker (10, 20, etc) up to 100 Lines.");

	settings.Add("scoreAttack", true, "Split by Points");
	settings.SetToolTip("scoreAttack", "Split by Points");
	settings.Add("scoreAttack300K", true, "Split by 300K", "scoreAttack");
	settings.SetToolTip("scoreAttack300K", "Split on or after 300,000 Points");
	settings.Add("scoreAttack100K", false, "Split by 100K", "scoreAttack");
	settings.SetToolTip("scoreAttack100K", "Split every 100,000 Points **EXPERIMENTAL**");


	settings.Add("CountByLevels", false, "Split by Levels");
	settings.SetToolTip("CountByLevels", "Split every new level");

	settings.Add("start", false, "Start Enable");
	settings.SetToolTip("start", "Enable to start timer from Level Selection");
	settings.Add("reset", false, "Reset Enable");
	settings.SetToolTip("start", "Resets Timer on any screen but an active game. **EXPERIMENTAL**");
	
	Action<string> DebugOutput = (text) => {
		print("[NES Tetis Autosplitter] "+text);
	};
	vars.DebugOutput = DebugOutput;
}
