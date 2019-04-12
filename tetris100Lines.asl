state("FCEUX", "2.2.3")
{
    // base address = Unknown
	byte lineCount01 : 0x3B1388, 0x50;
	byte lineCount02 : 0x3B1388, 0x51;
	byte levelCount : 0x3B1388, 0x0064;
	byte score01 : 0x3B1388, 0x0053;
	byte score02 : 0x3B1388, 0x0054;
	byte score03 : 0x3B1388, 0x0055; 
	// current.score01+current.score02+current.score03
	byte gameMode : 0x3B1388, 0x00C0;
	byte gameStatus : 0x3B1388, 0x0001F0;
	byte gameOver :0x3B1388, 0x0400;
}

split
{

	// Split on every 10 Lines. Given the values are stored in literal HEX, we must take the modulus of 16 for each DEC value. We also split on the linecount02 populated with a 1, which indicates the hundreds colums of lines. To be clear, we're only tracking the 100 Lines category here.
	if(settings["CountByLines"] && ((current.lineCount01%16) < (old.lineCount01%16) && (current.lineCount01 != 0 )) || ((current.lineCount02 == 1  ) && (current.lineCount02 < 16 ) && (current.score01 != 0)))
		return(true);

	// Split on each new level. Given levels increment in single values, we can be confident this split can only occur when the levelCount value is incremented.
	if(settings["CountByLevels"] && (old.levelCount < current.levelCount) && (old.levelCount != current.levelCount))
		return(true);

	// Split on every 50K Points.
	//if(settings["scoreAttack"] && (current.score != 0 ) && (current.score % 16 < old.score ) && (old.score != current.score))
	//	return(true);
}

start
{
	// Start run when values for score and lines are 0 and the game mode is 4, indicating a game in play.
	if(settings["start"] && (current.lineCount01 == 0) && (current.score01 == 0) && (current.score02 == 0) && (current.gameMode == 4))
		return(true);
}

reset
{
	// Reset on a game mode that is not gameplay. Big ups to MeatFighter for publishing game mode values.
	if(settings["reset"] && ( current.gameMode == 1 ) || (current.gameMode == 2 ) ||  (current.gameMode == 3 ) || (current.gameMode == 5 ))
		return(true);
}

startup
{
	settings.Add("CountByLines", true, "Number of Lines");
	settings.SetToolTip("CountByLines", "Split by every 10 Lines");
	settings.Add("CountByLevels", false, "Split by Levels");
	settings.SetToolTip("CountByLevels", "Split every new level");
	//settings.Add("scoreAttack", true, "100K Score");
	//settings.SetToolTip("scoreAttack", "Split every 100K Score");
	settings.Add("start", true, "Start Enable");
	settings.SetToolTip("start", "Enable start button to start timer from New Game start");
	settings.Add("reset", false, "Reset Enable");
	settings.SetToolTip("start", "Resets Timer on Game Over **EXPERIMENTAL**");
	
	Action<string> DebugOutput = (text) => {
		print("[NES Tetis Autosplitter] "+text);
	};
	vars.DebugOutput = DebugOutput;
}
