% A much simpler skewed-potential explanation for the motion of molecular motors, rather than the complicated diffusion mechanism in 
% receptor-track.

totalruns = 5;

tmax = 10000;
dt = .01;

a=.002;
b=.006;

D= .1; % \mu m^2/s
gamma = .2/dt;
eta = 1;
fmax = 20;

phase = randi([0 1]);
phases = zeros(fmax,totalruns, tmax);
Fs = zeros(fmax,totalruns, tmax);
xs = zeros(fmax,totalruns,tmax);

for fs = 1:fmax
F1 = -.002*fs; % -.01
F2 = -a/b*F1;




for n=1:totalruns
    fs,n
    for t=2:tmax
        check = dt*gamma;
        if check<rand(1)
            phase = ~phase;
        end
    
    % lets calculate the force to use, if in phase 1
    if xs(fs,n,t-1)>0
        if mod(xs(fs,n,t-1), a+b)< a
            F=F1;
        elseif mod(xs(fs,n,t-1), a+b)> a
            F=F2;
        else
            F=0;
        end
    elseif xs(fs,n,t-1)<=0
        if mod(xs(fs,n,t-1),-a-b)> -b
            F=F2;
        elseif (mod(xs(fs,n,t-1), -a-b)<-b)
            F=F1;
        else
            F=0;
        end
    end 
    % if phase = 1, we're in the excited state
    if phase
        dx = normrnd(dt*F*gamma, 2*D*dt);
    else
        dx = normrnd(0, 2*D*dt);
    end
    
    phases(fs,n,t) = phase;
    Fs(fs,n,t) = F;
    xs(fs,n,t) = xs(fs,n,t-1)+dx;
        
    end
end
end

