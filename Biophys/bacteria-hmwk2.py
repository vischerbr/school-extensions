# This was a script written to calculate population dynamics over time for a simple
# bacterial interaction.

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
import random, copy, sys

matplotlib.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
matplotlib.rc('text', usetex=True)


samples_max = 100000
iters = 30
ave_samples = 50

population = np.zeros((samples_max, iters,))
ave_max = np.zeros((ave_samples,iters))
ave_min = np.zeros((ave_samples,iters))
ave_pop = np.zeros(iters)
std_pop = np.zeros(iters)

# iterate over generations
for sample in range(0,samples_max):
    Ns = np.array([500,500]) # Green, Red
    for  i in range(0,iters):
        Ns = 2*Ns
        if Ns[0]<=1000:
            q = np.random.random_integers(0,Ns[0])
            dG, dR = q, 1000-q
        else:   
            q = np.random.random_integers(0,Ns[1])
            dG, dR = 1000-q, q
        Ns[0] -= dG
        Ns[1] -= dR
        
        population[sample, i] = Ns[0] # stores current Green population

# Hokey way to make average population trajectories for both fixed points. mostly works
l=0
m = 0
for k in range(0, samples_max):
    if l==ave_samples or m==ave_samples:
        break # oh well, we'll stop I guess
    if population[k, -1] == 1000:
        ave_max[l, :] = population[k, :]
        l+=1
    if population[k, -1] == 0:
        ave_min[m,:] = population[k,:]
        m+=1
# Calculate average and standard deviation
for j in range(0, iters):
    ave_pop[j] = np.average(population[:, j])
    std_pop[j] = np.std(population[:,j])

plt.figure('Stuff')
plt.plot(range(0, len(ave_pop)),np.average(ave_max, axis=0), color = 'b', lw = 3, label = "Average trajectory")
plt.plot(range(0, len(ave_pop)),np.average(ave_min, axis=0), color = 'b', lw = 3)
plt.plot(range(0, len(ave_pop)),ave_pop, color = 'g', lw = 3, label = 'Mean')
plt.plot(range(0, len(ave_pop)),ave_pop + std_pop, color = 'r', lw = 3, label = 'Mean $\pm$ standard deviation')
plt.plot(range(0, len(ave_pop)),ave_pop - std_pop, color = 'r',lw = 3)
plt.legend(loc= 'best')
plt.xlabel('Generation')
plt.ylabel('Number of red cells')
plt.show()
