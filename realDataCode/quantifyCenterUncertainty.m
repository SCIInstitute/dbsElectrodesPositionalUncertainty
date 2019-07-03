% ----------------------------------------------------------------------------------
%   Title:  A Statistical Framework for Visualization of Positional Uncertainty in Deep Brain Stimulation Electrodes
%   Authors: Tushar M. Athawale, Kara A. Johnson, Chris. R. Butson, and Chris R. Johnson	
%   Date: 06/26/2019
% ---------------------------------------------------------------------------------------

% Quantify positional uncertainty in DBS electrodes for post-operative CT
% scans (Fig. 9 and Fig. 10 in paper)

function uncertainCenters = quantifyCenterUncertainty()

addpath('data', 'electrodeFunctions', 'helperFunctions');

% Load real data
[croppedRealData, meta, contactCenter, contactDir] = getInput();
testImage = double(croppedRealData);
dwnSmpRate = [0.45, 0.45, 1];

%% Quantify Longitudinal Uncertainty (Section 3.2 in the paper)
[solidAngle1, solidAngle2, bOuter, bInner, bOuterTerminalContactPlanes, signArray, meanTraj] = calculateSolidAngle();

% Bring data into range [0,255]
% HU can vary from -1024 to 1024 or 3072 depending upon vendor.
% The template image is taken with respect to water which has HU of 0,
% whreas the real data is (of course) with respect to air which has HU (-816)
mint = -1024;
maxt = 3072;
testImage = (testImage - mint)/(maxt - mint)*255;

% count = 1;
% [a,b,c] = size(testImage);
% for i=1:a
%     for j =1:b
%         for k=1:c
%             if (testImage(i,j,k) < 100)
%                 noise(count) = testImage(i,j,k);
%                 count = count + 1;
%             end
%         end
%     end
% end
% dev = std(noise);

% % Bring data from air to water space :-)
% % The intensity value for  air in rescaled space (around 65)
% [a,b,c] = size(testImage);
% for i =1 : a
%     for j =1 : b
%         for k =1 : c
%             if(testImage(i,j,k) - 100 < 1)
%                 testImage(i,j,k) = 0;
%             end
%         end
%     end
% end

% Orient high-res DBS lead image along the mean trajectory. Append it with
% number of zero planes on both sides, as specified by numPlanes parameter
numPlanes = 7;
[V, gtMPContactStretchArr, gtMPElectrodeStretchArr, gtMPVoxelSpacing] = getCroppedContactsWithPartialShaft(dwnSmpRate, meanTraj, numPlanes, signArray);

%% Quantify Subvoxel-level Uncertainty (Section 3.3 in the paper)

% Filter the high-resolution volume using a Gaussian kernel before drawing
% low-resolution Monte-Carlo samples from it
kSize = [3, 3, 3];
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
% Since the underlying contact-center positions are not known for real
% data, we do following temporary assignment
underlyingCenter = mostProbablePosMM;

% So far we computed spatial likelihood for the terminal contact /contact
% number 3 (See Fig. 2a  in paper). postprocess volume to compute coordinates for all  
% remaining contacts (0, 1, and 2)
[uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood] = getScirunCoordsAllContact(uncertainCenters, underlyingCenter, meanTraj, signArray);

% Directory for storing visualization files.
% The generated files can be visualized in ParaView.
visualizeRealData(uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, method, testImage, dwnSmpRate, resX, resY, resZ)


