%% testTrajectory tests the trajectory for the estimated emotion
% @params:  filePath => path of folder where trajectory files are present
%           fileNumber => which file number in which particular file is
%           present
%           idNumber => id of trajectory to get tested in particular file
% @return:  GammaP => gamma positive for the trajectory to be tested
%           GammaN => gamma negative for the trajectory to be tested
%           logAnsgamma => log difference between GammaP and GammaN
function [GammaP,GammaN,logAnsGamma] = testTrajectory(filePath, fileNumber, idNumber)
% load the learned data from the directory
load('VAR_DATA.mat');
load('CONST_DATA.mat');
% calculate the normalized data from the learned data
[TRANSITION_P_NORM,DELTAT_P_NORM]=normalizeTransitionAndDelta(TRANSITION_P,DELTAT_P);
[TRANSITION_N_NORM,DELTAT_N_NORM]=normalizeTransitionAndDelta(TRANSITION_N,DELTAT_N);
% get the file data from the path and number given as input to the function
dataPath = strcat(filePath,'\');
dataFiles = dir(strcat(dataPath,'*.dat'));
[TimeStamp,IDx,Xi,Yi] = importFileData(strcat(dataPath,dataFiles(fileNumber).name));
% get the zones from the data file
Zones = zoneAllXY(Xi, Yi, ZONE);
% search for the id in the file given as input 
index = find(IDx == idNumber);
% search for the zones for the particular id given as input
zoneId = Zones(index);
% get the zone changing points and their time stamps for the change
[changeZoneId, indexChangeZone] = unique(zoneId,'stable');
% remove out of zones elements in the trajectory
indexChangeZone(changeZoneId==0) = [];
changeZoneId(changeZoneId==0) = [];
% %time4Trajectory% = all times of particular id
time4Trajectory = TimeStamp(index);
% %timeChangerPoints% = times when particular trajectory changed zones
timeChangerPoints = time4Trajectory(indexChangeZone);
% %changeTime% = time particular id spent in particular zone
changeTime = diff(timeChangerPoints,1);
% %quantizedTime% has the changing time zone according to the quantization
% data
quantizedTime = zeros(size(changeTime));
for a=1:1:length(changeTime)
    quantizedTime(a,1) = find(QUANTIZATION<=changeTime(a,1),1,'last');
end
% calculate the GammaP for all the zones of the particular trajectory
% Gamma(theta,0) = p(Zone0|theta).p(theta)
GammaP = zeros(size(changeZoneId));
GammaP(1,1) = (1/183)*(1/2);
GammaN = zeros(size(changeZoneId));
GammaN(1,1) = (1/183)*(1/2);
% Gamma(theta,zones(n)) = TRANSITION_NORM(zones(n-1),zones(n)) .
%                         DELTA_NORM(zones(n-1),zones(n),time) .
%                         Gamma(theta,zones(n-1)
for a=2:1:length(changeZoneId)
    GammaN(a,1) = TRANSITION_N_NORM(changeZoneId(a-1,1),changeZoneId(a,1)) * DELTAT_N_NORM(changeZoneId(a-1,1),changeZoneId(a,1),quantizedTime(a-1,1)) * GammaN(a-1,1);
     GammaP(a,1) = TRANSITION_P_NORM(changeZoneId(a-1,1),changeZoneId(a,1)) * DELTAT_P_NORM(changeZoneId(a-1,1),changeZoneId(a,1),quantizedTime(a-1,1)) * GammaP(a-1,1);
end
% %logAnsGamma% = calculate the log difference of GammaP and GammaN
logAnsGamma = GammaP./(GammaN+GammaP);
end