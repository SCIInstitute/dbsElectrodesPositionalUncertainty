% Calculate solid angle representing directional uncertainty
function [solidAngle1, solidAngle2, bInner1, bInner8, bOuterTerminalContactPlanes, signArray, meanTraj] = calculateSolidAngle()

% Load real data
[croppedRealData, meta, contactCenter, contactDir] = getInput();
testImage = double(croppedRealData);
dwnSmpRate = [0.45, 0.45, 1];

% Bring data into range [0,255]
% HU can vary from -1024 to 1024 or 3072 depending upon vendor.
% The template image is taken with respect to water which has HU of 0,
% whreas the real data is (of course) with respect to air which has HU (-816)
mint = -1024;
maxt = 3072;
testImage = (testImage - mint)/(maxt - mint)*255;

% Bring data from air to water space :-)
% The intensity value for  air in rescaled space (around 65)
% [a,b,c] = size(testImage);
% for i =1 : a
%     for j =1 : b
%         for k =1 : c
%             if(testImage(i,j,k)  - 100 < 1)
%                 testImage(i,j,k) = 0;
%             end
%         end
%     end
% end
%myNrrdWriter('/home/sci/tushar.athawale/myResearch/myProjects/dbsLeadUncertainty/src/MATLAB/v2JournalSubmission/data/realData/patient1/NYU_255Space.nrrd', testImage, [0.45, 0.45, 1], [0, 0, 0], 'ascii');

% dirNum = 1;
% % Choose Dwn sample rate along Z. Dwn sample rate is 0.5 mm along X and Y. 
% dwnRate = 3;
% % Choose offset along X and Y directions
% offsetX = 0.55;
% % Choose offset along Z direction
% offsetZ = 1.9;
% parentFolder = '/home/sci/tushar.athawale/myResearch/myProjects/dbsLeadUncertainty/src/MATLAB/v2JournalSubmission/data/syntheticData/noisyData/smoothing1/';
% folderName = strcat(parentFolder, num2str(dirNum), '_', num2str(dwnRate),'_',num2str(offsetX),'_',num2str(offsetZ));
% metadataFilename = strcat(folderName,'/metadata.txt');
% gaussianDataFilename = strcat(folderName,'/gaussian.mat');
% 
% metaData= dlmread(metadataFilename,'\t');
% data = load(gaussianDataFilename);
% testImage = data.testData3;
% dwnSmpRate = metaData(2,:);
% offset = metaData(3,:);
% 
% % Underlying trajectory
% underlyingTraj = metaData(1,1:3);
% [Cx, Cy, Cz, Sx, Sy, Sz] = getContactAndElectrodeStretch([0 0 0], underlyingTraj);
% underlyingTrajStretch = [Cx, Cy, Cz, Sx, Sy, Sz];

% Aim is to process axial slices from ventral to dorsal (khalun-var) direction
 
% !!!!!!! Following step only for synthetic data! Need to skip this step for the real
 % dataset since contactDir parameter would be unknown 
 
 % If x and y coordinates of estimatedDirection are both -ve or both +ve, matlab
 % strangely stores the dorsal axial Z slices at lower indices (I verified this through vis. Also can
 % be easily seen through sign of z coordinate.)
 % flip the sign of x,y,z in the case when both x and y are positive or
 % when both x and y are negative.
 % Therefore reprocess slices in reverse order

%  if (underlyingTraj(1) > 0 && underlyingTraj(2) > 0)  || (underlyingTraj(1) < 0 && underlyingTraj(2) < 0)
%      testImage = flip(testImage,3);
%  end

% We want to visually determine the two bounding boxes representing
% uncertainty in electrode stretch (See Fig. 5 in the paper, in which B1 denotes the inner
% bounding box and B2 denotes the outer bounding box). Lets say bInner is the inner bounding box and
% bOuter is outer bounding. Crop data according to outer bounding box.
% Limits are needed to be figured out visually in SCIRun software by constructing bounding box
% around the electrode isosurface

% Bounding box bOuter
% !!!Very important!!! When you determine the limits from scirun add 1 to scirun limits
% since 0 in scirun corresponds to 1 in matlab
x1 = 4; 
x2 = 20; 
y1 = 5;
y2 = 23;
z1 = 3;
z2 = 14;
bOuter = testImage(x1:x2, y1:y2, z1:z2);
% Since we are visually identifying boundaries of isosurface, write them
% out to a cropLimits.txt
folderName = 'results/patient1';
if ~exist(folderName, 'dir')
       mkdir(folderName)
end
dlmwrite(strcat(folderName, '/cropLimits.txt'), [x1, x2, y1, y2, z1, z2] , 'delimiter', '\t');

[a,b,c] = size(bOuter);

% Compute eight different possible bounding boxes that are subset of outer
% bounding box (Sec. 3.2.2 in the paper). Each of the bounding boxes may represent
% bounding box for the underlying electrode direction (which is a directional uncertainty)

%numImagePlanesRepresentingUncertainty (nIm)
nImX = 1;
nImY = 1;
nImZ = 1;

bInner1 = bOuter;
bInner2 = bOuter(1+nImX:a-nImX, 1:b, 1:c);
bInner3 = bOuter(1:a, 1+nImY:b-nImY, 1:c);
bInner4 = bOuter(1:a, 1:b, 1+nImZ:c-nImZ);
bInner5 = bOuter(1+nImX:a-nImX, 1+nImY:b-nImY, 1:c);
bInner6 = bOuter(1+nImX:a-nImX, 1:b, 1+nImZ:c-nImZ);
bInner7 = bOuter(1:a, 1+nImY:b-nImY, 1+nImZ:c-nImZ);
bInner8 = bOuter(1+nImX:a-nImX, 1+nImY:b-nImY, 1+nImZ:c-nImZ);
 
 
%  % Lead DBS technique
% leadDBSTrajEstimate = leadDBSEstimateElectrodeTrajectory(bOuter, dwnSmpRate);
% % Sanity check: Angle between leadDBS estimated and the actual electrode direction
% angleLeadDBS = atan2d(norm(cross(underlyingTraj,leadDBSTrajEstimate)), dot(underlyingTraj,leadDBSTrajEstimate));
% close all

% Compute the initial trajectory estimate only once for the innermost box
% So, that hopefully it won't contect weird spread out artifacts.
% The purpose is only to determine the octant for electrode direction
initialTrajEstimate = getInitialTrajectoryEstimate(bInner8, dwnSmpRate);
signArray = getSignArray(initialTrajEstimate);
if signArray(1)>0 && signArray(2)>0
    bOuterTerminalContactPlanes = [x1, y1, z1];
elseif  signArray(1)<0 && signArray(2)>0
    bOuterTerminalContactPlanes = [x2, y1, z1];
elseif signArray(1)>0 && signArray(2)<0
    bOuterTerminalContactPlanes = [x1, y2, z1];
elseif signArray(1)<0 && signArray(2)<0
    bOuterTerminalContactPlanes = [x2, y2, z1];
end

oneMyTrajEstimate = oneMyTrajTechnique(bInner1, dwnSmpRate, initialTrajEstimate);
[phi1, theta1] = getSphericalCoord(oneMyTrajEstimate);
close all

oneMyTrajEstimate = oneMyTrajTechnique(bInner2, dwnSmpRate, initialTrajEstimate);
[phi2, theta2] = getSphericalCoord(oneMyTrajEstimate);
close all

oneMyTrajEstimate = oneMyTrajTechnique(bInner3, dwnSmpRate, initialTrajEstimate);
[phi3, theta3] = getSphericalCoord(oneMyTrajEstimate);
close all

oneMyTrajEstimate = oneMyTrajTechnique(bInner4, dwnSmpRate, initialTrajEstimate);
[phi4, theta4] = getSphericalCoord(oneMyTrajEstimate);
close all

oneMyTrajEstimate = oneMyTrajTechnique(bInner5, dwnSmpRate, initialTrajEstimate);
[phi5, theta5] = getSphericalCoord(oneMyTrajEstimate);
close all

oneMyTrajEstimate = oneMyTrajTechnique(bInner6, dwnSmpRate, initialTrajEstimate);
[phi6, theta6] = getSphericalCoord(oneMyTrajEstimate);
close all

oneMyTrajEstimate = oneMyTrajTechnique(bInner7, dwnSmpRate, initialTrajEstimate);
[phi7, theta7] = getSphericalCoord(oneMyTrajEstimate);
close all

oneMyTrajEstimate = oneMyTrajTechnique(bInner8, dwnSmpRate, initialTrajEstimate);
[phi8, theta8] = getSphericalCoord(oneMyTrajEstimate);
close all

minPhi = min([phi1, phi2, phi3, phi4, phi5, phi6, phi7, phi8]);%         [a, b, c] = size(VArr{i});
%         [X,Y,Z] = meshgrid(1:1:b,1:1:a,1:1:c);
%         isosurfaceVis(X,Y,Z,VArr{i},isoval);

maxPhi = max([phi1, phi2, phi3, phi4, phi5, phi6, phi7, phi8]);
minTheta = min([theta1, theta2, theta3, theta4, theta5, theta6, theta7, theta8]);
maxTheta = max([theta1, theta2, theta3, theta4, theta5, theta6, theta7, theta8]);

% Dump an array of phi and theta values for eight bounding boxes
dlmwrite(strcat(folderName, '/phiThetaArray.txt'), [phi1, phi2, phi3, phi4, phi5, phi6, phi7, phi8; theta1, theta2, theta3, theta4, theta5, theta6, theta7, theta8] , 'delimiter', '\t');
% Dump an array of phi and theta values representing longitudinal
% uncertainty for DBS lead
dlmwrite(strcat(folderName, '/minPhiMinThataMaxPhiMaxTheta.txt'), [minPhi, minTheta; maxPhi, maxTheta] , 'delimiter', '\t');

[x, y, z] = getSphericalProjection(0.1,minPhi, minTheta);
startEnd = [-x, - y, -z; x, y, z];
[rPhi1, rTheta1] = getSphericalCoord([-x, -y, -z]);

[x, y, z] = getSphericalProjection(0.1,minPhi, maxTheta);
startEnd = [-x, - y, -z; x, y, z];
[rPhi2, rTheta2] = getSphericalCoord([-x, -y, -z]);

[x, y, z] = getSphericalProjection(0.1,maxPhi, minTheta);
startEnd = [-x, - y, -z; x, y, z];
[rPhi3, rTheta3] = getSphericalCoord([-x, -y, -z]);

[x, y, z] = getSphericalProjection(0.1,maxPhi, maxTheta);
startEnd = [-x, - y, -z; x, y, z];
[rPhi4, rTheta4] = getSphericalCoord([-x, -y, -z]);

meanPhi = (minPhi + maxPhi)/2;
meanTheta = (minTheta + maxTheta)/2;
[x, y, z] = getSphericalProjection(0.1,meanPhi, meanTheta);
startEnd = [-x, - y, -z; x, y, z];
meanTraj = [x, y, z];
meanTraj = meanTraj/norm(meanTraj);
% Write out a 3D line representing the mean DBS lead
% trajectory into a VTK format
vtkwrite(strcat(folderName,'/meanPhiMeanTheta.vtk'),'polydata','lines', startEnd(:,1), startEnd(:,2), startEnd(:,3));

minRPhi = min([rPhi1, rPhi2, rPhi3, rPhi4]);
maxRPhi = max([rPhi1, rPhi2, rPhi3, rPhi4]);
minRTheta = min([rTheta1, rTheta2, rTheta3, rTheta4]);
maxRTheta = max([rTheta1, rTheta2, rTheta3, rTheta4]);
solidAngle1 = [minPhi, minTheta, maxPhi, maxTheta];
solidAngle2 = [minRPhi,minRTheta,maxRPhi, maxRTheta];
dlmwrite(strcat(folderName, '/reverseMinPhiMinThataMaxPhiMaxTheta.txt'), [minRPhi, minRTheta; maxRPhi, maxRTheta] , 'delimiter', '\t');









