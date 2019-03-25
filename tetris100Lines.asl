state("fceux")
{
    // base address = Unknown
	byte linecount : 0x000000, 0x0050;
}

split
{
	return (settings["linecount"]);
}

start
{
	return settings["start"] && old.start1 == 0 && current.start1 == 255 && old.start2 == 0 && current.start2 == 255;
}

startup
{
	settings.Add("linecount", true, "");
	settings.SetToolTip("lines", "Split on number of lines");
	settings.Add("start", false, "Start Enable");
	settings.SetToolTip("start", "Enable start button to start timer from menu screen");
	
	Action<string> DebugOutput = (text) => {
		print("[NES Tetis Autosplitter] "+text);
	};
	vars.DebugOutput = DebugOutput;
}
