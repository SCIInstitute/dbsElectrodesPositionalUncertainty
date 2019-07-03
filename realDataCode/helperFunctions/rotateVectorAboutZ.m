% vec: 1X3 array
% theta: angle in degrees
function dir = rotateVectorAboutZ(vec, theta)
% Rotation matrix for roation around Z

mat = [cosd(theta), -sind(theta), 0; 
            sind(theta), cosd(theta), 0;
            0,  0,  1];
dir = (mat*vec')';