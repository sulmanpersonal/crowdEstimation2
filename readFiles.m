%% readFiles read all trajectory files provided the path
% @params:  Path => path of folder where trajectory files are present
%           numberOfFilesToRead =>  how many files from the folder to read
%           clearPreviousData =>    true => if want to clear previous data
%                                   false => if want to keep previous data
% @return:  TRANSITION_P 183x183 =>  number of transitions by +ve trajectories in total
%                                    time of simulation => zone(n-1) x zone(n)
%           TRANSITION_N 183x183 =>  number of transitions by -ve trajectories in total
%                                    time of simulation => zone(n-1) x zone(n)
%           DELTAT_P 183x183x162 =>  number of transitions by +ve trajectories in
%                                    particular time => zone(n-1) x zone(n) x time(quantized)
%           DELTAT_N 183x183x162 =>  number of transitions by -ve trajectories in
%                                    particular time => zone(n-1) x zone(n) x time(quantized)
function [TRANSITION_P,TRANSITION_N,DELTAT_P,DELTAT_N]=readFiles(Path,numberOfFilesToRead,clearPreviousData)

% %CONST_DATA.mat% =>   QUANTIZATION 162x1 => this contain the ranges of time quantized over 0:6000 stamps
%                       ZONE 183x4 => contains 4 points of rectangle for each zone boundry in x-y plane.
%                       POS_ZONE 12x1 => contains the zone which are
%                       indication for trajectory to be positive.
load('CONST_DATA.mat');
if clearPreviousData
    TRANSITION_P = zeros(length(ZONE),length(ZONE));
    TRANSITION_N = zeros(length(ZONE),length(ZONE));
    DELTAT_P = zeros(length(ZONE),length(ZONE),length(QUANTIZATION));
    DELTAT_N = zeros(length(ZONE),length(ZONE),length(QUANTIZATION));
else
    % %VAR_DATA.mat% =>     TRANSITION_P 183x183 =>  number of transitions by +ve trajectories in total
    %                                    time of simulation => zone(n-1) x zone(n)
    %                       TRANSITION_N 183x183 =>  number of transitions by -ve trajectories in total
    %                                    time of simulation => zone(n-1) x zone(n)
    %                       DELTAT_P 183x183x162 =>  number of transitions by +ve trajectories in
    %                                    particular time => zone(n-1) x zone(n) x time(quantized)
    %                       DELTAT_N 183x183x162 =>  number of transitions by -ve trajectories in
    %                                    particular time => zone(n-1) x zone(n) x time(quantized)
    load('VAR_DATA.mat');
end
% %dataPath% = Path to where Data files are present
dataPath = strcat(Path,'\');
% %dataFiles% = get name of all files in given %dataPath%
dataFiles = dir(strcat(dataPath,'*.dat'));

for a = 1:1:numberOfFilesToRead
    % %importFileData% = import data of first file
    [TimeStamp,IDx,Xi,Yi] = importFileData(strcat(dataPath,dataFiles(a).name));
    % %Zones% gets zones for all Xi and Yi values
    Zones = zoneAllXY(Xi, Yi, ZONE);
    
    for b = min(IDx):1:max(IDx)
        % %index% = places where samples have data for 85 number zone
        index = find(IDx == b);
        % %zoneId% = zones trajectory for a particular id
        zoneId = Zones(index);
        % %changeZoneId% = zones without repetition of specific trajectory
        % %indexChangeZone% = value of timestamp depending upon the x index number
        [changeZoneId, indexChangeZone] = unique(zoneId,'stable');
        % %time4Trajectory% = all times of particular id
        time4Trajectory = TimeStamp(index);
        % %timeChangerPoints% = times when particular trajectory changed zones
        timeChangerPoints = time4Trajectory(indexChangeZone);
        % %changeTime% = time particular id spent in particular zone
        changeTime = diff(timeChangerPoints,1);
        
        % %flagPositive% =  flag to check if trajectory to be positive or not
        %                   false => trajectory is -ve
        %                   true => trajectory is +ve
        flagPositive = checkPositiveTrajectory(POS_ZONE,changeZoneId);
        
        if flagPositive
            [TRANSITION_P,DELTAT_P] = populateVarData(TRANSITION_P,DELTAT_P,changeZoneId,QUANTIZATION,changeTime);
        else
            [TRANSITION_N,DELTAT_N] = populateVarData(TRANSITION_N,DELTAT_N,changeZoneId,QUANTIZATION,changeTime);
        end
    end
end
save('VAR_DATA.mat','TRANSITION_P','TRANSITION_N','DELTAT_P','DELTAT_N');
end