// to load samples
(
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
	}, path: "/Users/Robert/---data---/Audio/samples/voice/");
}
)


/////////////////////////////////////////////////////////

Ndef(\live).play.fadeTime_(2);
Ndef(\live).release

(
Ndef(\live, {
	var sig = SoundIn.ar(0);
	var sig2 = SoundIn.ar(0);
	sig = PitchShift.ar(sig, pitchRatio: [1.5, 1.4]);
	sig2 = PitchShift.ar(sig2, pitchRatio: [0.9, 0.8]) * 2;
	sig2 = FreeVerb2.ar(sig2[0], sig2[1], room: 0.8, damp: 0.1);
	// sig = PitchShift.ar(sig, pitchRatio: SinOsc.kr(0.1).range(0.3, 1.5));
	sig = AllpassC.ar(sig, 2, [0.3, 0.4] * LFNoise1.kr(0.2).range(0.1, 0.5), 2);
	(sig + sig2) * 0.5
})
)

/////////////////////////////////////////////////////////

Ndef(\sample).play
Ndef(\sample).fadeTime_(0.2);

b = Buffer.alloc(s, 44100 * 10, 2);

~load.(b)

(
Ndef(\sample, {
	arg rate = 1;
	var sig, len, playHead;
	// len = Impulse.kr(LFNoise1.kr(0.1).range(0.1, 0.5));
	// len = Impulse.kr(0.5);
	// sig = PlayBufCF.ar(2, b, LFNoise1.kr(1).range(0.5,1), len, 44100, 1);
	// sig = PlayBufCF.ar(2, b, -1, len, 0 * 44100, 1);
	var start = LFNoise0.kr(0.9).range(0, 8 * 44100);
	var end = start + (LFNoise0.kr(1).range(0.1, 2) * 44100);
	playHead = Phasor.ar(1, rate, start, end) % (10 * 44100);
	sig = BufRd.ar(2, b, playHead);
	sig = RLPF.ar(sig, SinOsc.kr(1).range(400, 6000), 0.5);
	sig * 1
})
)

(
x = Pbind(
	\type, \set,
	\id, Ndef(\sample).group,
	\args, #[rate],
	\rate, Pwhite(0.5, 1.7, 30) ++ [1],
	\dur, 0.1
).play
)
x.stop


Ndef(\sample).release

/////////////////////////////////////////////////////////

Ndef(\record).play.fadeTime_(2);
(
Ndef(\record, {
	var sig;
	sig = RecordBuf.ar(SoundIn.ar([0,0]), b, loop: 0, doneAction: 2);
	sig
})
)
Ndef(\record).release
