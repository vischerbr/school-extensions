#/bin/python2

# This was a refined version of hawk_dove that added many new features - a
# generation-dependent resource scarcity; a rock-paper-scissors population
# with three strategies; and an addition to the hawk-dove game where
# a retalliation strategy is added.

import matplotlib, sys, math, mpmath
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import random



dt=.1
herd = [np.random.uniform(low=1.0,high=200.0),np.random.uniform(low=1.0,high=20)]
k = 1.0
C = 2.0
V=1.0
iters =200
herds = np.zeros(shape = (iters, len(herd)))

colors = ['r', 'k']#['#ffa500', '#ffff00', 'b']
labels = ['Hawks', 'Doves','Blues']#,'Retaliators']

def payoff_mat(t,k,C,nat_V):
    hdr = False 
    hd = True
    time_dependent = True
    our_game = False
    rsb = False
    if hd:
        if time_dependent:
            V = nat_V*np.exp(-k*t)
        else:
            V= nat_V
        mat = [[.5*(V-C),V],[0,V/2]]
        #print mat
    if hdr:
        V,C=nat_V, C
        mat = [[.5*(V-C),V,.5*(V-C)],[0,V/2, .5*V], [.5*(V-C), .5*V, .5*V]]
    if rsb:
        mat = [[0,-1.0,1.0],[1.0,0,-1.0],[-1.0,1.0,0]]
    if our_game:
        mat = [[0,2.0],[0,1.0]]
    return mat

def herd_fitness(herd, payoff):
    fitness = np.dot(herd, np.dot(payoff,herd))
    
    #herd = herd/np.sum(herd) # herd is normalized already
    # for i in range(0,len(herd)):
    #     for j in range(0, len(herd)):
    #         fitness += herd[j]*payoff[i][j]*herd[i]
    return fitness

def strategy_fitness(herd, strategy, payoff):
    #herd = herd/np.sum(herd) # herd is normalized already
    fitness = np.dot(payoff,herd)
    return fitness[strategy]

def evolve(herd,payoff,dt):
    reproduction_rate = .1
    next_herd = np.zeros_like(herd)
    norm_herd = [float(i)/sum(herd) for i in herd]
    #norm_herd = herd/np.dot(herd, herd)
    
    for i in range(0,len(herd)):
        next_herd[i] = dt*(norm_herd[i]+ reproduction_rate)*(strategy_fitness(norm_herd, i, payoff)) - dt*norm_herd[i]*herd_fitness(norm_herd, payoff)
    #print next_herd
    return next_herd*np.sum(herd)


for i in range(0, iters):
    #print 'Time step is: ', i, '\n', 'Herd is currently: ', herd
    payoff = payoff_mat(i*dt, k,C,V)
    herds[i,:] = herd 
    print herds[i,:]
    herd += evolve(herd, payoff,dt)
    #print herds

plt.figure('Plt')
for q in range(0,len(herd)):
    plt.scatter(np.arange(0,iters*dt,dt), herds[:,q], label=labels[q], color=colors[q])
plt.title('Population dynamics for $V/C = %1.2f$' % (V/C) )#resource drain constant $\kappa$ = %1.2f' % k)
plt.ylabel('N')
plt.xlabel('Generation (arbitrary units)')
plt.tight_layout(pad=0.2)
plt.ylim(0)
plt.xlim(0, iters*dt)
plt.legend(loc='best')
plt.savefig("hd-cv-t-%2.1f.pdf" % (float(C)/float(V)))#)-k-%1.1f-cv-%2.1f.pdf" % (k,float(C)/float(V)))

# print 'Distr is: ', distr
