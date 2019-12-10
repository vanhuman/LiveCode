
( // just a little help to load samples easier
~load = {
	arg buffer;
	Dialog.openPanel({ arg path;
		var file = SoundFile.new();
		var channels;
		if (file.openRead(path)) {
			channels = if (file.numChannels == 1, { [0,0] }, { [0,1] });
			buffer.readChannel(path, channels: channels);
			("Loaded:" + path.subStr(path.findBackwards("/") + 1)).postln;
			file.close;
		}
	}, path: "/Users/Robert/---data---/Temp/Zaal100/");
}
)


// play that sample // multichannel expansion, amplitude modulation, low pitch
Ndef(\sample).play.fadeTime_(0.1);
b = Buffer.alloc(s, 44100 * 60, 2);
~load.(b)
(
Ndef(\sample, {
	var sig2, sig, env, playhead, start, end;
	start = [5, 5.1] * 44100 ;
	end = 2 * 44100 + start;
	playhead = Phasor.ar(1, [0.9, 0.91], start, end);
	sig = BufRd.ar(2, b, playhead);
	sig = sig * SinOsc.kr(10);
	sig * 0.8
})
)
Ndef(\sample).release


// something to create a sense of time // multichannel expansion
(
SynthDef(\boom, {
	arg level = 1, gate;
	var sigKick;
	sigKick = 0.7 * SinOsc.ar( XLine.kr(800,[50,55],0.02) * LFNoise1.kr(30).range(0.97,1.03) );
	sigKick = Splay.ar(sigKick);
	sigKick = sigKick * EnvGen.kr(Env.new([0,1,0],[0.01, 1]), doneAction: Done.freeSelf);
	Out.ar(0, sigKick * level);
}).add;
)
Pdef(\boomPattern).play;
(
Pdef(\boomPattern,
	Pbind(
		\instrument, \boom,
		\dur, Pseq([1.1, 0.9, 0.9, 1.1], inf),
		\level, Pseq([3,2,3] * 0.7, inf),
	)
);
)
Pdef(\boomPattern).stop;

Pdef(\boomPattern2).play;
(
Pdef(\boomPattern2,
	Pbind(
		\instrument, \boom,
		\dur, Pseq([1.1, 0.9, 0.4, 0.45, 1.1] * 2, inf),
		\level, Pseq([3,2,3] * 0.6, inf),
	)
);
)
Pdef(\boomPattern2).stop;


// a gritty drone // multichannel expansion, amplitude modulation
Ndef(\dron1).play.fadeTime_(0.1);
(
Ndef(\dron1, {
	var sig, sig1, sig2, env, envGen;
	env = Env.rcurve2(200, [0.1, 1], [0.001, 0.01], [0.2, 0.5], [0.9, 0.1]);
	envGen = EnvGen.kr(env);

	sig1 = Splay.ar(LFPulse.ar([2300, 305, 100, 10000], mul: [0.1, 0.1, 0.1, 0.1]));
	sig2 = SinOsc.ar([100, 97] * LFNoise1.kr(0.3).range(0.9, 1.1), mul: 0.7);

	sig = sig1 + sig2 + BrownNoise.ar(0.1, mul: 0.05);
	sig = sig * envGen * 0.8;
	sig
});
)
Ndef(\dron1).release


// a slower rhythm
Ndef(\dron2).play.fadeTime_(0.1);
(
Ndef(\dron2, {
	var sig, levels, times, env, envGen;
	env = Env.rcurve(50, [0.1, 2], [0.01, 0.2]);
	envGen = EnvGen.kr(env);

	sig = Splay.ar(SinOscFB.ar([300, 50, 202], SinOsc.kr(0.1).range(0,1), mul: [1,2,1]));
	sig = sig * LFPulse.kr(SinOsc.kr(0.3).range(5, 50));
	// sig = sig * Impulse.kr(SinOsc.kr(0.3).range(5, 50), mul: 3);
	sig * envGen * 0.5
});
)
Ndef(\dron2).release



// NOISE please
Ndef(\burst).play.fadeTime_(0.1);
(
Ndef(\burst, {
	var sig, sig1, sig2, env, envGen;
	env = Env.rcurve2(2000, [0.1, 1], [0.001, 0.01], [0.2, 0.5], [0.9, 0.1]);
	envGen = EnvGen.kr(env);

	sig = [ClipNoise.ar(0.9), BrownNoise.ar(0.9)];
	sig = RLPF.ar(sig, LFNoise0.kr(1.5).range(20000, 50000), LFNoise0.kr(1).range(0.6, 0.9));
	sig = sig * envGen;
	sig = sig * TWChoose.kr(Impulse.kr(2), [0,1], [0.8, 0.2]);
	sig
});
)
Ndef(\burst).release


//  a serene voice in there
Ndef(\sine).play.fadeTime_(0.2)
(
Ndef(\sine, {
	Splay.ar(SinOsc.ar([100, 1001, 500, 501, 102, 98])) * 0.1
})
)
Ndef(\sine).release

