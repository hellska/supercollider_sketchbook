//// sequencer
(
//// Global Variables
~sequencer_timestep = 0.5;
~sequencer_rnd = 0;
~sequencer_rows = 8;
~sequencer_cols = 32;
~seq_pattern_size = 32;

//// pattern and preset save
~defdir = "~/SCseqpatterns/";
~data = "date +\"%Y%m%d\"".unixCmdGetStdOut.as(Array).join;
~defsongdir = ~data[..7];
~currentpatternumber = 1;
~defdir = "~/SCseqpatterns/"++~defsongdir++"/";

//// G U I
~create_sequencer_gui = {
	~sequencer_window = Window("Simple Sequencer").setTopLeftBounds(Rect(0,0,600,420)).front;
	~sequencer_grid = BoxGrid(~sequencer_window,Rect(10,10,580,100),~sequencer_cols,~sequencer_rows);
	~sequencer_pos_grid = BoxGrid(~sequencer_window,Rect(10,115,580,15),~sequencer_cols,1)
	.setBackgrColor_(Color.red);
	~sequencer_cols.do{|idx| ~sequencer_pos_grid.setBoxColor_(idx,0,Color.new255(255,234,0,180)) };
	~sequencer_play_btn = Button(~sequencer_window,Rect(10,140,20,20))
	.states_([[">",Color.black,Color.white],[">",Color.black,Color.green]])
	.action_{|me| case {me.value==0} {~seq_player.stop} {me.value==1}{~seq_player.play}; };
	~sequencer_length_box = NumberBox(~sequencer_window,Rect(35,140,25,20))
	.value_(32).clipLo_(1).clipHi_(~sequencer_cols).maxDecimals_(0)
	.action_{|me| ~seq_pattern_size=me.value};
	~sequencer_save_pattern_btn = Button(~sequencer_window,Rect(70,140,80,20))
	.states_([["Save Pattern",Color.black,Color.gray]])
	.action_{|me| ~sequencer_pattern_save.value(~seqPatNameSave.value,~sequencer_grid.getNodeStates,~defdir) };
	~seqPatNameSave = TextField(~sequencer_window,Rect(160,140,100,20)).string_("pattern_1");
	~sequencer_pattern_load_btn = Button(~sequencer_window,Rect(270,140,80,20))
	.states_([["Load Pattern",Color.black,Color.gray]])
	.action_{|me| ~sequencer_pattern_load.value(~seqPatNameLoad.string,~sequencer_grid,~defdir) };

	// load patterns file into this object
	~seqPatNameLoad = TextView(~sequencer_window,Rect(360,140,150,20)).string_("pattern_1.txt");



	~seqoverwritepattern = Button(~sequencer_window,Rect(70,165,80,20))
	.states_([["non overwrite",Color.black,Color.gray],["Overwrite",Color.black,Color.green]]);

	// status bar at bottom of main window
	~seqstatusbar = StaticText(~sequencer_window,Rect(0,400,600,20)).string_("Sequencer Started")
	.align_(\right).backColor_(Color.black).stringColor_(Color.green);
};
//// F U N C T I O N S
~sequencer_reader = {|seqgrid,seqviwe,steps|
	var step,rows,cols,cycle;
	rows = seqgrid.getNodeStates.size;
	cols = seqgrid.getNodeStates[0].size;
	if(cols>steps) { cycle=steps } {cycle=cols};
	cycle.do{|i|
		var gridvalues,instruments;

		//// check if the pattern has reached the specified size (default 32)
		instruments = List[];
		if (~sequencer_rnd==nil){~sequencer_rnd=0};
		// use global variables to change values without recall the function
		step = ~sequencer_timestep + rand(~sequencer_rnd);
		// show the current step
		seqviwe.gridNodes[0][i].setState_(true);
		if (i>0) { seqviwe.gridNodes[0][i-1].setState_(false) };
		//if (i==0) { seqviwe.gridNodes[0][cycle-1].setState_(false) };
		seqviwe.refresh;
		// ~readcol.value(i+1);
		gridvalues = Array2D.fromArray(~sequencer_rows,~sequencer_cols,~sequencer_grid.getNodeStates.flat);
		gridvalues.colAt(i).do{|val,idx| if (val==1){ instruments.add(idx) } };
		if (instruments.size>0) {
			// play instruments HERE
			instruments.do{|instr,indx|
				~seq_instrument_player.value(instr)
			}
		};
		// wait
		step.wait;
		if (i==(cycle-1)){ seqviwe.gridNodes[0][i].setState_(false) };
	}
};

~seq_instrument_player = {|instr|
	if (~thisinstr1==nil) {~thisinstr1 = "instr1"};
	case
	{instr==0}{ Synth(~thisinstr1) }
	{instr==1}{ Synth(~thisinstr1,[\car_freq,80]) }
	{instr==2}{ Synth(~thisinstr1,[\car_freq,120]) }
	{instr==3}{ Synth(~thisinstr1,[\car_freq,230]) }
	{instr==4}{ Synth(~thisinstr1,[\car_freq,340]) }
	{instr==5}{ Synth(~thisinstr1,[\car_freq,450]) }
	{instr==6}{ Synth(~thisinstr1,[\car_freq,560]) }
	{instr==7}{ Synth(~thisinstr1,[\car_freq,670]) };
};
//// Create song directory
~createsongdir = {|dir|
	var filename = dir;
	if (File.exists(filename.standardizePath))
	{ ~seqstatusbar.string_("Directory already exists! Specify a different name") }
	{ File.mkdir(dir.standardizePath) }
};


//// save current pattern into a file to disk
~sequencer_pattern_save = {|name,pattern,dir = "~/"|
	var filename = dir++name++".txt";
	if (~seqoverwritepattern.value==0) {
		if (File.exists(filename.standardizePath))
		{ ~seqstatusbar.string_("File already exists! Specify a different name") }
		{ pattern.writeArchive(filename.standardizePath);
			~seqstatusbar.string_("File "++filename++" Saved!") };
	} {
		pattern.writeArchive(filename.standardizePath);
		~seqstatusbar.string_("File "++filename++" Saved!");
	}
};
~sequencer_pattern_load = {|name,patternDest,dir = "~/"|
	var pattern, filename;
	filename = dir++name;
	if (File.exists(filename.standardizePath))
	{ pattern = Object.readArchive(filename.standardizePath);
		patternDest.setNodeStates_(pattern);
		~seqstatusbar.string_("Pattern "++filename++" loaded");
	} { ~seqstatusbar.string_("File "++filename++" does not exists") };
};

//// S Y N T H S
//// The FM Synthesis
SynthDef("instr1", { |
	car_freq = 80,
	mod_ratio = 2.2,
	mod_index = 10.8,
	amp = 0.4,
	pos = 0|
    var fm = SinOsc.ar(car_freq + (SinOsc.ar(car_freq*mod_ratio) * mod_index));
	var env = EnvGen.kr(Env.linen(level:amp), doneAction: 2);
//	var env = EnvGen.kr(Env.perc(level:amp),doneAction:2);
	var out = fm * env;
	Out.ar(0, Pan2.ar(out,pos));
}).add;
//// The FM Synthesis GUI

//// the robot that read the sequencer
~seq_player = Task{
	loop{
		~sequencer_reader.value(~sequencer_grid,~sequencer_pos_grid,~seq_pattern_size);
	}
};
)
//// play around with sequencer
~create_sequencer_gui.value();
~createsongdir.value(~defdir);

File.mkdir(~defdir.standardizePath);


~player.play;
~player.stop;
~seq_player.reset;
~sequencer_rnd = 0.01;
~sequencer_timestep = 0.5;
~seq_pattern_size = 3;


~reset_seq_player.start;
~reset_seq_player.stop;
~this_col = 0;