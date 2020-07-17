% This is a toned-down version of neural_net that doesn't bother with color, but instead iterates through serveral different neuron counts
% to identify if there is a critical number of neruons to recover images at a particular tolerance.

neuron_counts = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100].^2;
beta = 10;
tmax = 7;
tol = .1;

fnames = dir('/home/brvischer/Documents/School/PH591/Major2/img*');
names = {fnames.name};
num_ims = 1:length(names);
%old ints are:   ints = [.5,.55,.6,.6,.67,.6,.3,.8];

ints= [.5,.55,.55,.3,.5,.6,.5,.8];
num_runs = length(names);
memories = zeros(length(names),length(neuron_counts));
mapdelta = zeros(length(names),length(neuron_counts));
samples = 10;

for indnn = 1:length(neuron_counts)
    nneurons = neuron_counts(indnn);
    connectionr = zeros(nneurons,nneurons);
    
    nsquare = round(sqrt(nneurons));
    vals = [1,-1];
    
    
    for indimg=1:length(num_ims)
        imname = names{indimg};
        img = imresize(imread(imname), [nsquare nsquare]);
        imgtemp = 2*im2bw(img,ints(indimg))-    1;
        [~,name,~] = fileparts(imname);
        if ~exist(['mats',filesep,'img',num2str(indimg),'_nn_',num2str(indnn), '.mat'])
            for idx=1:nneurons
                for jdx=1:nneurons
                    connectionr(idx,jdx) =imgtemp(idx)*imgtemp(jdx);%+(img2r(idx)*img2r(jdx)));%/nneurons;;%/nneurons;
                end
            end
            save(['mats',filesep,'img',num2str(indimg),'_nn_',num2str(indnn), '.mat'], 'connectionr')
            %, 'connectiong', 'connectionb')
        else
            load(['mats',filesep,'img',num2str(indimg),'_nn_',num2str(indnn), '.mat'])
        end
        
    end
    
    for run=1:num_runs
        for sample=1:samples
        %foldername = ['test', num2str(indnn)];
        %mkdir(foldername);
        nneurons = neuron_counts(indnn);        
        nsquare = round(sqrt(nneurons));
        vals = [1,-1];
        
        
        
        
            connectionr = zeros(nneurons, nneurons);
            spinsr= vals(randi([1,2],[nneurons,1]));
            map = reshape(spinsr,[nsquare nsquare]);
            figure(100)
            imshow(map)
            
            
            %run
            num_im = num_ims(run);
            %         for indimg=1:num_im
            %             imname = names{indimg};
            %             img = imresize(imread(imname), [nsquare nsquare]);
            %             imgtemp = 2*im2bw(img,ints(indimg))-1;
            %             [~,name,~] = fileparts(imname);
            %             if ~exist(['mats',filesep,name,'_',num2str(indnn), '.mat'])
            %             for idx=1:nneurons
            %                 for jdx=1:nneurons
            %                     connectionr(idx,jdx) =(num_im-1)*connectionr(idx,jdx) + imgtemp(idx)*imgtemp(jdx);%+(img2r(idx)*img2r(jdx)));%/nneurons;;%/nneurons;
            %                 end
            %             end
            %             save(['mats',filesep,name,'_nn',num2str(indnn),' '.mat'], 'connectionr')%, 'connectiong', 'connectionb')
            %             else
            %             load(['mats',filesep,name,'_nn',num2str(indnn),'_numim',num2str(num_im), '.mat'])
            %             end
            %
            %         end
            %         connectionr = connectionr/num_im;
            
            
            
            
            
            if ~exist(['mats',filesep,'meld1-',num2str(run),'_nn_',num2str(indnn), '.mat'])
                for indimgmeld = 1:run
                    connectiontempstr = load(['mats',filesep,'img',num2str(indimgmeld),'_nn_',num2str(indnn), '.mat']);
                    connectiontemp = connectiontempstr.connectionr;
                    connectionr = connectionr + connectiontemp;
                   
                end
                
                connectionr = connectionr/run;
                connectionr(1,1)
                save(['mats',filesep,'meld1-',num2str(run),'_nn_',num2str(indnn), '.mat'], 'connectionr')%, 'connectiong', 'connectionb')
            else
                load(['mats',filesep,'meld1-',num2str(run),'_nn_',num2str(indnn), '.mat'])
            end
            
            
            
            
            
            % train the connections with an input, right now hardcoded.
            % +1 is white, -1 is black.
            
            
            
            %lets loop over time now
            
            for time = 1:tmax
                %time
                for indn=1:nneurons
                    
                    hnowr = spinsr*connectionr(indn,:)'/nneurons;
                    %         hnowg = spinsg*connectiong(indn,:)'/nneurons;
                    %         hnowb = spinsb*connectionb(indn,:)'/nneurons;
                    check = rand(1);
                    
                    % Check for red transitions
                    if spinsr(indn) == 1
                        transitionp = .5*(1+tanh(-beta*hnowr));
                        if transitionp>check
                            spinsr(indn) = -spinsr(indn);
                        end
                    elseif spinsr(indn)==-1
                        transitionp = .5*(1+tanh(beta*hnowr));
                        if transitionp>check
                            spinsr(indn) = -spinsr(indn);
                        end
                        
                    end
                    % check for green transitions
                    %         check = rand(1);
                    %         if spinsg(indn) == 1
                    %             transitionp = .5*(1+tanh(-beta*hnowg));
                    %             if transitionp>check
                    %                 spinsg(indn) = -spinsg(indn);
                    %             end
                    %         elseif spinsg(indn)==-1
                    %             transitionp = .5*(1+tanh(beta*hnowg));
                    %             if transitionp>check
                    %                 spinsg(indn) = -spinsg(indn);
                    %             end
                    %         end
                    %
                    %         %check for blue transitions
                    %         check = rand(1);
                    %         if spinsb(indn) == 1
                    %             transitionp = .5*(1+tanh(-beta*hnowb));
                    %             if transitionp>check
                    %                 spinsb(indn) = -spinsb(indn);
                    %             end
                    %         elseif spinsb(indn)==-1
                    %             transitionp = .5*(1+tanh(beta*hnowb));
                    %             if transitionp>check
                    %                 spinsb(indn) = -spinsb(indn);
                    %             end
                    %         end
                    %         mapr(indn) = spinsr(indn);
                    %         mapg(indn) = spinsg(indn);
                    %         mapb(indn) = spinsb(indn);
                    %
                    map(indn) = spinsr(indn);
                    
                end
                
                if time == tmax-1
                    testmap1 = map;
                elseif time==tmax
                    testmap2 = map;
                end
                
                
                %     map(:,:,1) = mapr;
                %     map(:,:,2) = mapg;
                %     map(:,:,3) = mapb;
                map = (map+1)*127;
                % figure(time)
                
                
                imshow(map)
                
                %print([foldername,filesep,'img_test',num2str(time)], '-dpng')
            end
            % Check to see whether the image settled down at a fixed point
            
            % FIXME: this needs to be altered. The hybrid fixed point the system
            % finds are wrong, and should be culled out of the data. consider
            % trying to compare the fixed point of the system to known images? too
            % hard?
            
            
            
            mapdelta(run, indnn) = sum(sum(abs(testmap2-testmap1)));
            check_fp = zeros([nneurons,  nneurons]);
            for idx1 = 1:nneurons
                for idx2 = 1:nneurons
                    check_fp(idx1,idx2) = testmap2(idx1)*testmap2(idx2);
                end
            end
            
            
            %%% Calculate whether the sample settled on a known fixed point
            delta_check = zeros(1,num_im);
            for indim = 1:num_im
                check_now_mat = load(['mats',filesep,'img',num2str(indim),'_nn_',num2str(indnn), '.mat'],'connectionr');
                check_now = check_now_mat.connectionr;
                delta_check(indim) = sum(sum((check_now - check_fp)~=0));
            end
            %delta_check
            if sum(delta_check<.1*nneurons^2)>0
                memory_now = 1;
            else
                memory_now=0;
            end
            
            % Save whether or not the sample passed the fixed point tests
            %
                
            %if mapdelta/nneurons <=tol
            memories(run, indnn) = memories(run, indnn)+memory_now;
            %end
            clear testmap1, clear testmap2
            
        end
        print(['images',filesep,'imgf','meld',num2str(run),'_nn_',num2str(indnn)], '-dpng')
    end
    
    save(['memory_nn', num2str(indnn)], 'memories')
    %memories(:,indnn) = memories(:,indnn)/samples;
end
