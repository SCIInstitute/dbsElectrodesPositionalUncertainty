function [eL, eA1, eA2] = getElectrodeVectorsNoShaft(contactDir)

% What we know: vector w (along contact side): Infer phi and theta
% (spherical coordinates) form vector w.

% Infer vecor d(along diameter of the contact) based on the information
% above

% Infer vector d'(along diameter of the contact), which is perpendicular to
% plane formed by vector d and vector w.

%        -veX
%          |
%       3  |  2
% -veY-----|------+veY
%       4  |  1
%          |   
%        +veX
% Figure shows 4 octants for the +ve Z direction
% Similar octants exist for -ve Z direction as well
% when the vector representing the lead trajectry is coming out from octants in -Ve Z toward 3rd or 4 th octant in +ve Z through origin
% theta measurements with +ve X axis should be done carefully

% Total length of four contacts is 10.5mm
eL = [0 0 0] + (10.5/2)*(contactDir/norm(contactDir));

[phiL,thetaL] = getSphericalCoord(eL);

% get direction of vector d
% for vector d: angle with Z(vertical) axis: 90-phi, angle with X(coming
% out of paper) axis: 180-theta

% IMP note about spherical coordinates: theat (range : 0 to 2*pi): angle with positive X axis measured in clockwise
% direction. Phi (range: 0 to pi): angle with Z axis [direction which falls in valid range]

[phiA1,thetaA1] = getSphericalAnglesD(phiL,thetaL); 

%phiD = 90-phiW;
%thetaD = 180+thetaW;
r = 1.27/2;
[a1x,a1y,a1z] = getSphericalProjection(r,phiA1,thetaA1);
eA1 = [a1x,a1y,a1z];

% TO keep standard convention, i.e., +Ve W along tranjectory from contact1 to
% contact 4, +v d on its right, and +ve d' coming out of the paper. This
% will help in quick understanding of spatial limits for all 4 contacts

%d = -d;

% get +ve direction of vector d'. Since d is on right side of w, do d cross
% w
eA2 = cross(eL,eA1);
eA2 = (1.27/2)*eA2/norm(eA2);
