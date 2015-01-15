%% showMap shows arena with zones
% Requirements: Should have 'ZONE.mat' file in working directory
function showMap()
% check if ZONE.mat exists or not in working directory

    figure;
    % load ZONE data from working directory
    load('CONST_DATA.mat');
    for s=1:1:size(ZONE,1)
        line([ZONE(s,1) ZONE(s,3)],[ZONE(s,2) ZONE(s,2)],'Marker','.','LineStyle',':','Color',[0,1,0])
        line([ZONE(s,3) ZONE(s,3)],[ZONE(s,2) ZONE(s,4)],'Marker','.','LineStyle',':','Color',[0,1,0])
        line([ZONE(s,3) ZONE(s,1)],[ZONE(s,4) ZONE(s,4)],'Marker','.','LineStyle',':','Color',[0,1,0])
        line([ZONE(s,1) ZONE(s,1)],[ZONE(s,4) ZONE(s,2)],'Marker','.','LineStyle',':','Color',[0,1,0])
        text((ZONE(s,1)+ZONE(s,3))/2,(ZONE(s,2)+ZONE(s,4))/2 , num2str(s), 'VerticalAlignment','bottom', ...
            'HorizontalAlignment','right')
    end

end