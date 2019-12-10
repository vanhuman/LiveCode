

Ndef(\sa).play.fadeTime_(2);
Ndef(\sa).release;

(
Ndef(\sa, {
	var sig, freqs, muls, sines, brown, white, beat;
	freqs = [
		190,
		TWChoose.kr(Impulse.kr(0.2), [80, 95], [0.8, 0.2]),
		TWChoose.kr(Impulse.kr(0.25), [270, 525, 470], [0.5, 0.3, 0.2]),
		900,
		370,
	];
	muls = [1, 5, 1, 1, 0.5];
	sines = Splay.ar(SinOsc.ar(freqs, mul: muls)) * 0.2;
	beat = LFNoise0.kr(TWChoose.kr(Impulse.kr(0.25), [2, 1, 4], [0.8, 0.1, 0.1])).range(0,1);
	beat.poll;
	sines = sines * beat;
	brown = SinOsc.kr(10) * BrownNoise.ar(0.07) * SinOsc.kr(0.01, 0).range(0,1);
	white = SinOsc.kr(20) * WhiteNoise.ar(0.02) * SinOsc.kr(0.01, pi).range(0,1);
	sig = sines + Pan2.ar(brown, LFNoise1.kr(0.05).range(-0.3, 0.3)) + Pan2.ar(white, LFNoise1.kr(0.05).range(-0.3, 0.3));
	sig
});
)

Ndef(\sa3).play.fadeTime_(2);
Ndef(\sa3).release;
(
Ndef(\sa3, {
	var sig, pulses, freqs, throb, sines;
	pulses = [
		TWChoose.kr(Impulse.kr(0.2), [2, 2.5], [0.5, 0.5]),
		2
	];
	freqs = [
		60,
		TWChoose.kr(Impulse.kr(0.1), [70, 80], [0.5, 0.5]),
	];
	sines = SinOsc.ar(freqs) + RLPF.ar(Saw.ar(freqs), 50, mul: 0.3);
	// sines = SinOsc.ar(freqs);
	// sines = SinOsc.ar(freqs) + LPF.ar(WhiteNoise.ar(0.7), 400);
	throb = Limiter.ar(LFPulse.ar(5) * SinOsc.kr(pulses) * sines, 0.8);
	sig = throb;
	sig
});
)




b = Buffer.alloc(s, 44100, 2);
{ RecordBuf.ar(SoundIn.ar([3,4]), b, loop: 0) }.play
b.play(mul: 4)


Ndef(\s2).play
(
Ndef(\s2, {
	LFNoise0.ar([3,4]) * BrownNoise.ar([0.3,0.3]) * 0.7
});
)
Ndef(\s2).release
