

Ndef(\play).play;
Ndef(\play).fadeTime_(1);
Ndef(\play).release
(
Ndef(\play, {
	var sig, sig1, sig2, env, envGen;
	env = Env.rcurve2(200, [0.1, 1], [0.001, 0.01], [0.2, 0.5], [0.9, 0.1]);
	envGen = EnvGen.kr(env.circle);

	sig1 = LFPulse.ar([2000, 3055], mul: 0.2);
	sig2 = SinOsc.ar([100, 97] * LFNoise1.kr(0.3).range(0.9, 1.1), mul: 1.7);

	sig = sig1 + sig2 + BrownNoise.ar(0.1);
	// sig = Greyhole.ar(sig,
	// 0.2, 0.5, 0.5 + (3 * LFNoise1.kr(0.5).range(0.5, 1)), feedback: 0.2);
	sig = sig * envGen;
	// sig = sig * MouseY.kr();
	sig
});
)

(
Ndef(\play, {
	var sig, levels, times, env, envGen;
	sig = Splay.ar(SinOscFB.ar([300, 50, 202] * 1, SinOsc.kr(0.1).range(0,1), mul: [1,2,1]));
	env = Env.rcurve(50, [0.1, 2], [0.01, 0.2]);
	envGen = EnvGen.kr(env);
	sig = sig * LFPulse.kr(SinOsc.kr(0.3).range(5, 50));
	// sig = sig * Impulse.kr(SinOsc.kr(0.3).range(5, 50), mul: 3);
	sig * envGen
});
)

(
Ndef(\play, {
	var sig;
	var freq = LFNoise0.kr({rrand(0.05, 0.2)}!2).range(40, 100);
	sig = LFPulse.ar(freq, 0.5, mul: 1);
	sig * EnvGen.kr(Env.rcurve2(shortTimesBounds: [0.001, 0.02]))
})
)

Ndef(\boom).play;

(
Ndef(\boom, {
	var sigKick = [0,0], kickIndex, kickFreq;
	sigKick[0] = SinOsc.ar( XLine.kr(800,50,0.02) * LFNoise1.kr(30).range(0.97,1.03) );
	kickFreq = [900,200,50,2000].wchoose([0.5,0.2,0.2,0.1]);
	sigKick[1] = LPF.ar(Ringz.ar(Impulse.ar(0), rrand(50,80), rrand(0.5,0.8)), kickFreq, mul:2);
	sigKick = sigKick * EnvGen.kr(Env.new([0,1,0],[0.01, 1]));
	sigKick * 3
})
)

(
SynthDef(\boom, {
	arg level = 1, gate;
	var sigKick = [0,0], kickIndex, kickFreq;
	sigKick[0] = 0.7 * SinOsc.ar( XLine.kr(800,50,0.02) * LFNoise1.kr(30).range(0.97,1.03) );
	kickFreq = [900,200,50,2000].wchoose([0.5,0.2,0.2,0.1]);
	sigKick[1] = LPF.ar(Ringz.ar(Impulse.ar(0), rrand(50,80), rrand(0.5,0.8)), kickFreq, mul:2);
	sigKick = sigKick * EnvGen.kr(Env.new([0,1,0],[0.01, 1]), doneAction: Done.freeSelf);
	Out.ar(0, sigKick * level);
}).add
)

Pdef(\boomPattern).play
Pdef(\boomPattern).stop

(
Pdef(\boomPattern,
	Pbind(
		\instrument, \boom,
		\dur, Pseq([1.1, 0.9, 0.9, 1.1], inf),
		\level, Pseq([3,2,3] * 0.7, inf),
	)
)
)


















