%% findZone finds the zone of given x and y values
% @params:  x => x value of point of trajectory
%           y => y value of point of trajectory
%           ZONE => ZONE array having data of all zones of arena with 4
%           points of rectangular zone
% @return:  ZoneNumber => a number containing the number of zone where x
%           and y values reside.
function ZoneNumber = findZone(x,y,ZONE)
ZoneNumber = 0;
for s = 1:1:183
    if(x>ZONE(s,1) && x<=ZONE(s,3) && y>ZONE(s,2) && y<=ZONE(s,4))
        ZoneNumber = s;
        break;
    end
end
end