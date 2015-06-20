// Generatore di Grani
(
~ss_mindur = 50; // minimum duation of a single grain
~ss_deltadur = 200; // add to ~ss_mindur to calculate mad grain duration
~bsfreq = 40.midicps; // fundamental freq of the serie 82~ Hz
~timestep = 0.03; // sequencer's single step length
~rnd = 0.03; // randomic component of tempo (addeed to step length)
~freqserie = 0; // Define the default series type (0=armonic serie)
~ss_carestart = 0; // set if the CA restart when reach a quiet state (oscillatory states does not
~gridside = 18;

// Improvements
// Implement an instrument that create complex spectrum with n.do({ SinOsc ecc... })

SynthDef(\singlegrain, {
	|outbus = 0,
	freq = 440,
	length = 50, // ms range(50,250)
	amp = 0.8|
	var dur, env, grain;
	dur = 1 / 1000 * length;
	env = EnvGen.kr(Env([0, 1, 0], [dur/2, dur/2], \sine),doneAction:2); //Gaussian-shaped
	grain = SinOsc.ar([freq,freq],mul:amp) * env;
	Out.ar(outbus, grain)
}).send(s);
// draw GUI
~soundseed_w = Window.new("Sound Seed", Rect(10, 500, 600, 350)).front;
~cagrid = BoxGrid.new(~soundseed_w,bounds:Rect(20, 20, 300, 300),columns:~gridside,rows:~gridside);
~caplay = Button(~soundseed_w,Rect(350,20,30,30));
~carestart = Button(~soundseed_w,Rect(400,20,90,30));
~carandConfig = Button(~soundseed_w,Rect(350,70,60,30));
~carandConfigSized = Button(~soundseed_w,Rect(420,70,60,30));
~carandConfigSizedNbox = NumberBox(~soundseed_w,Rect(490,70,30,30));
~grainfreqserie = Button(~soundseed_w,Rect(350,120,180,30));
~seriebasefreq = NumberBox(~soundseed_w,Rect(550,120,40,30));
~cageneration = Button(~soundseed_w,Rect(350,170,40,30));

// behaviour definition
~caplay
.states_([
	[">",Color.black,Color.gray],
	[">",Color.black,Color.green]])
.action_({|me|
	if (me.value==1){
		~tas.play
	} {
		~tas.stop
}});
~carestart
.states_([
	["Single",Color.black,Color.gray],
	["Continuous",Color.black,Color.green]])
.action_({|me|
	~ss_carestart = me.value
});

~carandConfig
.states_([["Random",Color.black,Color.gray]])
.action_({|me|
	if (~carandConfigSized.value==0) {
		~randConfig.value(~gridside)
	} {
		~randConfigSized.value(~gridside,~carandConfigSizedNbox.value)
	}
});
~carandConfigSized
.states_([
	["Cell No",Color.black,Color.gray],
	["Cell No",Color.black,Color.green]]);
~carandConfigSizedNbox.value_(45);
~grainfreqserie
.states_([
	["armonic serie",Color.black,Color.cyan],
	["geometric serie",Color.black,Color.green],
	["Expanded harmonic",Color.black,Color.white],
	["Compressed harmonic",Color.white,Color.black]
])
.action_({|me|
	case
	{ me.value==0 } { ~freqserie = 0 }
	{ me.value==1 } { ~freqserie = 1 }
	{ me.value==2 } { ~freqserie = 2 }
	{ me.value==3 } { ~freqserie = 3 };
});
~seriebasefreq.value_(~bsfreq)
.action_({|me| ~bsfreq = me.value });
~cageneration
.states_([["GoL",Color.black,Color.gray]])
.action_({ ~gameOfLife.value(~cagrid) });

////////// GUI END ///////////

// read column from the CA BoxGrid
~readcol = {|col|
	var my2d,bfreq,freq,lenght,amp,dur,harmonics;
	bfreq = ~bsfreq ; // 80;
	harmonics = ~gridside-2;
	freq = List[];
	lenght = List[];
	amp = List[];
	my2d = Array2D.fromArray(~gridside,~gridside,~cagrid.getNodeStates.flat);
	dur = rand(~ss_deltadur) + ~ss_mindur;
	my2d.colAt(col).do{
		|me,idx|
		if (idx>0) {
			if (idx<=harmonics) {
				if (me==1) {
					if (~freqserie==0) {
						freq.add(~generalizedserie.value(bfreq,idx + 1,1,1,0)); // harmonic serie
					};
					if (~freqserie==1) {
						freq.add(~generalizedserie.value(bfreq,idx + 1,0,1.456,0)); // geometric serie
					};
					if (~freqserie==2) {
						freq.add(~generalizedserie.value(bfreq,idx + 1,1.5,1,0)); // expanded harmonic
					};
					if (~freqserie==3) {
						freq.add(~generalizedserie.value(bfreq,idx + 1,0.5,1,0)); // compressed harmonic
					};
					// freq.add(idx + 1 * bfreq/2);
					// different length for each sine of the column
					// lenght.add(rand(200) + 50);
					// same length for each grain of the column
					lenght.add(dur);
					amp.add(1/(idx));
				}
			}
		}
	};
	// amp = 0.5 / freq.size;
	freq.size.do{|idx|
	//	"inizializzo synth".postln;
		Synth(\singlegrain, [\freq, freq[idx], \length, lenght[idx],\amp,amp[idx]/freq.size])
	};
};


// sequencer - read each column every timestep - skip borders cause not used in Conway gameOfLife
~sequencer = {|cols|
	var step,columns;
	columns = cols - 2;
	columns.do{|i|
		if (~rnd==nil){~rnd=0};
		step = ~timestep + rand(~rnd);
		~readcol.value(i+1);
		step.wait;
	}
};
// generation of random configuration
~randConfig = {|side|
	var matrix;
	matrix = Array.fill(side*side, { rrand(0,1) }).clump(side);
	~cagrid.setNodeStates_(matrix);
};
// generate a fixed number of active cells in random positions
~randConfigSized = {|side,size|
	var matrix;
	matrix = Array.fill(side*side, 0).clump(side);
	size.do{
		var x,y;
		x = rand(side);
		y = rand(side);
		matrix[x][y] = 1;
	};
	~cagrid.setNodeStates_(matrix);
};
// generalized serie used for spectral design
~generalizedserie = {|base,n,alpha,beta,gamma|
	var freq;
	freq = base * ( n.pow(alpha) * beta.pow(n) + gamma );
};
//

~tas = Task{ loop{
	~sequencer.value(~gridside,~timestep,~rnd);
//	"CA Generation".postln;
//	~randConfig.value(16);
	~ss_gridcontent = ~gameOfLife.value(~cagrid,~gridside,~gridside);
	~checkgridstatus.value();
	}
};
~checkgridstatus = {
	var current, last,status;
	current = ~ss_gridcontent;
	if (~ss_gridcontentlast==nil){
		~ss_gridcontentlast = ~ss_gridcontent
	} {
		if (~ss_gridcontentlast==~ss_gridcontent){
			if (~ss_carestart==1) {
			// random generation
			~randConfig.value(~gridside);
			}
		}
	};
	~ss_gridcontentlast=~ss_gridcontent
};
// CA implementation of Conway Game Of Life
~gameOfLife = {|boxGrid,rows=16,cols=16|
	var grid,newgrid,x,y,liceCellCount,xmap,ymap;
	liceCellCount = 0;
	xmap = [-1,-1,-1,0,0,1,1,1];
	ymap = [-1,0,1,-1,1,-1,0,1];
	grid = Array2D.fromArray(rows,cols,boxGrid.getNodeStates.flat);
	newgrid = Array.fill(rows*cols, 0).clump(rows);
	x = grid.cols -2;
	y = grid.rows -2;
	y.do{|row|
		x.do{|col|
			var xc,yc,cell,neiCount;
			neiCount = 0;
			// calc array2D indexs to avoid borders
			xc = col+1;
			yc = row+1;
			//("Row: "++yc++" Col: "++xc++" Value: "++boxGrid.getState(xc,yc)).postln;
			cell = grid[yc,xc];
			// count live cells
			if (cell==1){ liceCellCount = liceCellCount+1 };
			// count the neighbours
			xmap.size.do{|idx|
				var neighbour,nx,ny;
				nx = xc + xmap[idx];
				ny = yc + ymap[idx];
				neighbour = grid[ny,nx];
				if (neighbour==1){neiCount = neiCount+1};
			};
			// Conway rules
			if (cell==1) {
				newgrid[yc][xc] = 1; // substitute conway rule 2
				// conway rule 1
				if (neiCount<2) {
					newgrid[yc][xc] = 0;
//					("apply rule 1 on x: "++yc++" y: "++xc).postln;
				};

				// conway rule 3
				if (neiCount>3) {
					newgrid[yc][xc] = 0;
//					("apply rule 3 on x: "++yc++" y: "++xc).postln;
				};
			};
			if (cell==0) {
				// conway rule 4
				if (neiCount==3) {
					newgrid[yc][xc] = 1;
//					("apply rule 4 on x: "++yc++" y: "++xc).postln;
				};
			}
		}
	};
	boxGrid.setNodeStates_(newgrid);
//	liceCellCount.postln;
//	grid.postln;
	newgrid
};
)
///////////////
// MANUAL EXECUTION - also controlled by GUI
///////////////
~tas.play;
~tas.stop;

~timestep = 0.0219;
~rnd = 0.01;
~timestep = 0.2;
~ss_mindur = 40;
~ss_deltadur = 80;

~gameOfLife.value(~cagrid);