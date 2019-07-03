% Takes uncertain center positions and underlying/most probable center
% position for the terminal contact (contact 3, see Fig. 2a in the paper) as input and computes
% uncertain positions along with their likelihood for contacts 0, 1, and 2

% uncertainCenters: Uncertain contact-center positions for the terminal
% contact (contact 3)
% mostProbableCenter: Spatial position with the highest likelihood of existence
% trueCenter: The true spatial position of contact 3 
% of contact center for the terminal contact
% trajectory: Mean DBS lead trajectory
% signArray: information relevant to the spatial orientation of the
% terminal contact
% uncertainCenterPos: Point cloud representing uncertain contact-center
% positions for all four DBS contacts
% uncertainCenterLikelihood: existential likelihood values for points in a point cloud
% represented by uncertainCenterPos
% mostProbableCenterPos: Spatial positions with highest exitential
% likelihood for contacts
% mostProbableCenterLikelihood: Existential likelihood for point
% represented by mostProbableCenterPos
% trueCenterPos: True spatial positions for DBS contacts (computed analytically 
% by mapping geometry (Sec. 3.1 in paper) to volume)
% trueCenterLikelihood: Existential likelihood of true DBS center positions
% (which is 1 always)

function [uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, trueCenterPos, trueCenterLikelihood] = getScirunCoordsAllContact(uncertainCenters, mostProbableCenter, trueCenter, trajectory, signArray)

[a, b] = size(uncertainCenters);

% copy point cloud for contact 3 into temporary array
scirunPtCloud = zeros(a,b);
% 3D positions
scirunPtCloud(:,1:3) = uncertainCenters(:,1:3);
% Likelihood
scirunPtCloud(:,4) = uncertainCenters(:,4);
% record the most probable position for contact 3
scirunMostProbableLikelihood = [mostProbableCenter, 1];
% record the true position for contact 3
scirunTrueLikelihood = [trueCenter, 1];

% Compute uncertain center positions for other contacts given uncertain
% postions for contact 3 and mead DBS lead trajectory
uncertainCenterPos = postProcessPtCloud(scirunPtCloud, trajectory , signArray);
uncertainCenterLikelihood = uncertainCenterPos(:,4);

% Propagate the most probable position to other contacts
mostProbableCenterPos = postProcessPtCloud(scirunMostProbableLikelihood, trajectory , signArray);
mostProbableCenterLikelihood = mostProbableCenterPos(:,4);

% Propagate true center position to other contacts
trueCenterPos = postProcessPtCloud(scirunTrueLikelihood, trajectory , signArray);
trueCenterLikelihood = trueCenterPos(:,4);