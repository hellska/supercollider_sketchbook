o = ServerOptions.new;
o.memSize = 1048576;
o.sampleRate = 48000;
Server.default.options = o;
s.options.sampleRate = 48000;
// override the default soundcard
s.options.device = "JackRouter";
s.boot;
s.doWhenBooted({
	// this special startup file is in the Library folder
	("".resolveRelative++"hellska_startup.scd").load;
});