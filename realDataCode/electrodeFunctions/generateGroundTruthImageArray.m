% downSmpRate: downsampling rate in millimeters for test image to be
% generated
% longitudinalVar: Array of possible electrode direction vectors. Array may
% also consist of only one single direction vector 
% numPlanes: number of image planes (all zeros) to be appended on both sides of the
% ground truth image
% includeShaft: whether or not to include shaft near the tail of the fourth
% electrode when generating rotated version of the ground truth image

function [gtFinalArr, contactStretchArr, electrodeStretchArr, voxelSpacing] = generateGroundTruthImageArray(dwnSmpRate, longitudinalVar, numPlanes, includeShaft)

isoval = 28;

% number of electrode direction vectors
a = length(longitudinalVar(:,1));

% Generate an array of rotated versions of the ground truth (high-res)
% images for input direction vectors for longitudinal axis of DBS lead
gtArr = loadGroundTruth(longitudinalVar, includeShaft);

croppedGTArr = cell(a,1);
electrodeDir = zeros(1,3);
% Store a contact stretch for each electrode direction vector
contactStretchArr = zeros(a,3);
% Store stretch of four electrodes for each electrode direction vector
electrodeStretchArr = zeros(a,3);
% Store voxel spacing for each electrode direction
voxelSpacing = zeros(a,3);

for i = 1:a
 % Fetch a ground truth image (rotated electrode)
 gt = gtArr{i};   
 % Crop image such that the boundary image planes touch the isosurface of
 % DBS electrodes
 croppedGT = getCroppedVol(gt, isoval);
 % Store cropped volume into array
 croppedGTArr{i} = croppedGT;
 % Fetch electrode direction
 electrodeDir = longitudinalVar(i,1:3);
 % Size of the cropped image
 [dim1, dim2, dim3] = size(croppedGT);
 % Compute stretch of a single contact and all four contacts (with/without including shaft at the tail of the fourth electrode) 
 [sX, sY, sZ, elecXNoshaft, elecYNoShaft, elecZNoShaft, elecXWithShaft, elecYWithShaft, elecZWithShaft] = getContactAndElectrodeStretch([0,0,0], electrodeDir);
 contactStretchArr(i, 1:3) = [sX, sY, sZ];
 % Compute voxel spacing by mapping closed-form geometry with image
 % resolution
 if(includeShaft)
     electrodeStretchArr(i, 1:3) = [elecXWithShaft, elecYWithShaft, elecZWithShaft];
     voxelSpacing(i,1) = elecXWithShaft/(dim1-1);
     voxelSpacing(i,2) = elecYWithShaft/(dim2-1);
     voxelSpacing(i,3) = elecZWithShaft/(dim3-1);
 else
     electrodeStretchArr(i, 1:3) = [elecXNoshaft, elecYNoShaft, elecZNoShaft];
     voxelSpacing(i,1) = elecXNoshaft/(dim1-1);
     voxelSpacing(i,2) = elecYNoShaft/(dim2-1);
     voxelSpacing(i,3) = elecZNoShaft/(dim3-1);
 end
end

% Free massive amount of memory consumed by gtArr
clear gtArr;

% Pad the croppedGT with 0's equal to 2*num_voxels(for input sampling rate)
% to bring the groundTruth into the world coordinates

% Compute inter-voxel distance based on electrode trajectory
% First compute spread of all four contacts in X, Y and Z directions in
% millimeters and divide spread with grid resolution.

% samRateX = ceil(dwnSmpRate(1)/0.033); % division by voxel resolution of micro-CT
% samRateY = ceil(dwnSmpRate(2)/0.033);
% samRateZ = ceil(dwnSmpRate(3)/0.033);

% Voxel spacing for each electrode direction would be different and not
% same 0.033
numSamples = zeros(a,3);
numSamples(:,1) = round(dwnSmpRate(1)./voxelSpacing(:,1)); 
numSamples(:,2) = round(dwnSmpRate(2)./voxelSpacing(:,2)); 
numSamples(:,3) = round(dwnSmpRate(3)./voxelSpacing(:,3)); 

% The final preprocessed groundtruth image (sounds funny :-))
gtFinalArr = cell(a,1);
for  i = 1:a
    croppedGT = croppedGTArr{i};
    gtFinalArr{i} = padarray(croppedGT, [numPlanes*numSamples(i,1), numPlanes*numSamples(i,2), numPlanes*numSamples(i,3)],0,'both');
end

clear croppedGTArr;