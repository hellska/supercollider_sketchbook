
{ SinOsc.ar(440) }.plot(0.09);
{ Saw.ar() }.plot;

{ SinOsc.ar(440) * Linen.kr(1,5,1,1) }.plot;
{ Saw.ar(440) }.play;
{ Pulse.ar() }.play;

{ ( SinOsc.ar(440) + Saw.ar(440) ) * Linen.kr(1,5,1,1) }.plot;

{ SinOsc.ar(440) + SinOsc.ar(880) + SinOsc.ar(700) }.plot(0.09);

{ SinOsc.ar(6) }.plot(1);

{ SinOsc.ar(440) + SinOsc.ar(880) + SinOsc.ar(700) }.play;

{ SinOsc.ar([60,80,120,345,654,736,546,23,574,234]) }.plot;

{ Mix.ar(SinOsc.ar([60,80,120,345,654,736,546,23,574,234])) }.plot(0.04);

{ Mix.ar(SinOsc.ar([60,80,120,345,654,736,546,23,574,234])) }.play;

{ Mix.ar(SinOsc.ar([440,440+(440*(2**(1/12)))])) }.play;
{ Mix.ar(SinOsc.ar([440,440+(440*(2**(6/12)))])) }.play;
{ Mix.ar(SinOsc.ar([60.midicps,65.midicps,68.midicps])) }.play;

{ Mix.ar(SinOsc.ar([60.midicps,65.midicps,68.midicps])) }.plot(0.05);