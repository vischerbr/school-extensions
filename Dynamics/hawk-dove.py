#/bin/python2
# This was originally created for an Evolutionary Game Theory project where
# a population can choose different strategies (being a `hawk' or `dove') and
# viability of that strategy based on the environment determines how many of the
# next generation inheret the strategy.
import matplotlib, sys, math, mpmath
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import random

crossover = .2
weight = 1.5

pop = 50
reward = 8
cost = 9
show = 0 #10

iters = 100
payoff = [[0,-1],[1,-10]]#[[.5*(reward-cost),reward],[0,.5*reward]]
herd_samples = 100

distr = np.random.uniform(low=.25,high=.75,size=(pop,))
print distr

herd_avgs = np.zeros(herd_samples+1)

def fitness(herd):
    hawk, dove = 0,0
   
    # hawks = int(len(herd)*herd_avg) 
    # doves = len(herd)-hawks 
    for unit in herd:
        if unit > np.random.uniform(low=0,high=1):
            hawk+=1
        else:
            dove+=1

    herd_avg = float(hawk)/float(dove+hawk)
    
    
    hawk_fit = herd_avg*(payoff[0][0]+ payoff[0][1])
    dove_fit = (1-herd_avg)*(payoff[1][0] +payoff[1][1])
    print dove_fit, hawk_fit
    
    
    return hawk_fit, dove_fit, herd_avg
m=0
for i in range(0, iters):
    print i
    new_distr = np.zeros_like(distr)
    tests=[0,0,0]
    
    for j in range(0,len(distr)):

        sampling = True
        while sampling:
            for k in range(3):
                tests[k]= random.choice(distr)
            if distr[j] not in tests:
                #sampling= False
                break # now, use diff evolution algorithm with random agents selected
            

        rand = np.random.uniform(low = 0,high = 1)
        if (rand<= crossover):
            new_distr[j] = tests[0] + weight*(tests[1]-tests[2])

        hawk_fit, dove_fit, herd_avg = fitness(distr)

        reject = False
        if hawk_fit > dove_fit:
            if new_distr[j]<.5:
                reject=True
        if hawk_fit < dove_fit:
            if new_distr[j]>.5:
                reject=True
        if new_distr[j]<0 or new_distr[j]>=1 or reject:
            new_distr[j] = distr[j]
    distr = new_distr

    if i%int(math.floor(iters/herd_samples)) ==0:
        m+=1
        herd_avgs[m] = herd_avg
        print herd_avgs
