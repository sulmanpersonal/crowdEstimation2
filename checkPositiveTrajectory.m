%% checkPosiveTrajectory checks if the particular trajectory is positive or negative
% @params:  POS_ZONE => array containing the data for which zones are
%           positive
%           zones => the data of zones for the particular trajectory
% @return:  flagPositive => flag to check if trajectory to be positive or not
%                           false => trajectory is -ve
%                           true => trajectory is +ve
function flagPositive = checkPositiveTrajectory(positiveZones,zones)
flagPositive = false;
% %a% = iterator to find any of the positive zones from trajectory
%       transitions
for a=1:1:length(positiveZones)
    % check if any of the positive zones is found in trajectory
    if(~isempty(find(zones == positiveZones(a,1),1)))
        flagPositive = true;
        break;
    end
end
end