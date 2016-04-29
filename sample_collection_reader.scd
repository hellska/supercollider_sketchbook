// File
// CSVFileReader

(
var smpldir, smplpath;
smpldir = "/Volumes/ssdData/soundsAndSamples/smplcollection/";
smplpath = PathName.new(smpldir);
smplpath.files.postln;
)

// read a soundfile and play it
(
~time = 5;
~rfc = Routine.new({|inval|
	loop {
		var smpldir, smplpath, smpllist;
		smpldir = "/Volumes/ssdData/soundsAndSamples/smplcollection/";
		smplpath = PathName.new(smpldir);
		smplpath.files.postln;
		smplpath.filesDo{|file|
			smpllist = smpllist.add(SoundFile.new(file.fullPath.standardizePath));
			"added".postln;
			smpllist[0].play;
			file.fullPath.postln;
			//File.delete(file.fullPath);
			};
		~time.wait;
	}
});
)

// read the file and store into a buffer
// delete the file after reading to avoi duplicate in the list
(
// read WAV files automatically
~smpllist = Array.newClear(20);
~time = 5;
~scount = 0;
~maxsounds = 20;
~rfc = Routine.new({|inval|
	loop {
		var smpldir, smplpath, smpllist;
		smpldir = "/Volumes/ssdData/soundsAndSamples/smplcollection/";
		//smpldir = "/Volumes/ssdData/python_web_dev_virtualenv/first_app/sounds/";
		smplpath = PathName.new(smpldir);
		smplpath.files.postln;
		// check the counter for resetting the sounds buffer
		// HERE
		smplpath.filesDo{|file|
			/*~smpllist = ~smpllist.add(
				Buffer.read(s,file.fullPath.standardizePath,
					action:{ "read".postln;
					// File.delete(file.fullPath);
				})
			);
			*/
			~smpllist = ~smpllist.put(~scount,
				Buffer.read(s,file.fullPath.standardizePath,
					action:{ "read".postln;
					// File.delete(file.fullPath);
				})
			);
			// ~smpllist[0].play;
			// file.fullPath.postln;
			// File.delete(file.fullPath);
			};
		~time.wait;
		if (~scount<(~maxsounds-1)) {
			~scount = ~scount + 1;
		} {
			~scount = 0;
			"restart filling the collection!".postln;
		};
	}
});
)

(
// read MP£ files automatically
~smpllist = Array.newClear(20);
~time = 5;
~scount = 0;
~maxsounds = 20;
~rfc = Routine.new({|inval|
	loop {
		var smpldir, smplpath, smpllist;
		// smpldir = "/Volumes/ssdData/soundsAndSamples/smplcollection/";
		smpldir = "/Volumes/ssdData/python_web_dev_virtualenv/first_app/sounds/";
		smplpath = PathName.new(smpldir);
		smplpath.files.postln;
		// check the counter for resetting the sounds buffer
		// HERE
		smplpath.filesDo{|file|
			// var infile;
			/*~smpllist = ~smpllist.add(
				Buffer.read(s,file.fullPath.standardizePath,
					action:{ "read".postln;
					// File.delete(file.fullPath);
				})
			);
			*/
			// infile = MP3(file.fullPath.standardizePath);
			~smpllist = ~smpllist.put(~scount,
				MP3.readToBuffer(s,file.fullPath.standardizePath)
			);
			// ~smpllist[0].play;
			// file.fullPath.postln;
			// File.delete(file.fullPath);
			};
		~time.wait;
		if (~scount<(~maxsounds-1)) {
			~scount = ~scount + 1;
		} {
			~scount = 0;
			"restart filling the collection!".postln;
		};
	}
});
)

(
// read file from a folder convert to wav mono, normalize (using sox) and load into buffer automatically
~smpllist = Array.newClear(20);
~filelist = Array.newClear(20);
~time = 5;
~scount = 0;
~maxsounds = 20;
~rfc = Routine.new({|inval|
	loop {
		var smpldir, smplpath, smpllist, isnew, wavdir, stdout;
		// isnew = true;
		// smpldir = "/Volumes/ssdData/soundsAndSamples/smplcollection/";
		// web app path
		smpldir = "/Volumes/ssdData/python_web_dev_virtualenv/first_app/sounds/";
		wavdir = "/Volumes/ssdData/soundsAndSamples/convertedwav/";
		smplpath = PathName.new(smpldir);
		// smplpath.files.postln;
		// check the counter for resetting the sounds buffer
		// HERE
		smplpath.filesDo{|file|
			isnew = true;
			~filelist.do{|el idx|
				if (file.fullPath==el) { isnew = false };
			};
			if (isnew) {
				var soxc, soxn;
				~filelist = ~filelist.put(~scount, file.fullPath);
				// comversin mp3 -> wav
				///
				/// change the file names because they does not match the filename check
				///
				soxc = "/opt/local/bin/sox"
				+file.fullPath.postln
				+wavdir++file.fileNameWithoutExtension++".wav channels 1";
				soxc.standardizePath.unixCmdGetStdOut;
				// wait to be sure that the file exists
				0.5.wait;
				// normalize files
				soxn = "/opt/local/bin/sox --norm"
				+wavdir++file.fileNameWithoutExtension++".wav"
				+wavdir++file.fileNameWithoutExtension++"norm.wav";
				// soxn.postln;
				stdout = soxn.standardizePath.unixCmdGetStdOut;
				// wait to be sure that the file exists
				0.5.wait;
				~smpllist = ~smpllist.put(~scount,
					Buffer.read(s,(wavdir++file.fileNameWithoutExtension++"norm.wav").standardizePath,
						action:{ ("read"+wavdir++file.fileNameWithoutExtension++"norm.wav").postln;
							File.delete(wavdir++file.fileNameWithoutExtension++".wav".standardizePath);
					})
				);
				if (~scount<(~maxsounds-1)) {
					~scount = ~scount + 1;
				} {
					~scount = 0;
					"restart filling the collection!".postln;
				};
			};
		};
		~time.wait;
	};
});
)

~smpllist.size;

~time = 0.8;

~rfc.play;
~rfc.pause;
~rfc.stop;
~rfc.reset;
~rfc.seconds;
~rfc.beats;
~rfc.run(345);

~scount
~smpllist[~scount-1].play;
~smpllist[8].play;
~smpllist[8].path
Buffer
{ PlayBuf.ar(1, ~smpllist[0]) }.play;
{ PlayBuf.ar(1, ~smpllist[1]) }.play;

~smpllist.size;
~smpllist = [];
~smpllist.do{|what, idx| { PlayBuf.ar(1, ~smpllist[idx]) }.play; };

s.meter
~out = "sox --norm 266344-chaos.wav 266344-chaos_norm.wav".unixCmdGetStdOut;
~out
