% ----------------------------------------------------------------------------------
%   Title:  A Statistical Framework for Visualization of Positional Uncertainty in Deep Brain Stimulation Electrodes
%   Authors: Tushar M. Athawale, Kara A. Johnson, Chris. R. Butson, and Chris R. Johnson	
%   Date: 06/26/2019
% ---------------------------------------------------------------------------------------

% Quantify positional uncertainty in DBS electrodes for post-operative CT-similar
% scans (Fig. 8 in paper)

function uncertainCenters = quantifyCenterUncertainty()

addpath('data', 'electrodeFunctions', 'helperFunctions');

dirNum = 1;
% Choose Dwn sample rate along Z. Dwn sample rate is 0.5 mm along X and Y. 
dwnRate = 1;
% Choose offset along X and Y directions
offsetX = 0.55;
% Choose offset along Z direction
offsetZ = 1.3;

%% Quantify Longitudinal Uncertainty (Section 3.2 in the paper)
[solidAngle1, solidAngle2, bOuter, bInner, bOuterTerminalContactPlanes, signArray, meanTraj] = calculateSolidAngle(dirNum, dwnRate, offsetX, offsetZ);

% Otsu's automatic thresholding
% for i = 1:length(bInner(1,1,:))
% I = bInner(:,:,i);
% level = graythresh(I);
% BW = imbinarize(I,level);
% figure
% imshowpair(I,BW,'montage');
% end

parentFolder = 'syntheticData/noisyData/smoothing1/';
folderName = strcat(parentFolder, num2str(dirNum), '_', num2str(dwnRate),'_',num2str(offsetX),'_',num2str(offsetZ));
metadataFilename = strcat(folderName,'/metadata.txt');
gaussianDataFilename = strcat(folderName,'/gaussian.mat');

metaData= dlmread(metadataFilename,'\t');
data = load(gaussianDataFilename);
testImage = data.testData3;
dwnSmpRate = metaData(2,1:3);
%testImageOffset = metaData(3,1:3);

% Underlying trajectory
underlyingTraj = metaData(1,1:3);
[Cx, Cy, Cz, Sx, Sy, Sz] = getContactAndElectrodeStretch([0 0 0], underlyingTraj);
underlyingTrajStretch = [Cx, Cy, Cz, Sx, Sy, Sz];

if (underlyingTraj(1) > 0 && underlyingTraj(2) > 0)  || (underlyingTraj(1) < 0 && underlyingTraj(2) < 0)
     testImage = flip(testImage,3);
end

% Orient high-res DBS lead image along the mean trajectory. Append it with
% number of zero planes on both sides, as specified by numPlanes parameter
numPlanes = 7;
[V, gtMPContactStretchArr, gtMPElectrodeStretchArr, gtMPVoxelSpacing] = getCroppedContactsWithPartialShaft(dwnSmpRate, meanTraj, numPlanes, signArray);

% adjust offset for this new image appended with numPlanes
testImageOffset = [offsetX + (numPlanes-1)*dwnSmpRate(1), offsetX + (numPlanes-1)*dwnSmpRate(2), offsetZ + (numPlanes-1)*dwnSmpRate(3) ];

% Display the underlying contact-center positions in the image oriented along
% the mean trajectory with appended number of planes (image produced in the step before adjusting offset)
trueCenter = displayGroundTruthCenterPositions(signArray, dwnSmpRate, testImageOffset, gtMPContactStretchArr, gtMPElectrodeStretchArr, numPlanes);

%% Quantify Subvoxel-level Uncertainty (Section 3.3 in the paper)

% Filter the high-resolution volume using a Gaussian kernel before drawing
% low-resolution Monte-Carlo samples from it
kSize = [1, 1, 1];
% Convert kernel size specified in mm into number of voxels
kSize(1,1) = round(kSize(1,1)/gtMPVoxelSpacing(1,1));
kSize(1,2) = round(kSize(1,2)/gtMPVoxelSpacing(1,2));
kSize(1,3) = round(kSize(1,3)/gtMPVoxelSpacing(1,3));
disp('Filtering the groundtruth image! This might take a while..')
h = fspecial3('gaussian',kSize); 
filteredV = imfilter(V,h);

% Compute spatial likelihood of the terminal contact center along the mean
% DBS lead direction (evaluated previously) by: 
% 1) Drawing low-resolution samples with different offsets from a
% high-resolution volume
% 2) Comparing the low-resolution samples with the test image using SSIM 
% other possible methods: correlation/ Gaussian/ KL
method = 'ssim';
[uncertainCenters, resX, resY, resZ] = computeLikelihood(method, bOuter, filteredV, dwnSmpRate, gtMPContactStretchArr, gtMPElectrodeStretchArr, gtMPVoxelSpacing, signArray, numPlanes);

% Compute the most probable contact-center position
mostProbablePosMM = displayMostProbableCenter(uncertainCenters);

% So far we computed spatial likelihood for the terminal contact /contact
% number 3 (See Fig. 2a  in paper). postprocess volume to compute coordinates for all  
% remaining contacts (0, 1, and 2)
[uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, trueCenterPos, trueCenterLikelihood] = getScirunCoordsAllContact(uncertainCenters, mostProbablePosMM, trueCenter, meanTraj, signArray);

% Directory for storing visualization files.
% The generated files can be visualized in ParaView.
foldername = strcat('results/',num2str(dirNum), '_', num2str(dwnRate),'_',num2str(offsetX),'_',num2str(offsetZ), '/',method, '/');
visualizeSyntheticData(foldername, uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, trueCenterPos, trueCenterLikelihood, method, testImage, dwnSmpRate, resX, resY, resZ, signArray)


