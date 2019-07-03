% vec: 1X3 array
% theta: angle in degrees
function dir = rotateVectorAboutY(vec, theta)
% Rotation matrix for roation around Y

mat = [cosd(theta), 0, sind(theta); 
            0,     1,     0;
            -sind(theta), 0,  cosd(theta)];
dir = (mat*vec')';