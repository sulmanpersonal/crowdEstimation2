clear
clc
load('VAR_DATA.mat');
load('CONST_DATA.mat');
[TRANSITION_P_NORM,DELTAT_P_NORM]=normalizeTransitionAndDelta(TRANSITION_P,DELTAT_P);
[TRANSITION_N_NORM,DELTAT_N_NORM]=normalizeTransitionAndDelta(TRANSITION_N,DELTAT_N);

clearvars DELTAT_N DELTAT_P TRANSITION_P TRANSITION_N

% read first File from the path provided
dataPath = strcat('C:\Users\sulman.baig\Documents\DATA\1-50','\');
dataFiles = dir(strcat(dataPath,'*.dat'));
[TimeStamp,IDx,Xi,Yi] = importFileData(strcat(dataPath,dataFiles(1).name));
% %Zones% gets zones for all Xi and Yi values
Zones = zoneAllXY(Xi, Yi, ZONE);
% %index% = places where samples have data for 85 number zone
index = find(IDx == 97);
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

quantizedTime = zeros(size(changeTime));
for a=1:1:length(changeTime)
    quantizedTime(a,1) = find(QUANTIZATION<=changeTime(a,1),1,'last');
end

flagPositive = checkPositiveTrajectory(POS_ZONE,changeZoneId);

clearvars dataPath dataFiles Xi Yi TimeStamp Zones index zoneId indexChangeZone
clearvars time4Trajectory timeChangerPoints IDx

GammaP = zeros(size(changeZoneId));
GammaP(1,1) = (1/183)*(1/2);
GammaN = zeros(size(changeZoneId));
GammaN(1,1) = (1/183)*(1/2);
for a=2:1:length(changeZoneId)
    GammaN(a,1) = TRANSITION_N_NORM(changeZoneId(a-1,1),changeZoneId(a,1)) * DELTAT_N_NORM(changeZoneId(a-1,1),changeZoneId(a,1),quantizedTime(a-1,1)) * GammaN(a-1,1);
     GammaP(a,1) = TRANSITION_P_NORM(changeZoneId(a-1,1),changeZoneId(a,1)) * DELTAT_P_NORM(changeZoneId(a-1,1),changeZoneId(a,1),quantizedTime(a-1,1)) * GammaP(a-1,1);

end


clearvars a POS_ZONE ZONE QUANTIZATION changeTime