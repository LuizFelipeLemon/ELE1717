#!/usr/bin/env python

LOWPASS = 10 # Hz
SAMPLE_RATE = 463 # Hz

import wave, struct, math
from numpy import fft
FFT_LENGTH = 20

NYQUIST_RATE = SAMPLE_RATE / 2.0
LOWPASS /= (NYQUIST_RATE / (FFT_LENGTH / 2.0))

# Builds filter mask. Note that this sharp-cut filter is BAD
mask = []
negatives = []
l = FFT_LENGTH / 2
for f in range(0, int(l+1)):
    rampdown = 1.0
    if f > LOWPASS:
        rampdown = 0.0
    mask.append(rampdown)
    if f > 0 and f < l:
        negatives.append(rampdown)

negatives.reverse()
mask = mask + negatives

fir = wave.open("fir_filter.wav", "w")
fir.setnchannels(1)
fir.setsampwidth(4)
fir.setframerate(SAMPLE_RATE)

# Convert filter from frequency domain to time domain
impulse_response = fft.ifft(mask).real.tolist()

# swap left and right sides
left = impulse_response[0:int(FFT_LENGTH / 2)]
right = impulse_response[int(FFT_LENGTH / 2):]
impulse_response = right + left

# write in a normal WAV file
impulse_response = [ sample * 2**31 for sample in impulse_response ]
print(len(impulse_response))
print(impulse_response)
fir.writeframes(struct.pack('%di' % len(impulse_response),
                                 *impulse_response))