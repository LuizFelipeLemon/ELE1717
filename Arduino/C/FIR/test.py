import numpy as np
import matplotlib.pyplot as plt
from scipy.io import wavfile
import scipy.fftpack
import time as t
import csv
from sklearn.preprocessing import normalize



fig, axes = plt.subplots(2, 1)

ax1, ax2 = axes

t = np.arange(0,3,1/44100)

a = np.sin(2*np.pi*700*t) + np.sin(2*np.pi*400*t)

wavfile.write('sum.wav',44100,a)

sampling_freq, signal = wavfile.read('sum.wav')

#ax1.plot(signal)

#sp = np.fft.fft(signal)
#freq = np.fft.fftfreq(signal.shape[-1])

#ax2.plot(freq, sp.real)


#define FILTER_TAP_NUM 21

a  =  [
  -91205023418.17476,
  -78326916097.10924,
  -57784000679.98717,
  -28703495471.202255,
  4578303196.450315,
  48313784253.98602,
  92005035565.86392,
  116117885893.23831,
  136699131521.3662,
  130885389282.19206,
  89825121501.25655,
  30840663764.760887,
  -68180184269.34107,
  -175846137344.84497,
  -298439115396.13434,
  -175846137344.84497,
  -68180184269.34107,
  30840663764.760887,
  89825121501.25655,
  130885389282.19206,
  136699131521.3662,
  116117885893.23831,
  92005035565.86392,
  48313784253.98602,
  4578303196.450315,
  -28703495471.202255,
  -57784000679.98717,
  -78326916097.10924,
  -91205023418.17476
]



final = np.convolve(signal,a, 'same')
print(final.shape)

final = normalize([final],axis=1)
print(final.shape)
ax1.plot(signal)

ax2.plot(final)
print(np.max(final))


sp = np.fft.fft(final)
freq = np.fft.fftfreq(final.shape[-1])

#ax2.plot(freq, sp.real)



#wavfile.write('final.wav',44100,final)

plt.show()

print(a)