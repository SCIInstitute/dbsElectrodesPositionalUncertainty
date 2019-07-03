function [V, gtMPContactStretchArr1, gtMPElectrodeStretchArr1, gtMPVoxelSpacing1] = getCroppedContactsWithPartialShaft(dwnSmpRate, underlyingTraj, numPlanes, signArray)

% Remember: Here we rotate only contacts and eliminate/remove the shaft in
% the groudtruth image (This is very important to get the expected number of image planes in the downsampled version)
% Set number of planes to 0
includeShaft = false;
[gtMP1, gtMPContactStretchArr1, gtMPElectrodeStretchArr1, gtMPVoxelSpacing1] = generateGroundTruthImageArray(dwnSmpRate, underlyingTraj, 0, includeShaft);
V1 = gtMP1{1};
[d1, d2, d3] = size(V1);

% Set number of planes to 0
includeShaft = true;
[gtMP2, gtMPContactStretchArr2, gtMPElectrodeStretchArr2, gtMPVoxelSpacing2] = generateGroundTruthImageArray(dwnSmpRate, underlyingTraj, 0, includeShaft);
V2 = gtMP2{1};
[a, b, c] = size(V2);

if signArray(1) > 0 && signArray(2) > 0
    tempV = V2(1:d1, 1:d2, 1:d3);
elseif signArray(1) > 0 && signArray(2) < 0
    tempV = V2(1:d1, b-d2+1:b, 1:d3);
elseif signArray(1) < 0 && signArray(2) > 0
    tempV = V2(a-d1+1:a, 1:d2, 1:d3);
elseif signArray(1) < 0 && signArray(2) < 0
    %tempV = V2(a-d1+1:a, b-d2+1:b, 1:d3);
    % terminal contact at lower index: weird
    tempV = V2(1:d1, 1:d2, 1:d3);
    
    % logical try
    % place terminal contact at the end of X and Y directions
    tempV = flip(tempV,1);
    tempV = flip(tempV,2);

end

% % Crop approximately 2*contactStretch
% numVoxelsX = round(gtMPContactStretchArr2(1,1)/gtMPVoxelSpacing2(1,1));
% numVoxelsY = round(gtMPContactStretchArr2(1,2)/gtMPVoxelSpacing2(1,2));
% numVoxelsZ = round(gtMPContactStretchArr2(1,3)/gtMPVoxelSpacing2(1,3));
% % Crop the terminal contact region
% if signArray(1) > 0 && signArray(2) > 0
%     tempV = tempV(1:numVoxelsX, 1:numVoxelsY, 1:d3);
% elseif signArray(1) > 0 && signArray(2) < 0
%     tempV = tempV(1:d1, d2-numVoxelsY+1:d2, 1:d3);
% elseif signArray(1) < 0 && signArray(2) > 0
%     tempV = tempV(d1-numVoxelsX+1:d1, 1:d2, 1:d3);
% elseif signArray(1) < 0 && signArray(2) < 0
%     %tempV = tempV(d1-numVoxelsX+1:d1, d2-numVoxelsY+1:d2, 1:d3);
%     tempV = tempV(1:numVoxelsX, 1:numVoxelsY, 1:d3);
% end

% Voxel spacing for each electrode direction would be different and not
% same 0.033
numSamples = zeros(1,3);
numSamples(1,1) = round(dwnSmpRate(1)./gtMPVoxelSpacing1(:,1)); 
numSamples(1,2) = round(dwnSmpRate(2)./gtMPVoxelSpacing1(:,2)); 
numSamples(1,3) = round(dwnSmpRate(3)./gtMPVoxelSpacing1(:,3)); 
% Now append the volume with specified number of planes
 V = padarray(tempV, [numPlanes*numSamples(1,1), numPlanes*numSamples(1,2), numPlanes*numSamples(1,3)],0,'both');

% isoval = 28;
% [g1, g2, g3] = size(V);
% [X,Y,Z] = meshgrid(1:1:g2,1:1:g1,1:1:g3);
% isosurfaceVis(X,Y,Z,V,isoval);

