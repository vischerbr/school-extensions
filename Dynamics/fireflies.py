#!/usr/bin/python2
# This was originally created for a coupled oscillator project in a Dynamics class.
# The principle task was to model fireflies as coupled oscillators (using the Kuramoto model)on a square grid with some intrisic frequency. I took this a step farther
# and tried a hexagonal grid to see if the fixed points and behavior was different from the square case.
# It wasn't, but it was a fun challenge.


import matplotlib, os, math
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import random, copy

lenx, leny = 50,50
iters = 500
natural_frequency = 1.5 #.0001 s
crossover_rate = 10 #.0001s
dt = 1e-2

colors=['r','b','g','y']

flies = np.random.uniform(low=0,high=2,size = (lenx,leny))
flies_of_interest = {}

def init_inherent_frequency(flies, natural_frequency):
    for fly in flies:
        fly = np.random.uniform(low=0, high=2)
    return flies

def exchange(crossover_rate, flies):
    exchanges = np.zeros_like(flies)
    for i in range(0, len(flies[0,:])):
        for j in range(0,i):
            exchanges[i,j] = crossover_rate*np.random.uniform(low=0.5, high=1.5)
    #print 'exchanges are:,', exchanges
    return (exchanges + np.transpose(exchanges) - np.diag(exchanges.diagonal())) # gotta make it symmetric

def neighbors(flies, flynum):
    hood = [((flynum[0]+1)%lenx,flynum[1]),(flynum[0],(flynum[1]+1)%leny),((flynum[0]+1)%lenx,(flynum[1]+1)%leny), (flynum[0]-1,flynum[1]-1),(flynum[0]-1,flynum[1]),(flynum[0],flynum[1]-1)]
    #print 'hood is, ', hood
    return hood

def evolve(hood, exchange, fly,nat_fly):

    new_bright = nat_fly + sum(map(lambda x, y: y*np.sin(x-fly),hood, exchange))
    return new_bright


nat_flies = init_inherent_frequency(flies,natural_frequency)
time_flies = {}
exchanges = exchange(crossover_rate,flies)

for k in range(0,iters):
    next_flies = np.zeros_like(flies)
    for i in range(0,lenx):
        for j in range(0,leny):
            hood = neighbors(flies, (i,j))
            exchange_hood = [0,1,2,3,4,5]
            fly_hood = [0,1,2,3,4,5]
            for l in range(0,len(exchange_hood)):
                
                exchange_hood[l] = exchanges[hood[l]]    
                fly_hood[l] = flies[hood[l]]
            next_flies[i,j] = ((flies[i,j] + evolve(fly_hood, exchange_hood, flies[i,j], nat_flies[i,j])*dt))%2.0 
    print flies[-10:,-10]
    time_flies[k] = flies
    flies = next_flies


for t in range(0,iters):
    print 'Now saving file, ', t
    if not os.path.exists('./stuff-N-%i-dt-%1.2f-cross-%f/' %(lenx,dt,crossover_rate)) :
        os.system('mkdir ./stuff-N-%i-dt-%1.2f-cross-%f/' %(lenx,dt,crossover_rate))
    with open('./stuff-N-%i-dt-%1.2f-cross-%f/file%i.dat' %(lenx,dt,crossover_rate, t), 'w+') as file:
        for n in range(0,lenx):
            for m in range(0,leny): 
                file.write(' '.join([str(n), str(m), str(time_flies[t][m,n]),'\n'] ))
            file.write('\n')
#     #print flies
    #if k%(iters/5):    
#     flies_of_interest[k] = flies[25,25]

# print range(0,len(flies_of_interest)), '\n', flies_of_interest

# plt.figure('Plot')
# for l in range(0, iters):
#     plt.scatter(l, flies_of_interest[l])

# plt.title('Amplitude versus period for $t_{max}=100s$ at $1E5$ iterations.')
# plt.xlabel('$t$ (units)')

# plt.ylabel('Phase')
# plt.legend(loc='best')

# plt.tight_layout(pad=0.2)
# plt.savefig("flies_new.pdf")
