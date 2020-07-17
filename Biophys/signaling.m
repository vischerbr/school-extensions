% An initial pass at an enzyme kinetics problem where a single enzyme and a catalyzing agent generate a product.

tmax = 4000;
dt = .01;

runs = 1000;
samples = 10;

k_1s = .1+.02*rand(runs,samples);
k_2s = .80+.02*rand(runs,samples);
k_3s = .49+.02*rand(runs,samples);
k_4s = .09+.02*rand(runs,samples);
k_5s = .49+.02*rand(runs,samples);
k_6s = .09+.02*rand(runs,samples);
k_7s = .49+.02*rand(runs,samples);
m_1s = .49+.02*rand(runs,samples);
m_2s = .49+.02*rand(runs,samples);
Et = 1;

Ss = linspace(0,1,runs);

R = zeros(runs, tmax-1);
Ep = zeros(runs, tmax-1);
X = zeros(runs, tmax-1);
dRs = zeros(runs, tmax-1);
dEps = zeros(runs, tmax-1);
dXs = zeros(runs, tmax-1);

sampled_r = zeros(runs, tmax);
sampled_ep = zeros(runs, tmax);
sampled_x = zeros(runs, tmax);
sampled_drs = zeros(runs, tmax);
sampled_deps = zeros(runs, tmax);



R(:,1) = .5;
Ep(:,1) = .5;
X(:,1) = .1;
dRs(:,1) = 0;
dEps(:,1) = 0;
dXs(:,1) = 0;

proj = 0;

for run=1:runs
    run
    k_1 = k_1s(run);
    k_2 = k_2s(run);
    k_3 = k_3s(run);
    k_4 = k_4s(run);
    k_5 = k_5s(run); 
    k_6 = k_6s(run);
    k_7 = k_7s(run);
    m_1 = m_1s(run);
    m_2 = m_2s(run);
    
    
    for sample=1:samples
        k_1 = k_1s(run,sample);
        k_2 = k_2s(run,sample);
        k_3 = k_3s(run,sample);
        k_4 = k_4s(run,sample);
        k_5 = k_5s(run,sample);
        k_6 = k_6s(run,sample);
        k_7 = k_7s(run,sample);
        m_1 = m_1s(run,sample);
        m_2 = m_2s(run,sample);
        
        for time=2:tmax
          
            switch proj
                case 0
                    dR = dt*(k_1*Ss(run)- k_2*(Et - Ep(run, time-1))*R(run,time-1));
                    dEp = dt*(k_3*R(run, time-1)*(Et-Ep(run, time-1))/(Et-Ep(run, time-1)+m_1)...
                    - k_4*Ep(run, time-1)/(Ep(run, time-1)+m_2));
                    dX = 0;
                case 1
                    dR = dt*(k_1*Ss(run)+ k_5*Ep(run, time-1) - k_2*(X(run, time-1))*R(run,time-1));
                    dEp = dt*(k_3*R(run, time-1)*(Et-Ep(run, time-1))/(Et - Ep(run, time-1) + m_1) ...
                        - k_4*Ep(run, time-1)/(Ep(run, time-1) + m_2));
                    dX = dt*(-k_6*X(run, time-1) + k_7*R(run, time-1));
                    % finish me
            end

            R(run, time) = R(run, time-1) + dR;
            Ep(run,time) = Ep(run,time-1) + dEp;
            X(run, time) = X(run, time-1) + dX;
            
            dRs(run,time) = dR;
            dEps(run,time) = dEp;
            dXs(run, time) = dX;
        end
        sampled_r(run,:) = (sampled_r(run,:) +R(run,:))/2;
        sampled_ep(run,:) = (sampled_ep(run,:) +Ep(run,:))/2;
        sampled_x(run, :) = (sampled_x(run,:) + X(run, :))/2;
        sampled_drs(run,:) = (sampled_drs(run,:) +dRs(run,:))/2;
        sampled_deps(run,:) = (sampled_deps(run,:) +dEps(run,:))/2;
    end
end


% cmap = jet(20);
% for k=1:20
% plot(sampled_ep(50*k,:), 'Color', [cmap(k,:)])
% hold on;
% end
% title({'E_p versus time for several S values'},'FontSize', 20)
% xlabel({'Time (a.u)'}, 'FontSize', 16)
% ylabel({'Concentration'},'FontSize', 16)
