function showTestTrajectories(filePath,fileNumber)
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
    
    showMap();
    
    
    for a=min(TimeStamp):1:max(TimeStamp)
        hold on;
        tIndex = find(TimeStamp == a);
        xtemp = Xi(tIndex);
        ytemp = Yi(tIndex);
        scatter(xtemp,ytemp,'.');
        hold off;
    end
    
    
end