%% populateVarData populate the Transition and Delta matrices according to files data obtained
% @params:  Transition => TRANSITION_P / TRANSITION_N matrix to edit
%           Transition data according to the trajectory
%           Delta => DELTAT_P / DELTAT_N matrix to edit the transition time
%           according to the trajectory
%           zones => the data of zones for the particular trajectory
%           QuanArray => the array that have the quantization of time data
%           changeZoneTime => the data of transition of zones in time by
%           particular trajectory
% @return:  Transition => TRANSITION_P / TRANSITION_N matrix to edit
%           Transition data according to the trajectory
%           Delta => DELTAT_P / DELTAT_N matrix to edit the transition time
%           according to the trajectory
function [Transition,Delta] = populateVarData(Transition,Delta,zones,QuanArray,changeZoneTime)
for a=2:1:length(zones)
    curr = a;
    pre = a-1;
    if(zones(a)==0) % if current zone is 0 that means trajectory is away from zones defined
        continue;
    elseif(zones(a-1)==0 && a==2)   % if first zone in trajectory is 0
        continue;
    elseif(zones(a-1)==0 && zones(a-2)~=0)  %if some other previous zone other than first zone is 0
        pre = a-2;
    end
    % %quantizedTime% = time of trajectory is converted according to the
    % quantization time of all trajectories
    quantizedTime = find(QuanArray<=changeZoneTime(pre,1),1,'last');
    % update Transition matrix
    Transition(zones(pre,1),zones(curr,1)) = Transition(zones(pre,1),zones(curr,1)) + 1;
    % update Delta matrix
    Delta(zones(pre,1),zones(curr,1),quantizedTime) = Delta(zones(pre,1),zones(curr,1),quantizedTime) + 1;
end
end