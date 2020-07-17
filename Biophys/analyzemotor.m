% This was a script written to take an input file filled with trajectories of molecular motors (harvested by a professor-written
% script) and calculate some statistical quantities from the data.

data_all = cell(1,5);


for k = 1:5
    load(['/home/brvischer/Documents/School/PH591/miniproj_3/movies/alltrajectories',num2str(k)])
    data_all{k} = alltrajs{1};
end

d_perp = zeros(5,2000);

for set = 1:5
    data = data_all{set};
    data_x = data(:,1) - data(1,1);
    data_y = data(:,2) - data(1,2);

    displ = [data_x(end), data_y(end)];
    direc = displ/norm(displ);

    d_par(set,:) = (direc*[data_x';data_y'])';
end

% make hist and find step sizes from there

nbins = 100;
pks_total = {};
locs_total = {};
counts = zeros(5,100);
for num = 1:5
    h = histogram(d_par(num,:), nbins);
    counts(num,:) = h.Values;
    [pks, locs] = findpeaks(counts(num,:));%, ...
    %'MinPeakProminence', 1) %'Threshold', 10);
    pks_total{num} =  pks;
    locs_total{num} = locs*h.BinWidth; % want distance rather than bin number
end
steps = {};
for set = 1:5
    locs = locs_total{set};
    steps{set} = diff(locs);
end
steps_all = steps{:};
