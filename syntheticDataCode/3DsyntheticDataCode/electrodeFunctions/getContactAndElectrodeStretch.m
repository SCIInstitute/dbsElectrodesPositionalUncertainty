% contactCenter: [0,0,0]
% contactDir: Direction vector for longitudinal axis of DBS lead
% sX, sY, sZ: stretch of a single contact/electrode along X, Y, and Z
% directions
% elecXNoShaft, elecYNoShaft, elecZnoShaft: Stretch of all four electrodes
% along X, Y, and Z directions without including shaft at the tail of the
% fourth electrode
% elecXWithShaft, elecYWithShaft, elecZWithShaft: Stretch of all four electrodes
% along X, Y, and Z directions with including shaft at the tail of the
% fourth electrode

function [sX, sY, sZ, elecXNoShaft, elecYNoShaft, elecZNoShaft, elecXWithShaft, elecYWithShaft, elecZWithShaft] = getContactAndElectrodeStretch(contactCenter, contactDir)

% Determine basis N={L-A1-A2} along the lead trajectory basis B = {XYZ} (Sec 3.1 in the paper)
[L, A1, A2] = getContactVectors(contactDir);

% Find limits of a contact in basis B={XYZ}
% Limits of other contacts can be obtained by adding 2*w to each coordinate
% of bounding box 
% The length of a single contact is 1.5 mm
lims = xyzLimits(contactCenter, L, A1, A2);

sX = lims(1,2) - lims(1,1);
sY = lims(1,4) - lims(1,3);
sZ = lims(1,6) - lims(1,5);

% Find the limits of the entire lead without shaft (including all 4 contacts)
% The length of all four contacts is 10.5 mm without shaft
[eL, eA1, eA2] = getElectrodeVectorsNoShaft(contactDir);
elecLims = xyzElectrodeLimitsNoShaft([0 0 0], eL, eA1, eA2);

elecXNoShaft = elecLims(1,2) - elecLims(1,1);
elecYNoShaft = elecLims(1,4) - elecLims(1,3);
elecZNoShaft = elecLims(1,6) - elecLims(1,5);

% Find the limits of the entire lead with shaft (including all 4 contacts)
% The length of all four contacts is 13.5 mm with shaft
% Remember one end is terminal contact with diameter 1.27 mm
% The other end is shaft with approximate diameter 0.64 mm (visually estimated. Please verify later)
% So 0.32 mm radius on one end and 1.27/2 mm radius on another end
[eL, eA1, eA2] = getElectrodeVectorsWithShaft(contactDir);
elecLims = xyzElectrodeLimitsWithShaft([0 0 0], eL, eA1, eA2);

elecXWithShaft = elecLims(1,2) - elecLims(1,1);
elecYWithShaft = elecLims(1,4) - elecLims(1,3);
elecZWithShaft = elecLims(1,6) - elecLims(1,5);















