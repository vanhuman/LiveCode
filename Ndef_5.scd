
Ndef(\sample).play
Ndef(\sample).fadeTime_(0.2);

b = Buffer.alloc(s, 44100 * 10, 2);

~load.(b)


(
Ndef(\sample, {
	var sig2, sig, env, playhead, start, end;
	// start = LFNoise0.kr(0.3).range(3, 9) * 44100;
	start = SinOsc.kr(0.01).range(0, 9) * 44100;
	// end = start + (LFNoise0.kr(0.2).range(0.1, 1) * 44100);
	end = start + (SinOsc.kr(0.01).range(0.3, 0.05) * 44100);
	playhead = Phasor.ar(1, 0.9, start, end);
	sig = BufRd.ar(2, b, playhead);
	// sig = sig * SinOsc.kr(10);
	sig * 0.5
})
)

Ndef(\sample).release



