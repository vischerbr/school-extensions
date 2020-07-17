% This was written to identify when a mode-switching occured where the diffusion coefficient for a particle changed, thought to be an explanation for the 
% lop-sided motion molecular motors undergo.


% Do iteration over csv, assume each csv has the same cell (i.e same
% diffusion coefficient). add all data find D from peaks in hist then do
% dwell times



for k=1:
m= csvread('anti-IgM_Fab-Cy3_PLL/Stream-1.csv');

[tracks,~] = find(m(:,2));
tracks = [1 tracks'];


passages = cell(1,size(tracks,1));


for row = 1:(length(tracks)-1) % normally loop over all the tracks
    
    first = tracks(row);
    last = tracks(row+1);
    
    data_pos = m(first+2:last-1,4:5);
    rs = sqrt(sum(data_pos.^2,2)); % find the distance at each point in the track
    % first check to see if the run is stagnant
        % if the spread of distances is small, let's toss it out
        
    check_spread = mean((data_pos(:,1)-mean(data_pos(:,1))).^2 ...
        + (data_pos(:,2)-mean(data_pos(:,2))).^2);
    
    % okay not sure how to do this yet but lets move on
    % assuming the run isn't stagnant, lets define a distance D to see
    % how long it takes the particle to move that far... for each point
    % in the trajectory
        
    D = 3.0; %?
       
    
    
    firstpassage = zeros(1,size(data_pos,1));
    
    for frame = 1:size(data_pos,1)
        % lets redefine the origin as the position at t=frame, and find how
        % long it takes the particle to leave a circle of radius D
        
        posnew = data_pos - data_pos(frame,:);
        rsnew = sqrt(sum(posnew.^2,2)); 
        [passagetimes,~] = find(rsnew(frame+1:end)>D);
        if ~isempty(passagetimes)
            firstpassage(frame) = passagetimes(1);
        else
            firstpassage(frame) = -1; % if the thing never left, set it to an obviously screwy value
        end
        
        
        
        
    end
    
    passages{row} = firstpassage;
end