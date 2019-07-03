% Compute the most probable electrode trajectory by matching image stretch
% for electrode contacts with analytical stretch.

% testImage: Test image cropped with bounding box of interest
% dwnSmpRate: Inter-slice distance in mm for testImage
% initialTrajEstimate: initial trajectory estimate representing an Octant
% that needs to be Monte-Carlo sampled
function myTrajEstimate = oneMyTrajTechnique(testImage, dwnSmpRate, initialTrajEstimate)

% Estimate stretch of a single DBS contact (Cx, Cy, Cz) and all four contact together 
% (Sx Sy Sz) in closed form for the initial trajectory estimate
[Cx, Cy, Cz, Sx, Sy, Sz] = getContactAndElectrodeStretch([0 0 0], initialTrajEstimate);
estimatedContactStretch = [Cx, Cy, Cz];

% Estimate stretch of all four electrodes along X, Y, and Z directions from the input test image
% using inter-slice distance in mm for the test image 
%imageStretch = syntheticDataImageStretch(underlyingTrajStretch, dwnSmpRate, offset, estimatedContactStretch);
imageStretch = latestSyntheticDataImageStretch(testImage, dwnSmpRate, estimatedContactStretch);

% Find most probable electrode trajectory by coarse sampling followed by fine sampling of octant 
coarseTraj = coarseRefineTrajectoryMC(initialTrajEstimate,imageStretch, dwnSmpRate);
traj = fineRefineTrajectoryMC(coarseTraj(1,1:3), imageStretch, dwnSmpRate);
% coarseTraj = probabilisticCoarseRefineTrajectoryMC(initialTrajEstimate,imageStretch, dwnSmpRate);
% traj = probabilisticFineRefineTrajectoryMC(coarseTraj(1,1:3), imageStretch, dwnSmpRate);

% Return the most probable DBS lead trajectory
myTrajEstimate = traj(1,1:3);