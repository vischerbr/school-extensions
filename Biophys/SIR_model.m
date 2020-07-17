% A topical exploration of the SIR model, in which susceptible people become infected at a rate that depends on the number of infected - 
% and infected become recovered at a constant rate.

 dt = .01;
k=3;
r=1;
tmax = 1000; % steps

pops=10;

plt=1;

S0s = ones(pops,1)*.9;
I0s = 1/pops*(1:pops); 


Ss = zeros(pops,tmax);
Is = zeros(pops,tmax);

dSs = zeros(pops,tmax);
dIs = zeros(pops,tmax);

Ss(:,1) = S0s;
Is(:,1) = I0s;



%all_S = cell()
for nS = 1:pops
    for t=2:tmax
            
       dS = dt*(-1*k*Is(nS,t-1)*Ss(nS,t-1));
       dI = dt*(Is(nS,t-1)*(k*Ss(nS,t-1) - r)); 
       
       dSs(nS,t) = dS;
       dIs(nS,t) = dI;
       
       Ss(nS,t) = Ss(nS,t-1) +dS;
       Is(nS,t) = Is(nS,t-1) +dI;
       
    end
end

%Sdot = -k*I*S;
%Idot = k*I*S - r*I
%Rdot = r*I


% ORBITS

dorbits = dIs./dSs;

orbits = zeros(pops,tmax-1);
todel = logical(zeros(pops,tmax-1));
for indorb = 1:pops
    orbits(indorb,:) = cumtrapz(Ss(indorb,2:end), dorbits(indorb, 2:end));
    todel(indorb,:) = orbits(indorb,:)<0;
    orbits(todel) = 0;
end



% PLOTTING

if plt
    f = figure(200);
    hold on;
    for ind1 = 1:pops
        scatter(Ss(ind1,:), Is(ind1,:), 8)
    end
    hold off;
   
    g = figure(300);
    hold on;
     for ind2 = 1:pops
        plot(orbits(ind2,~todel(ind2,:)), 'LineWidth', 4)
     end
    %xlim([0,find(orbits(1,:),1, 'last')]);
end
    
    
