%% zonesAllXY calculates all zones for given x and y values
% @params:  Xi => array containing x values
%           Yi => array containing y values
% @return:  zonesAll => same size of input Xi and gives corresponding zone
%           numbers to the xy values
function zonesAll = zoneAllXY(Xi, Yi, ZONE)
% % check if ZONE.mat exists or not in working directory
% if(exist('CONST_DATA.mat','file') ~= 2)
%     zoneAll = -1;
%     error('ZONE.mat File could not be found in working directory of MATLAB');
% else
%     % load ZONE data from working directory
%     load('ZONE.mat');
    zonesAll = zeros(length(Xi),1);
    for s=1:1:length(Xi)
        % calling to findZone that calculates zone for just one xy
        % value
        zonesAll(s,1) = findZone(Xi(s),Yi(s),ZONE);
    end
end
% end