% This was a personal favorite of mine. In this simulation, we `train' (in the most brute force way possible using a connections matrix)
% a set of neurons to remember a black and white image. I upped the ante by adding in a few more matrices to obtain an RGB memory. Worked 
% perfectly, up to a minus sign that would invert image color and make some pretty spooky recoveries.
nneurons = 10000;

connectionr = zeros(nneurons,nneurons);
connectiong = zeros(nneurons,nneurons);
connectionb = zeros(nneurons,nneurons);

nsquare = round(sqrt(nneurons));
vals = [1,-1];
spinsr= vals(randi([1,2],[nneurons,1]));
spinsg= vals(randi([1,2],[nneurons,1]));
spinsb= vals(randi([1,2],[nneurons,1]));
beta = 2;

tmax = 10;

map = zeros(nsquare, nsquare);
map(:,:,1) = reshape(spinsr, [nsquare nsquare]);
map(:,:,2) = reshape(spinsg, [nsquare nsquare]);
map(:,:,3) = reshape(spinsb, [nsquare nsquare]);

mapr = zeros(nsquare, nsquare);
mapg = zeros(nsquare, nsquare);
mapb = zeros(nsquare, nsquare);

% lets insert an image - right now its being set to 1:1 display ratio.
% gross. add in flag for color or bw image, but for now let's play with
% color.
imname = 'pkchu';
img1 = imread('pkchu.png');
img1 = imresize(img1, [nsquare, nsquare]);

% binarize the image in each channel... looks gross, but meh

img1 = int8(img1);
img1(img1<63.5) = -1;
img1(img1>=63.5) = 1;
img1r = img1(:,:,1);
img1g = img1(:,:,2);
img1b = img1(:,:,3);

% img2 = imread('mario.jpg');
% img2 = imresize(img2, [nsquare, nsquare]);
% 
% % binarize the image in each channel... looks gross, but meh
% 
% img2 = int8(img2);
% img2(img1<63.5) = -1;
% img2(img1>=63.5) = 1;
% img2r = img2(:,:,1);
% img2g = img2(:,:,2);
% img2b = img2(:,:,3);
% 

figure(100)
imshow(map)


% train the connections with an input, right now hardcoded.
% +1 is white, -1 is black.

if ~exist([imname, '.mat'])
for idx=1:nneurons
    for jdx=1:nneurons
        connectionr(idx,jdx) = img1r(idx)*img1r(jdx);%+(img2r(idx)*img2r(jdx)));%/nneurons;;%/nneurons;
        connectiong(idx,jdx) = img1g(idx)*img1g(jdx);%+(img2g(idx)*img2g(jdx)));%/nneurons;;%/nneurons;
        connectionb(idx,jdx) = img1b(idx)*img1b(jdx);%+(img2b(idx)*img2b(jdx)));%/nneurons;;%/nneurons;
    end
end
    save([imname, '.mat'], 'connectionr', 'connectiong', 'connectionb')
else
    load([imname, '.mat'])
end


%lets loop over time now

for time = 1:tmax
    time
    for indn=1:nneurons
        
        hnowr = spinsr*connectionr(indn,:)'/nneurons;
        hnowg = spinsg*connectiong(indn,:)'/nneurons;
        hnowb = spinsb*connectionb(indn,:)'/nneurons;
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
        check = rand(1);
        if spinsg(indn) == 1
            transitionp = .5*(1+tanh(-beta*hnowg));
            if transitionp>check
                spinsg(indn) = -spinsg(indn);
            end
        elseif spinsg(indn)==-1
            transitionp = .5*(1+tanh(beta*hnowg));
            if transitionp>check
                spinsg(indn) = -spinsg(indn);
            end
        end
        
        %check for blue transitions
        check = rand(1);
        if spinsb(indn) == 1
            transitionp = .5*(1+tanh(-beta*hnowb));
            if transitionp>check
                spinsb(indn) = -spinsb(indn);
            end
        elseif spinsb(indn)==-1
            transitionp = .5*(1+tanh(beta*hnowb));
            if transitionp>check
                spinsb(indn) = -spinsb(indn);
            end
        end
        mapr(indn) = spinsr(indn);
        mapg(indn) = spinsg(indn);
        mapb(indn) = spinsb(indn);
        
        
    end
    map(:,:,1) = mapr;
    map(:,:,2) = mapg;
    map(:,:,3) = mapb;
    map = (map+1)*127;
    figure(time)
    
    imshow(map)
    print(['img_pkchu',num2str(time)], '-dpng')
end

