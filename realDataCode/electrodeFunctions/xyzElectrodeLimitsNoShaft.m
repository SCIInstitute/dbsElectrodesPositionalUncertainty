% Electorode length is 10.5 mm
function elecLims = xyzElectrodeLimitsNoShaft(electrodeCenter, eL, eA1, eA2)

% L is along lead direction (bottom to top, i.e., contact 1 to contact 4) with magnitude = 1.5/2 (length of the side of contact)
% A1 is to the right of w with magnitude of radius (1.27/2)
% A2 is cross of d and w, therefore, coming out of L- A1 plane
% centre is centre of bottom circle of contact 1

[xLow,xMax] = elecXLimits(electrodeCenter, eL, eA1, eA2);

[yLow,yMax] = elecYLimits(electrodeCenter, eL, eA1, eA2);

[zLow,zMax] = elecZLimits(electrodeCenter, eL, eA1, eA2);

elecLims = [xLow, xMax, yLow, yMax, zLow, zMax];