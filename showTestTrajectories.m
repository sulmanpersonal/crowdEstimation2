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
    
    preZone = ones(100,1)*(-1);
    preTime = ones(100,1)*(-1);
    preprobP = ones(100,1)*(-1);
    preprobN = ones(100,1)*(-1);
    
    for a=min(TimeStamp):1:max(TimeStamp)
        hold on;
        tIndex = find(TimeStamp == a);
        xtemp = Xi(tIndex);
        ytemp = Yi(tIndex);
        idTemp = IDx(tIndex);
        zTemp = Zones(tIndex);
        for b=1:1:length(idTemp)
            c = idTemp(b);
            if zTemp(b)==0
                continue;
            else
                if preZone(c)==-1
                    preZone(c)=zTemp(b);
                    preTime(c)=a;
                    preprobP(c)=(1/183)*(1/2);
                    preprobP(c)=(1/183)*(1/2);
                else
                    if zTemp(b)~= preZone(c)
                        postTime = a-preTime(c);
                        postTime = find(QUANTIZATION<=postTime,1,'last');
                        preprobN(c) = TRANSITION_N_NORM(preZone(c),zTemp(b)) * DELTAT_N_NORM(preZone(c),zTemp(b),postTime) * preprobN(c);
                        preprobP(c) = TRANSITION_P_NORM(preZone(c),zTemp(b)) * DELTAT_P_NORM(preZone(c),zTemp(b),postTime) * preprobP(c);
                        colorvalue = preprobP/(preprobP+preprobN);
                        preZone(c)=zTemp(b);
                        preTime(c)=a;
                        if colorvalue
                            colorR = 1;
                            colorG = 1;
                        elseif colorvalue<0.5
                            colorR = 1;
                            colorG = colorvalue*2;
                        else
                            colorR = (colorvalue*2)-0.2;
                            colorG = 1;
                        end
                    end
                end
            end
            scatter(xtemp(b),ytemp(b),'.','MarkerEdgeColor',[1 1 0]);
        end
        
        hold off;
    end
    
    
end