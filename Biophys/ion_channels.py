# This was a script written to smooth out some current data obtained from
# a cell's ion channels and identify when the current crossed over a threshhold
# (indicating when the channel opened or closed).

#!/usr/bin/env python
from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as ss
from scipy.signal import butter, lfilter
import csv

def butter_bandpass(lowcut, highcut, fs, order=5):
	nyq = 0.5 * fs
	low = lowcut / nyq
	high = highcut / nyq
	b, a = butter(order, [low, high], btype='band')
	return b, a

def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
	b, a = butter_bandpass(lowcut, highcut, fs, order=order)
	y = lfilter(b, a, data)
	return y

def find_zeros(data):
	zeros = []

	for i in range(0,len(data)-1):
		if(data[i]*data[i+1] < 0):
			zeros.append(i)
		#if(data[i]*data[i+1] < 0 and data[i]<0): 
			#zerosminus.append(i)
			
	return zeros

def calc_runtimes(data,zeros,dt):
	ontimes = []
	offtimes = []
	for q in range(0, len(zeros)-1):
		if(data[zeros[q]] > 0 and data[zeros[q+1]]<0):
			offtimes.append((zeros[q+1] - zeros[q]))
		elif(data[zeros[q]] < 0 and data[zeros[q+1]]>0):
			ontimes.append((zeros[q+1] - zeros[q]))
	return ontimes, offtimes


dt = 0.001
current = np.genfromtxt('current.dat')
time = np.arange(0,len(current),1)*dt
#print(time)



#plt.plot(time, current, label='sure')
#plt.xlabel('time (seconds)')
##plt.hlines([-a, a], 0, T, linestyles='--')
##plt.grid(True)
#plt.axis('tight')
#plt.legend(loc='upper left')

if __name__ == "__main__":
	import numpy as np
	import matplotlib.pyplot as plt
	from scipy.signal import freqz

	# Sample rate and desired cutoff frequencies (in Hz).
	#fs = 10000
	#lowcut = 75
	#highcut = 3000
	fs = 10000
	lowcut = 75
	highcut = 2500

	# Filter a noisy signal.

	filtered_current= butter_bandpass_filter(current, lowcut, highcut, fs, order=3)
	
	zeros = find_zeros(filtered_current)
	ontimes, offtimes = calc_runtimes(filtered_current, zeros,dt)
	print(ontimes)
	#print(y)
	#plt.plot(time, filtered_current, label='Filtered signal (Hz)')
	#plt.xlabel('time (seconds)')
	#plt.axis('tight')
	#plt.legend(loc='upper left')
	#plt.show()
	##-------------------------------------##
	#https://stackoverflow.com/questions/33811353/histogram-fitting-with-python
	#P1 = ss.expon.fit(ontimes)
	#rX1 = np.linspace(0,max(ontimes), 100)
	#rP1 = ss.expon.pdf(rX1, *P1)
	
	filename1 = 'dataon.csv'
	filename2 = 'dataoff.csv'
	with open(filename1,'wr') as file:
		writer = csv.writer(file)
		writer.writerows([ontimes])
	with open(filename2,'wr') as file:
		writer = csv.writer(file)
		writer.writerows([offtimes])





	#P2 = ss.expon.fit(offtimes)
	#rX2 = np.linspace(0,max(offtimes), 100)
	#rP2 = ss.expon.pdf(rX2, *P2)
	
	#plt.hist(ontimes, normed=True)
	#plt.hist(offtimes, normed=True)
	#plt.plot(rX1, rP1, color = 'b', linewidth = 3)
	#plt.plot(rX2, rP2, color = 'g', linewidth = 3)
	#plt.hist(offtimes)	
	##plt.hist(histoff,20)
	#plt.legend(loc='upper left')
	#plt.show()
	# need a legend!
