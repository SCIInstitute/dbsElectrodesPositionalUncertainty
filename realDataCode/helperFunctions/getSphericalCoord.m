function [phiW,thetaW] = getSphericalCoord(w)

% Get angle in degrees between w and +ve Z axis for phi. Find angle between
% projection of w on xy plane and +ve x axis for theta
phiW = getAngle(w,[0 0 1]);
thetaW  = getAngle([1 0 0],[w(1) w(2) 0]);

% If w is coming out in octants 3 or 4 (-ve Y) shown above
if w(2) < 0
    thetaW = 360 - thetaW;
end