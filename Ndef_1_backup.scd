// ---------------------------------------------------------------------------------------------
(
~mainAmp = 1;
if(~aBus.isNil, {
	~aBus = (outA: 0);
});
// ~aBus.outNdef = 120;
// ~cNdef = Bus.control(s,1).set(1);
// Ndef(\ndefMain).play(~aBus.outA, addAction: \addToTail);
// Ndef(\ndefMain, {
// 	In.ar(120, 2) * In.kr(~cNdef,1)
// });
// OSCdef(\ndef, { |msg|
// 	var chan, note, vel, src;
// 	chan = msg[1];
// 	note = msg[2];
// 	vel = msg[3];
// 	src = msg[4].asString;
// 	[chan,note,vel, src].postln;
// 	// volume up
// 	if(chan == 14 && note == 33, {
// 		~cNdef.get({arg val; val.postln; ~cNdef.set(min(val + 0.1,1))});
// 	});
// 	// volume down
// 	if(chan == 14 && note == 34, {
// 		~cNdef.get({arg val; val.postln; ~cNdef.set(max(val - 0.1,0))});
// 	});
//
// 	},
// 	"/midi/noteOn"
// )
)
// PANIC!
Ndef.clear
Ndef(\lowThrob).release;
Ndef(\wobblyMoog).release;
Ndef(\noiseHits).release;
Ndef(\sineCluster).release;
Ndef(\sineClusterHigh).release;
Ndef(\lowRumble).release;
Ndef(\ndefMain).stop;
OSCdef(\ndef).clear;

// ---------------------------------------------------------------------------------------------
Ndef(\lowThrob).play(~aBus.outA, addAction: \addToHead, vol: ~mainAmp * 2).fadeTime_(1);
(
// 40=E
~lowThrobMin = 40.midicps;
~lowThrobMax = 48.midicps;
Ndef(\lowThrob, {
	RLPF.ar(
		SinOsc.kr({Rand(10,15)}!2).range(0.2,0.7) * LFSaw.ar(Rand(~lowThrobMin,~lowThrobMax), mul: 0.5) ,
		SinOsc.kr( { Rand(0.1,0.2) }!2 ).range(80,1000), 0.5
	) * 0.2
});
)
Ndef(\lowThrob).release;
Ndef(\lowThrob).fadeTime = 1;
// Ndef(\lowThrob).stop;

// ---------------------------------------------------------------------------------------------
Ndef(\wobblyMoog).play(~aBus.outA, addAction: \addToHead, vol: ~mainAmp * 2).fadeTime_(1);
(
~amp = 0.1;
~grit = 100;
~pitchRange = 2;
~wobbleFrom = 200;
~wobbleTo = 900;
~wobbleFactor = 0.01;
~filterFrom = 500;
~filterTo = 900;
~filterFactor = 0.1;
Ndef(\wobblyMoog, {
	MoogFF.ar(
		SyncSaw.ar(SinOsc.kr([0.3,0.4]*~grit).range(100,102*LFNoise1.kr(0.5).range(0.5,1.5)) * ~pitchRange,
			SinOsc.kr([1.04,0.96] * ~wobbleFactor).range(~wobbleFrom,~wobbleTo)),
		SinOsc.kr(LFNoise0.kr(0.3).range(0.5,5) * ~filterFactor).range(~filterFrom, ~filterTo)
	) * ~amp;
});
)
Ndef(\wobblyMoog).release;
Ndef(\wobblyMoog).fadeTime = 1;
// Ndef(\wobblyMoog).stop;
// defaults
(
~amp = 0.2;
~grit = 100;
~pitchRange = 3;
~wobbleFrom = 200;
~wobbleTo = 900;
~wobbleFactor = 0.01;
~filterFrom = 500;
~filterTo = 900;
~filterFactor = 0.1;
)

// ---------------------------------------------------------------------------------------------
Ndef(\noiseHits).play(~aBus.outA, addAction: \addToHead, vol: ~mainAmp).fadeTime_(0);
(
Ndef(\noiseHits, {
	var sig = Impulse.ar({ Rand(0.1,0.2) }!2, mul: LFNoise1.kr(1).range(5,50));
	sig = ( WhiteNoise.ar(0.3) * LFPulse.kr({ Rand(10,20) * 1 }!2,0,0.1,2));
	sig = FreeVerb2.ar(sig[0],sig[1], room: 1);
	sig
});
)
Ndef(\noiseHits).release;
Ndef(\noiseHits).fadeTime = 0;
// Ndef(\noiseHits).stop;

// ---------------------------------------------------------------------------------------------
Ndef(\sineCluster).play(~aBus.outA, addAction: \addToHead, vol: ~mainAmp).fadeTime_(5);
(
Ndef(\sineCluster, {
	var sig = LFSaw.ar( { Rand(100,200) * 1  }!4, mul: 0.2);
	sig = RLPF.ar(sig, SinOsc.kr( { Rand(0.1,0.2) }!4).range(100,2000), 0.5);
	// sig = RLPF.ar(sig, SinOsc.kr( { Rand(0.1,0.2) }!4).range(100,2000), 0.5);
	Splay.ar(sig)
});
)
Ndef(\sineCluster).release;
Ndef(\sineCluster).fadeTime = 5;
// Ndef(\sineCluster).stop;

// ---------------------------------------------------------------------------------------------
Ndef(\sineClusterHigh).play(~aBus.outA, addAction: \addToHead, vol: ~mainAmp).fadeTime_(5);
(
Ndef(\sineClusterHigh, {
	var sig = LFSaw.ar( { Rand(1200,1600)  }!4, mul: 0.2);
	sig = RLPF.ar(sig, SinOsc.kr( { Rand(0.1,0.2) }!4).range(100,2000), 0.5);
	// sig = RLPF.ar(sig, SinOsc.kr( { Rand(0.1,0.2) }!4).range(100,2000), 0.5);
	Splay.ar(sig)
})
)
Ndef(\sineClusterHigh).release;
Ndef(\sineClusterHigh).fadeTime = 5;
// Ndef(\sineClusterHigh).stop;

// ---------------------------------------------------------------------------------------------
Ndef(\lowRumble).play(~aBus.outA, addAction: \addToHead, vol: ~mainAmp * 1).fadeTime_(2);
(
Ndef(\lowRumble, {
	SinOsc.kr( SinOsc.kr(0.5).range(1,20) ).range(0.2,1) *
	RLPF.ar( LFSaw.ar( { Rand(50,100) }!2, mul: 0.05), LFNoise1.kr(2).range(100,500), 0.5, 4)
})
)
Ndef(\lowRumble).release;
Ndef(\lowRumble).fadeTime = 2;
// Ndef(\lowRumble).stop;













