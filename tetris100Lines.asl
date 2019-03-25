state("FCEUX", "2.2.3")
{
    // base address = Unknown
	byte linecount : 0x3B1388, 0x50;
	byte levelcount : 0x3B1388, 0x64; 
}

split
{
	//Split on every 10 Lines
	if(settings["linecount"] && (current.linecoun t% 10 > old.linecount % 10))
		return(true);
	if(settings["levelcount"] && old.levelcount != current.levelcount)
		return(true);		
}

// start
// {
// 	return settings["start"] && old.start1 == 0 && current.start1 == 255 && old.start2 == 0 && current.start2 == 255;
// }

startup
{
	settings.Add("linecount", true, "Number of Lines");
	settings.SetToolTip("linecount", "Split by every 10 Lines");
	settings.Add("levelcount", true, "Split by Levels");
	settings.SetToolTip("levelcount", "Split every new level");
	settings.Add("start", true, "Start Enable");
	settings.SetToolTip("start", "Enable start button to start timer from New Game start");
	
	Action<string> DebugOutput = (text) => {
		print("[NES Tetis Autosplitter] "+text);
	};
	vars.DebugOutput = DebugOutput;
}
