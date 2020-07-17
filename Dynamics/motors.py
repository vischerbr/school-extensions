#/bin/python2


# This was a script to simulate the action that a molecular moter undergoes as it
# travels through a viscious environment.
import matplotlib, sys, math, mpmath
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import random

pop = 500 # number of motors
dt = .012 #s
iters = 500 # total number of iterations
r=0.1 # reynolds number
distr = np.random.uniform(low=0,high=20,size=pop) # initialize random positions of all motors. this array keeps track of all
mean = np.zeros(iters)
deviation=np.zeros(iters)

new_distr = np.zeros_like(distr) # array used for copying to original after time steps
timed_dists = np.zeros((len(distr),iters)) # array used for storing time traces of positions
for t in range(iters): # iterate over time
    print 'Now working in iteration: ', t
    for i in range(0,len(distr)): #iterate over each motor
        new_distr[i] = distr[i] + (r + np.sin(distr[i]))*dt # position at next time step is determined by diff eq
    distr = new_distr # save new positions to old array
    timed_dists[:,t] = distr # store time trace

    mean[t] = (np.sum(distr))/float(len(distr))
    #for j in range(0,len(distr))
    #var[t] = map(lambda x: x-mean[t])
    deviation[t] = np.sqrt(1/(len(distr)-1.0)*np.sum((distr - mean[t])**2))
    print deviation[t]

# plt.figure('Plt-dev')
# plt.scatter(range(0,iters), deviation)
# plt.title('Standard deviation for $r=%1.2f$ as a function of time' %r)
# plt.ylabel('$\Delta$ x (arbitrary units)')
# plt.xlabel('t (s)')
# plt.tight_layout(pad=0.2)
# plt.savefig("motors-r-%1.2f-SD.pdf" %  r)

# print 'Distr is: ', distr


ts = np.arange(0,iters*dt, dt) # create array of times
plt.figure('Plot')



for i in range(0,len(timed_dists[:,0])): # iterate over each motor
    print 'Now plotting data for motor: ', i
    #for i in range(0, len(timed_dists))
    plt.scatter(ts, timed_dists[i,:], color='k', marker='.', linewidth=.001) #plot time trace of individual motor

plt.title('Motor path for $r=%1.2f$.' % r)
plt.xlabel('$t$ (units)')
plt.xlim(0,5)
plt.ylim(0,20)
plt.ylabel('Distance (arbitrary units)')
plt.legend(loc='best')
plt.tight_layout(pad=0.2)
plt.savefig("motors-r-%1.2f.pdf" %  r)
