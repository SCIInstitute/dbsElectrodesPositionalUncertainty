function [phiD,thetaD] = getSphericalAnglesD(phiW,thetaW)

% W in octants corresponding to +ve Z axis
if phiW <= 90
    phiD = 90-phiW;
% W in octants corresponding to -ve Z axis
elseif phiW > 90 && phiW <=180
    phiD = 270-phiW;
else
    disp('Invalid angle');
end

% W in octants corresponding to +ve Y axis
if thetaW <= 180
    thetaD = 180+thetaW;
% W in octants corresponding to -ve Y axis
elseif thetaW > 180 && thetaW <=360
    thetaD = thetaW-180;
else
    disp('Invalid angle');
end