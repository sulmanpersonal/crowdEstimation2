clear
clc

% %dataPath% = Path to where Data files are present
dataPath = 'C:\Users\sulman.baig\Documents\DATA\50-100\';
% %dataFiles% = get name of all files in given %dataPath%
dataFiles = dir(strcat(dataPath,'*.dat'));
% %importFileData% = import data of first file
[TimeStamp,IDx,Xi,Yi] = importFileData(strcat(dataPath,dataFiles(1).name));

%%
load('CONST_DATA.mat');
% %ZONES4ALL% gets zones for all Xi and Yi values
ZONES4ALL = zoneAllXY(Xi, Yi,ZONE);

%%
% %i% = places where samples have data for 85 number zone
i = find(IDx == 42);
% %x% = zones trajectory for a particular id
x = ZONES4ALL(i);
% %z% = zones without repetition of specific trajectory
% %ia% = value of timestamp depending upon the x index number
[z, ia] = unique(x,'stable');
% %time4Trajectory% = all times of particular id
time4Trajectory = TimeStamp(i);
% %timeChangerPoints% = times when particular trajectory changed zones
timeChangerPoints = time4Trajectory(ia);
% %changeTime% = time particular id spent in particular zone
changeTime = diff(timeChangerPoints,1);


%%
% %POS_ZONE% = name of zone designated as positive
% %flagPositive% =  flag to check if trajectory to be positive or not
%                   false => trajectory is -ve
%                   true => trajectory is +ve
flagPositive = false;
% %a% = iterator to find any of the positive zones from trajectory
%       transitions
for a=1:1:length(POS_ZONE)
    if(~isempty(find(z==POS_ZONE(a,1),1)))
        flagPositive = true;
        break;
    end
end

clearvars a

%%

TRANSITION_P = zeros(length(ZONE),length(ZONE));
TRANSITION_N = zeros(length(ZONE),length(ZONE));
DELTAT_P = zeros(length(ZONE),length(ZONE),length(QUANTIZATION));
DELTAT_N = zeros(length(ZONE),length(ZONE),length(QUANTIZATION));
if flagPositive
    for a=2:1:length(z)
        curr = a;
        pre = a-1;
        if(z(a)==0)
            continue;
        elseif(z(a-1)==0 && a==2)
            continue;
        elseif(z(a-1)==0 && z(a-2)~=0)
            pre = a-2;
        end
        quantizedTime = find(QUANTIZATION<=changeTime(pre,1),1,'last');
        TRANSITION_P(z(pre,1),z(curr,1)) = TRANSITION_P(z(pre,1),z(curr,1)) + 1;
        DELTAT_P(z(pre,1),z(curr,1),quantizedTime) = DELTAT_P(z(pre,1),z(curr,1),quantizedTime) + 1;
    end
else
    for a=2:1:length(z)
        curr = a;
        pre = a-1;
        if(z(a)==0)
            continue;
        elseif(z(a-1)==0 && a==2)
            continue;
        elseif(z(a-1)==0 && z(a-2)~=0)
            pre = a-2;
        end
        quantizedTime = find(QUANTIZATION<=changeTime(pre,1),1,'last');
        TRANSITION_N(z(pre,1),z(curr,1)) = TRANSITION_N(z(pre,1),z(curr,1)) + 1;
        DELTAT_N(z(pre,1),z(curr,1),quantizedTime) = DELTAT_N(z(pre,1),z(curr,1),quantizedTime) + 1;
    end
end
save('VAR_DATA.mat','TRANSITION_P','TRANSITION_N','DELTAT_P','DELTAT_N');



