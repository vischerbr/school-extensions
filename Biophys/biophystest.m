ontimes = csvread('dataon.csv');
offtimes = csvread('dataoff.csv');

ontimes_sorted = sort(ontimes);

distrange = 0:max(ontimes)-1;
%distrange = unique(ontimes_sorted);
dist = zeros(1,max(ontimes));
for element =1:max(ontimes_sorted)
    counter = 0;
    for dtime = 1:length(ontimes)
       if element <= ontimes_sorted(dtime)
          counter = counter +1;
       end
    end

    dist(element) = counter/size(ontimes,2);
end


offtimes_sorted = sort(offtimes);

distrangeoff = 0:max(offtimes)-1;
%distrangeoff = unique(offtimes_sorted);
distoff = zeros(1,max(offtimes));
for element =1:max(offtimes_sorted)
    counter = 0;
    for dtime = 1:length(offtimes)
       if element <= offtimes_sorted(dtime)
          counter = counter +1;
       end
    end

    distoff(element) = counter/size(offtimes,2);
end

% offtimes_sorted = sort(offtimes);
% distrangeoff = 1:max(offtimes);
% distoff = zeros(1,max(offtimes));
% for element =1:length(offtimes_sorted)
%     counter = 0;
%     for dtime = 1:length(offtimes)
%        if offtimes_sorted(element)< offtimes_sorted(dtime)
%           counter = counter +1;
%        end
%     end
%     dwell = uint8(offtimes_sorted(element));
%     distoff(dwell) = counter/size(offtimes,2);
% end