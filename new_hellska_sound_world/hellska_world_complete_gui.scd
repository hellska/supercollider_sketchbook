( // complete GUI for Ice Pick Performance
// setto i due buffer di base - i buffer sono variabili globali perchè si possono aggiungere mentre si suona
~berlin = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/berlin/*");
~industrial = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/*");
// play
SynthDef(\play, {| outBus = 0, bufnum, start = 0, loop = 0, panpot = 0, attack = 0.003, decay = 0.003, time = 0.1 |
	var source, out;
	source = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), 1, start, loop, doneAction:2) *
	EnvGen.kr(Env.linen(attack, time, decay));
	out = Pan2.ar(source, panpot);
    Out.ar(outBus, out)
}).send(s);
SynthDef(\playLoop, {| outBus = 0, bufnum, start = 0, loop = 0, panpot = 0 |
	var source, out, env, envdur;
	envdur = 0.5;
	env = Env.asr(attackTime:0.02,sustainLevel:1,releaseTime:envdur,curve:\lin);
	source = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), 1, start, loop, doneAction:2) *
	EnvGen.ar(env);
	out = Pan2.ar(source,panpot);
    Out.ar(outBus, out)
}).send(s);
// used in pattern - should substitute \playLoop
SynthDef(\sampleplayer, { |out, bufnum, start, time, amp, seqgate|
    var sig = PlayBuf.ar(1, bufnum, startPos: start, loop: 0),
        env = EnvGen.kr(Env.linen(0.01, time, 0.05, level: amp), doneAction: 2);
    Out.ar(out, (sig * env * seqgate) ! 2)
}).add;
// crea la visualizzazione del campionatore
~x3d_sampler_view = {|xpos, ypos, parent, buffColl|
	var mainWin,
	channel_setup, sample_loop, bpm2sec, bpm_btn, bpm_number, pname,
	stepProxy, sequence_steps, step_seq_view, step_sequencer, step_sequencer_btn,
 	x3d_loops_view, x3d_loops_killall, xloops, yloops, x3d_loop_number, x3d_loop_buttons_array, play_array, play_array_buffers, play_array_element,
	x3d_files_view, playBuff, samplerLabel, samplerFileList, xsize, ysize, yposRelative, localBuff, fileListSelector, x3d_updateSoundFile, x3d_fileView;

	xsize = 600;
	ysize = 600;
	yposRelative = 0;
	if (xpos>0, { xpos.postln }, { xpos = 0 });
	if (ypos>0, { ypos.postln }, { ypos = 0 });

	if (parent == "",
		{
			"qui".postln;
			mainWin = Window("sampler").setTopLeftBounds(Rect(xpos,ypos,xsize,ysize)).front;
		}, {
			mainWin = parent;
	});

	// SINCRONIZZAZIONE PATTERNS
	~tempo = TempoClock.default;
	~quant = 1; // whole beat
	~time = 0;



	channel_setup = 2;
	sample_loop = 0;
	play_array_element = 0;

	x3d_loop_number = 25; // the maximum loop number

	// step sequencer
	// pattern - drum machine - setup
	sequence_steps = 16;
	bpm2sec = 60 / 60 ;
	stepProxy = PatternProxy(Pseq(Array.fill(sequence_steps, bpm2sec), inf));

	~looplength = bpm2sec * sequence_steps;

	step_seq_view = CompositeView(mainWin, Rect(0, 305, 680, 680)).background_(Color.red);
	bpm_btn = Button(mainWin, Rect(685, 305, 40, 30))
	.states_([["BPM", Color.black]])
	.action_{|me|
		bpm2sec = 60 / bpm_number.value ;
		stepProxy.source = PatternProxy(Pseq(Array.fill(sequence_steps, bpm2sec), inf));
		bpm2sec.postln;
		~looplength = bpm2sec * sequence_steps;
	};
	bpm_number = NumberBox(mainWin, Rect(730, 305, 40, 30));
	//step_sequencer = Array.newClear(sequence_steps);
	// patterns_array = Array.new(25, sequence_steps);
	step_sequencer_btn = Array.newClear(x3d_loop_number);

	// matrice di valori delle sequenze
	~step_sequencer_values = Array2D.fromArray(x3d_loop_number, sequence_steps, Array.fill(sequence_steps * x3d_loop_number, 0));
	~step_sequencer_proxies = Array.fill(x3d_loop_number, { PatternProxy.new(Array.fill(sequence_steps, 0)) } );
	~step_sequencer_seqs = Array.fill(x3d_loop_number, {|idx| Pseq(~step_sequencer_values.rowAt(idx)) });

	// crea la matrice di bottoni dello step sequencer che controlla la matrice di valori delle sequenze di patterno
	x3d_loop_number.do{|rowid|
		var ypos, starty, sequence_btn;
		sequence_btn = Array.newClear(sequence_steps);
		ypos = rowid%x3d_loop_number;
		starty = (ypos * 20) + (ypos * 5) + 5;
		("y "+ypos++"x: "+starty).postln;
		sequence_steps.do{|id|
			var xpos, startx;
			xpos = id%sequence_steps;
			startx = (xpos * 20) + (xpos * 5) + 5;

			sequence_btn.put(id,
				Button(step_seq_view, Rect(startx, starty, 20, 20))
				.states_([["|",Color.black,Color.yellow],["|",Color.black,Color.black]])
				.action_{|me|
					// "setta_la_sequenza".postln; ("RIGA: "+rowid).postln; ("COLONNA: "+id).postln;
					~step_sequencer_values.put(rowid,id,me.value);
					// ~step_sequencer_values.rowAt(rowid).postln;
					// ~step_sequencer_proxies.put(id, ~step_sequencer_values.rowAt(rowid)); // rowid and id sono uguali - refactor per unificare la variabile
					// ~step_sequencer_proxies[rowid].source = Pseq(~step_sequencer_values.rowAt(rowid), inf);
					~step_sequencer_seqs[rowid] = Pseq(~step_sequencer_values.rowAt(rowid));

				};
			)
		};
		step_sequencer_btn.put(rowid, sequence_btn);
	};

	// loops matrix

	xloops = (5 * (5+1)) + (40 * 5);
	yloops = (5 * (5+1)) + (40 * (5+1));
	//("MATRIX SIZE - x: "+xloops+" y: "+yloops).postln;
	x3d_loop_number = 25; // the maximum loop number
	x3d_loop_buttons_array = Array.fill(x3d_loop_number,0);

	// ("MATRIX SIZE - x: "+xloops+" y: "+yloops).postln;
	x3d_loop_buttons_array = Array.fill(x3d_loop_number,0);

	// array dei loop - contiene synthdefs
	pname = ["un", "du", "tr", "qu", "ci", "se" ,"se" ,"ot" ,"no", "di", "un", "do", "tr", \n, \o, \p, \q, \r, \s, \t, \u, \v, \w, \x, \y, \z];
	play_array = Array.newClear(x3d_loop_number);

	// array dei buffers - risolve il problema del cambio di cartella
	play_array_buffers = Array.newClear(x3d_loop_number);
	// COMPOSITE VIEW SET POSITION RELATIVE TO OTHER ELEMENTS
	x3d_loops_view = CompositeView(mainWin, Rect(5,22,xloops,yloops)).background_(Color.blue); // shifted a bit anche l'occhio ;)

	x3d_loop_number.do{|id|
		var row, col, xstart, ystart;
		col = (id%5);
		row = (id/5).asInt;
		xstart = (col * (40+ 5)) + 5;
		ystart = (row * (40+ 5)) + 5;
		// ("Col:"+col+"Row:"+row+"X:"+xstart+"Y:"+ystart).postln;
		x3d_loop_buttons_array.put(id,
			Button(x3d_loops_view,Rect(xstart,ystart,40,40))
			.states_([[id.asString],[id.asString,Color.black,Color.green],[id.asString,Color.black,Color.blue]])
			.action_{|me|
				case
				{me.value==0} {play_array[id].stop; play_array[id].free; }
				{me.value==1} {
					var timeProxy = PatternProxy(playBuff.duration),
					buffProxy = PatternProxy(playBuff);
					//// "Aggiungo un pattern".postln;
					if (~time==0,
						{
							("Creo il pattern master "+pname[id]).postln;
							~time = ~quant.nextTimeOnGrid(~tempo);
							play_array[id] = Pbindef(pname[id], \instrument, \sampleplayer,
								\bufnum, playBuff,
								\start, 0,
								\amp, 0.2,
								\seqgate, Pn( Plazy { ~step_sequencer_seqs[id] }),
								\time, timeProxy,
								\dur, stepProxy
							);
							play_array[id].play(quant: ~quant);
						}, { //// aggiungo un pattern in sinc col primo avviato
							var timesync;
							timesync.postln;
							~tempo.nextTimeOnGrid(16,0).postln;
							("Aggiungo un pattern slave "+pname[id]).postln;
							timesync = (~tempo.beats - ~time).roundUp(~looplength) + ~time;
							play_array[id] = Pbindef(pname[id], \instrument, \sampleplayer,
								\bufnum, playBuff,
								\start, 0,
								\amp, 0.2,
								\seqgate, Pn( Plazy { ~step_sequencer_seqs[id] }),
								\time, timeProxy,
								\dur, stepProxy
							).play(quant: timesync - ~tempo.baseBarBeat);
							//play_array[id].play(quant: timesync - ~tempo.baseBarBeat);
							/*
							play_array[id] = Pbind(\instrument, \sampleplayer,
								\bufnum, playBuff,
								\start, 0,
								\amp, 0.2,
								// \seqgate, ~step_sequencer_proxies[id],
								\seqgate, Pfunc { Pseq(~step_sequencer_values.rowAt(id),inf) },
								\time, timeProxy,
								\dur, stepProxy
							).play(quant: timesync - ~tempo.baseBarBeat);
							*/
						}
					);
					play_array_element = play_array_element + 1;
				};
			};
		);
	};
	x3d_loops_killall = Button(x3d_loops_view, Rect(5,yloops - 40,xloops-(5*2),40))
	.states_([[" K I L L   A L L   L O O P S "]])
	.action_{|me| x3d_loop_number.do{|el|
		play_array[el].stop;
		play_array[el].free;
		{ x3d_loop_buttons_array[el].value_(0) }.defer;
		};
		play_array_element = 0;
		~time = 0;
	};

	// S A M P L E R   F I L E S

	~play = {|buffer, startPos, time, loop|
		if (channel_setup==2){
			if (loop==1) { // behaviour when loop is set
				if (play_array_element<x3d_loop_number) {
					//play_array.put(play_array_element,
					//	Synth.new(\playLoop, [\bufnum, buffer, \start, startPos, \panpot, ~panpot, \outBus, ~sampleOut, \loop, ~loop],~sampleGroup, addAction: \addToHead));
					play_array.put(play_array_element,Synth.new(\playLoop, [\bufnum, buffer, \start, startPos, \panpot, 0, \outBus, 0, \loop, loop]));
					{ x3d_loop_buttons_array[play_array_element].value_(2); play_array_element = play_array_element + 1; }.defer;
					"added new element".postln;
				} {
					"No other loop permitted!".postln;
				};
			} { // behaviour when loop is switched off
				//Synth.new(\play, [\bufnum, buffer, \start, startPos, \panpot, ~panpot, \outBus, ~sampleOut, \loop, ~loop, \time, time],~sampleGroup, addAction: \addToHead);
				Synth.new(\play, [\bufnum, buffer, \start, startPos, \panpot, 0, \outBus, 0, \time, time]);
			};
		};
		if (channel_setup==4){
			Synth.new(\play4, [\bufnum, buffer, \start, startPos, \xpos, ~panpot, \ypos, ~panpotY, \outBus, ~sampleOut,\loop, ~loop, \time, time],~sampleGroup, addAction: \addToHead);
		}
	};
	// internal function -- TESTING

	x3d_updateSoundFile = {|filePath|
		var soundfile;
		"INTERNAL FUNCTION".postln;
		soundfile = SoundFile.new;
		soundfile.openRead(filePath);
		x3d_fileView.soundfile = soundfile;            // set soundfile
		x3d_fileView.read(0, soundfile.numFrames);     // read in the entire file.
		x3d_fileView.refresh;                  // refresh to display the file.
		x3d_fileView.timeCursorPosition_(soundfile.numFrames/2);
		soundfile.close;
	};

	//x3d_updateSoundFile.value("ciccio");

	////////////////////////////////
	// creo il buffer con i suoni di default pe rpopolare la lista, la file view e suonare
	if (buffColl == "", { localBuff = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/Industrial-autoprodotti/*"); }, { localBuff = buffColl });
	samplerFileList = Array.new(localBuff.size);
	localBuff.do({|item, idx| samplerFileList.add(localBuff[idx].path); });

	// G U I
	// creo la finestra interna per rendere indipendente la visualizzazione
	x3d_files_view = CompositeView(mainWin, Rect(xpos, ypos, xsize, 300));
	// label della finestra di visualizzazione
	samplerLabel = StaticText(x3d_files_view, Rect(0, yposRelative, xsize / 2, 22))
	.string_("Lista dei campioni caricati in memoria");


	// popup list - stessa y position
	fileListSelector = PopUpMenu(x3d_files_view, Rect(xsize / 2, yposRelative, xsize / 2, 22))
	.items_([ "industrial", "berlin", "loops"])
	.action_({|me|
		me.value.postln;
		switch (me.value,
			0, {
				var list = Array.fill(~industrial.size, {arg idx; ~industrial[idx].path});
				samplerFileList.items_(list);
				localBuff = ~industrial;
				x3d_updateSoundFile.value(localBuff[0].path);
			},
			1, {
				var list = Array.fill(~berlin.size, {arg idx; ~berlin[idx].path});
				samplerFileList.items_(list);
				localBuff = ~berlin;
				x3d_updateSoundFile.value(localBuff[0].path);
			},
			2, { // dynamic - reload buffer every time
				var list, sf = SoundFile.collect("/home/hellska/soundAndSamples/samples/loops/*");
				~loops = SoundFile.collectIntoBuffers("/home/hellska/soundAndSamples/samples/loops/*");
				list = Array.fill(sf.size, {arg idx; sf[idx].path});
				samplerFileList.items_(list);
				localBuff = ~loops;
				x3d_updateSoundFile.value(sf[0].path);
			};

		);
	});

	// ricalcolo la posizione relativa
	yposRelative = yposRelative + 22;

	// sampler File List
	samplerFileList = ListView(x3d_files_view,Rect(0,yposRelative,xsize,100))
	.items_( samplerFileList )
	.background_(Color.white)
	.hiliteColor_(Color.green(alpha:0.6))
	.action_({ arg sbs;
		~currentSampleNo = 0;
		playBuff = localBuff[samplerFileList.value]; // need global variable for buffer to play playBuff ???
		x3d_updateSoundFile.value(localBuff[sbs.value].path.standardizePath);
	}).keyDownAction_({|i, char, uni, key|
		key.postln;
		if ( key == 13 ) { localBuff[samplerFileList.value].play; };
		if ( key == 108 ) { ~play.value(playBuff, 0, playBuff.duration, 1) };
	});

	// ricalcolo la posizione relativa
	yposRelative = yposRelative + 100;

	// file viewer
	x3d_fileView = SoundFileView(x3d_files_view, Rect(0,yposRelative,xsize,178))
	.timeCursorOn_(true)
	.timeCursorColor_(Color.red);
	// imposto il contenuto
	x3d_updateSoundFile.value(localBuff[0].path);

};


// new gui implementation
~makeIcePickGui = {
	var screen, screenx, screeny;
	// imposta la finestra sulla dimensione dello schermo
	screen = Window.screenBounds;
	screenx = screen.width;
	screeny = screen.height;
	~mainWin = Window.new("HELLSKA Sound World", Rect(0, 0, screenx, screeny), true, true, s, true).front;
	//~x3d_loops_matrix_creator.value(~mainWin, 0, 0); // MATRIX SIZE - x:  230  y:  270
	~x3d_sampler_view.value(240, 0, ~mainWin, "");
};
)
~makeIcePickGui.value();