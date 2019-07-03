% Compute uncertain spatial positions for contacts 0,  1, and 2.

% ptCloud: uncertain contact-center positions for contact 3
% contactDir: mean DBS lead direction
% signArray: array representing directional orientation information for
% contact 3

function nPtCloud = postProcessPtCloud(ptCloud, contactDir, signArray)

% get number of pts for terminal contact
[rows,cols] = size(ptCloud);

% Create array for 4 contacts
nPtCloud = zeros(4*rows,cols);

[phiL,thetaL] = getSphericalCoord(contactDir);
% Inter-contact distance along the trajectory is 3mm
[interContX, interContY, interContZ] = getSphericalProjection(3,phiL,thetaL);

% sign array determined for SCIrun vis space
interContX = signArray(1)*abs(interContX);
interContY = signArray(2)*abs(interContY);
interContZ = signArray(3)*abs(interContZ);

% Determine point spread for remaining three contacts
nPtCloud(1:rows,1:3) = ptCloud(1:rows,1:3);
nPtCloud(rows+1 : 2*rows,1:3) = ptCloud(1:rows,1:3) + [interContX, interContY, interContZ];
nPtCloud(2*rows+1 : 3*rows ,1:3) = ptCloud(1:rows,1:3) + [2*interContX, 2*interContY, 2*interContZ];
nPtCloud(3*rows+1 : 4*rows ,1:3) = ptCloud(1:rows,1:3) + [3*interContX, 3*interContY, 3*interContZ];

% propagate probabilities for remaining three contacts
% probabilities will equally propagated since we compared full images for
% each Monte Carlo sample with the test image
nPtCloud(1:rows,4) = ptCloud(1:rows,4);
nPtCloud(rows+1 : 2*rows,4) = ptCloud(1:rows,4);
nPtCloud(2*rows+1 : 3*rows ,4) = ptCloud(1:rows,4);
nPtCloud(3*rows+1 : 4*rows ,4) = ptCloud(1:rows,4);





