clear
clc

% %dataPath% = Path to where Data files are present
dataPath = 'C:\Users\sulman.baig\Documents\DATA\50-100\';
% %dataFiles% = get name of all files in given %dataPath%
dataFiles = dir(strcat(dataPath,'*.dat'));
% %importFileData% = import data of first file
[TimeStamp,IDx,Xi,Yi] = importFileData(strcat(dataPath,dataFiles(1).name));

%%

% %ZONES4ALL% gets zones for all Xi and Yi values
ZONES4ALL = zoneAllXY(Xi, Yi);

%%

