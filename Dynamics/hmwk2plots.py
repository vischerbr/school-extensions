#!/usr/bin/python2

# This was a simple homework script to simulate a nonlinear differential equation.

import matplotlib, sys, math, mpmath
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np




matplotlib.rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
matplotlib.rc('text', usetex=True)

amps = np.arange(10,30.0,0.5)   #[1e-4,1e-2,1e0,1e2,1e4]
m = 1.0 # kg
vmax = 10.0 #m/s
beta = 1.0
iters = 1e5
tmax = 1e2
dt = float(tmax/iters)
Emax = .5*m*vmax**2
Eaves = np.zeros_like(amps)
Etotals = np.zeros_like(amps)
periods= np.zeros_like(amps)


for j in range(0,len(amps)):
        print 'Now on loop: ', j
        ts = np.arange(0,tmax,dt)
        xs = np.zeros_like(ts)
        xdots = np.zeros_like(ts) # refresh arrays for new time total
        Vs =  np.zeros_like(ts)
        Ts =  np.zeros_like(ts)
        xzeros = np.zeros(10000)
        xs[0] = amps[j]
        xdots[0] = 0
        k=0

        for i in range(1, len(ts)-1):
                
                xs[i] = xs[i-1]*(1.0-4.0*beta/m*xs[i-1]**2*dt**2) + xdots[i-1]*dt
                xdots[i] = (xs[i]-xs[i-1])/dt
                #print('xs are: ', xs[i]) 
                if (xs[i]>0 and xs[i-1]<0) or (xs[i]<0 and xs[i-1]>0):
        	        xzeros[k] = ts[i]
        	        #print xs[i], ts[i]
        	        k+=1 
        Vs = map(lambda x: beta*x**4, xs)
        Vave = np.sum(Vs)/float(len(ts))
        Ts = map(lambda x: 0.5*m*x**2, xdots)
        Tave = np.sum(Ts)/float(len(ts))
        period = 0


        print 'k is: ', k
        
        for m in range(2,k):
    	        period += (xzeros[m] - xzeros[m-2])/float(k)
        print period

        periods[j] = period
        Eaves[j] = Tave/Vave
        Etotals[j] = Tave + Vave



plt.figure('Plot')
plt.scatter(amps[-25:], periods[-25:], linestyle = '-',label= 'Period')
#plt.plot(tmaxes, Etotals, linestyle = '-',label='$Energy sum$')
#plt.axvline(Emax,linewidth=1,color='k',linestyle=':')ev
plt.title('Amplitude versus period for $t_{max}=100s$ at $1E5$ iterations.')
plt.xlabel('$A (m)$')
plt.ylabel('$T (s)$')
plt.legend(loc='best')
#plt.axvline(min_T,linewidth=1,color='k',linestyle=':')
plt.tight_layout(pad=0.2)
plt.savefig("period-iters%i-tmax%i.pdf" % (iters, tmax))

    
#print 'periods are: ', periods, 'amps are: ', amps

# tmaxes = [1,5e0,1e1,5e1,1e2,5e2,1e3,5e3]   #[1e-4,1e-2,1e0,1e2,1e4]
# m = 100 # kg
# vmax = 10.0 #m/s
# beta = 1.0
# iters = 1e3
# dt = float(2/iters)
# Emax = .5*m*vmax**2
# Eaves = np.zeros_like(tmaxes)
# Etotals = np.zeros_like(tmaxes)
# periods= np.zeros_like(tmaxes)


# for j in range(0,len(tmaxes)):

#     ts = np.arange(0,tmaxes[j],dt)
#     xs = np.zeros_like(ts)
#     xdots = np.zeros_like(ts) # refresh arrays for new time total
#     Vs =  np.zeros_like(ts)
#     Ts =  np.zeros_like(ts)
#     zeros = np.zeros(10)

#     xs[0] = 0
#     xdots[0] = vmax
#     Vs[0]=0

#     for i in range(1, len(ts)-1):
#     	k=0

#         xs[i] = xs[i-1]*(1.0-4.0*beta/m*xs[i-1]**2*dt**2) + xdots[i-1]*dt
#         xdots[i] = (xs[i]-xs[i-1])/dt
#         #print('xs are: ', xs[i]) 
#         if (xs[i]>=0 and xs[i-1]<=0) or (xs[i]<=0 and xs[i-1]>=0):
#         	zeros[k] = i
#         	#print zeros[k]
#         	k+=1 
#     Vs = map(lambda x: beta*x**4, xs)
#     Vave = np.sum(Vs)/float(len(ts))
#     Ts = map(lambda x: 0.5*m*x**2, xdots)
#     Tave = np.sum(Ts)/float(len(ts))
#     for m in range(1,len(zeros)):
#     	period = (xs[m] - xs[m-1])/float(len(zeros))

#    	periods[j] = period
#     Eaves[j] = Tave/Vave
#     Etotals[j] = Tave + Vave
    


        
# plt.figure('u')
# plt.title('Specific internal energy for $\lambda=%g$, $L=%g$, and $N=%i$' % (ww, L, n))
# plt.xlabel('$kT/\\beta$')
# plt.ylabel('$U/N\\beta$')
# plt.legend(loc='best')
# plt.axvline(min_T,linewidth=1,color='k',linestyle=':')
# plt.tight_layout(pad=0.2)
# plt.savefig("ww%02.0f-L%02.0f-N%i-u.pdf" % (ww*100, L, N))

# plt.figure('hc')
# plt.title('Specific heat capacity for $\lambda=%g$, $L=%g$, and $N=%i$' % (ww, L, N))
# plt.ylim(0)
# plt.xlabel('$kT/\\beta$')
# plt.ylabel('$C_V/Nk$')
# plt.legend(loc='best')
# plt.axvline(min_T,linewidth=1,color='k',linestyle=':')
# plt.tight_layout(pad=0.2)
# plt.savefig("ww%02.0f-L%02.0f-N%i-hc.pdf" % (ww*100, L, N))

# plt.figure('s')
# plt.title('Configurational entropy for $\lambda=%g$, $L=%g$, and $N=%i$' % (ww, L, N))
# plt.xlabel(r'$kT/\\beta$')
# plt.ylabel(r'$S_{\textit{config}}/Nk$')
# plt.legend(loc='best')
# plt.axvline(min_T,linewidth=1,color='k',linestyle=':')
# plt.tight_layout(pad=0.2)
# plt.savefig("ww%02.0f-L%02.0f-N%i-S.pdf" % (ww*100, L, N))
