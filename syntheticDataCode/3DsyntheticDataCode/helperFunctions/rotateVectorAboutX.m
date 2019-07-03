% vec: 1X3 array
% theta: angle in degrees
function dir = rotateVectorAboutX(vec, theta)
% Rotation matrix for roation around X

mat = [1, 0,0; 
            0,cosd(theta),-sind(theta);
            0, sind(theta), cosd(theta)];
dir = (mat*vec')';