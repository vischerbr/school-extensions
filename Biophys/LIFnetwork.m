%In this simulation, we have a total of (nneurons) LIF neurons. A small
%fraction (fracsen) of them receive Poisson input. The Poisson input is a
%spike train of average frequency (freqinput)

%For this particular example, you can change synaptic weight (synweight)
%from 0.1 to 0.5 to see how it controls the synchronization


%%basic parameter setup

%number of neurons
nneurons = 1000;

%simulation time step and total time
timestep = 0.1; %msec
Nsteps = 10000; % number of steps in msec




%LIF model parameters
taum = 20; %msec
Urest = 0; %mV
Ureboot = 10; %mV
Ufire = 20; %mV
tauref = 2; %msec

%synaptic communication parameters
syndelay = 1.5; %msec
%we consider only excitory neurons
synweight = 0.2; %mV
g= -0.001;
q= 10;
inhibweight = g*synweight;
%probability of forming a synapse between any two neurons
synprob = 0.8;



%External input parameters

fracsen = 0.4;
fracinhib = 0.3;
freqinput = 20; %Hz


%%initiallization

%For a Poisson process with average frequency f, the probability that no
%event happens within a time period T is exp(-fT).
probextfire = 1- exp(-timestep*0.001*freqinput);
extfirepotential =  q*Ufire*double(rand(nneurons,Nsteps)<probextfire);

%neuron 1 to Nsen receive external input
Nsen = floor(nneurons*fracsen);
Ninhib = floor(nneurons*fracinhib);

% the inhibitory ones send negative pulses
%extfirepotential(Nsen+1:Nsen+1+Ninhib+1,:) = -...
%    extfirepotential(Nsen+1:Nsen+1+Ninhib+1,:);
extfirepotential(Nsen+1+Ninhib+1:end,:) = 0;



syndelayframe = round(syndelay/timestep);
refractoryframe = round(tauref/timestep);

%ideally we would save the activity of all neurons, but that takes a lot of
%memory, so instead we keep track of spikes only
avgvoltage = zeros(1,Nsteps);
spiketrain = false(nneurons,Nsteps);

%inhibadjust = [ones(1,nneurons-Ninhib) g*ones(1,Ninhib)];
%coupling = synweight*double(rand(nneurons,nneurons)<synprob);

couplingvec = [ones(1,nneurons-Ninhib) g*ones(1,Ninhib)];

coupling = (synweight*double(rand(nneurons,nneurons)<synprob)).*couplingvec'.*couplingvec;

% add in inhibitory synapses
%coupling = inhibadjust.*coupling;

u = zeros(nneurons,1)+Urest;
synapseinput = zeros(nneurons,1);

%refractorycount is set to be refractoryframe, and reduce by one every time
%step until 0, which means the neuron can fire again.
refractorycount = zeros(nneurons,1);

%this is not necessary, and may be skipped when nneurons is large
potentialprofile = zeros(nneurons,Nsteps);

%%start integration with time

for indframe = 1:Nsteps
    duleak = -(u-Urest)*timestep/taum;
    if (indframe>syndelayframe)
    synapseinput = spiketrain(:,indframe-syndelayframe);
    end
 
    refractorycount = refractorycount-1;
    refractorycount(refractorycount<0) = 0;
    
    refractoryfac = double(~refractorycount);
    temp1 = coupling*synapseinput+extfirepotential(:,indframe);
    duspike = refractoryfac.*temp1;
    u = u+duleak+duspike;
    isfire = u>Ufire;
    spiketrain(:,indframe) = isfire;
    u(isfire) = Ufire;
    potentialprofile(:,indframe) = u;
    %we will reset the voltage of firing neuron immediately after
    %calculating the average potential
    avgvoltage(indframe) = mean(u);
    u(isfire) = Ureboot;
    refractorycount(isfire) = refractoryframe;
    
        
end

%The external input is quite random as can be seen from Fig 1
figure(1)
imagesc(extfirepotential);
ylabel('cell index');
xlabel('time');
title('input stream of all sensory neurons');
%The response of the network is synchronized with uniform periodicity
figure(2)
imagesc(spiketrain);
ylabel('cell index');
xlabel('time');
title('spike train of all cells')





