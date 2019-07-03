% Compute contact-center spatial likelihood
% method: The method used to compare Monte Carlo sample with the test image
% Supported methods: SSIM
% bOuter: outer bounding box computed manually using SCIRun for the test
% image
% gtMP: a filtered high-resolution volume
% dwnSmpRate: interslice distance in mm for the test image
% gtMPContactStretchArr: Stretch of a single DBS electrode along X-Y-Z for
% the mean DBS lead direction
% gtMPElectrodeStretchArr: Stretch of four DBS electrodes along X-Y-Z for
% the mean DBS lead direction
% gtMPVoxelSpacing: voxel spacing in mm for high-res DBS lead image
% (oriented along the mean direction), i.e., gtMP
% signArray: Manages orientation of the terminal contact (contact number 3)
% numPlanes: number of zero planes appended on both sides in gtMP
function [uncertainCenters, resX, resY, resZ]= computeLikelihood(method, bOuter, gtMP, dwnSmpRate, gtMPContactStretchArr, gtMPElectrodeStretchArr, gtMPVoxelSpacing, signArray, numPlanes)
 
% Get offset sampling range. It depends upon the inter-slice distance and
% the contact width
range = getOffsetSamplingRange(dwnSmpRate, gtMPContactStretchArr, numPlanes);

% Sample the offset sampling range in each direction with sampling rate of your
% choice. This is essentially the uncertainty in the contact-center position.
% If the inter-slice distance is 1mm, the contact center can lie anywhere in
% that 1 mm.

xOffsetSmpRate =  0.2;
yOffsetSmpRate = 0.2;
zOffsetSmpRate = 0.2;

% Monte Carlo samples for offsets along X-Y-Z directions.
xOffsets = range(1): xOffsetSmpRate : range(2);
yOffsets = range(3): yOffsetSmpRate : range(4);
zOffsets = range(5): zOffsetSmpRate : range(6);

resX = numel(xOffsets);
resY = numel(yOffsets);
resZ = numel(zOffsets);

% Display spatial uncertainty in a contact center (x-, y-, and z- ranges)
% for the fourth contact (contact number 3 for indexing like 0,1,2,3)
displayUncertainCenterRange(numPlanes, signArray, dwnSmpRate, gtMPContactStretchArr, gtMPElectrodeStretchArr, range);
uncertainCenters = zeros(numel(xOffsets)*numel(yOffsets)*numel(zOffsets),4);
tic

% Instead of inverting every Monte-Carlo sample inside parfor.. invert
% observation.
%if (signArray(1) > 0 && signArray(2) > 0)  || (signArray(1) < 0 && signArray(2) < 0)
%     bInner = flip(bInner,3);
%end

% Gradient field of the test image
observation = mat2gray(imgradient3(bOuter));

[o1,o2,o3] = size(observation);

%kSize = [3, 3, 3];

parfor linId = 1:numel(xOffsets)*numel(yOffsets)*numel(zOffsets)
    %    averageMismatch = 0;
    [i, j, k] = ind2sub([numel(xOffsets), numel(yOffsets), numel(zOffsets)], linId);
%                        i =5;
%                        j = 5;
%                        k = 10;
%                        linId = sub2ind([numel(xOffsets), numel(yOffsets), numel(zOffsets)], i, j, k );
    
    
    oX = xOffsets(i);
    oY = yOffsets(j);
    oZ = zOffsets(k);
    
    % Draw low-resolution Monte Carlo samples from a filtered
    % high-resolution image
    % For that, pick imaging planes from filtered high-res image, i.e.,
    % gtMP
    % Kernel to simulate partial volume effect and point spread function
    % You may decide to add random noise to simulate reconstruction noise
    % Kernel size in millimeters (1x3 array for X, Y, Z directions)
   
    %dwnV1 = fastFilterImageWithOffset(gtMP, dwnSmpRate, [oX, oY, oZ], 'gaussian', gtMPVoxelSpacing, kSize, signArray);
    dwnV1 = pickPlanesInFilteredImage(gtMP, dwnSmpRate, [oX, oY, oZ], gtMPVoxelSpacing);
    
%     if (signArray(1) > 0 && signArray(2) > 0)  || (signArray(1) < 0 && signArray(2) < 0)
%          dwnV1 = flip(dwnV1,3);
%     end
    %dwnV1 = dwnV1+ 20*rand(size(dwnV1));
    
    %      kSize = [1, 1, 1];
    %      dwnV2 = fastFilterImageWithOffset(gtMP, dwnSmpRate, [oX, oY, oZ], 'gaussian', gtMPVoxelSpacing, kSize, signArray);
    %      %dwnV2 = dwnV2+ 20*rand(size(dwnV2));
    %
    %      kSize = [1.5, 1.5, 1.5];
    %      dwnV3 = fastFilterImageWithOffset(gtMP, dwnSmpRate, [oX, oY, oZ], 'gaussian', gtMPVoxelSpacing, kSize, signArray);
    %      %dwnV3 = dwnV3+ 20*rand(size(dwnV1));
    
    % Compute the contact-center position for the drawn Monte Carlo Sample
    center = computeCenterLocation(numPlanes, dwnV1, [oX, oY, oZ], dwnSmpRate, signArray, gtMPContactStretchArr, gtMPElectrodeStretchArr);
    
    % Gradient fields for three Monte Carlo samples corresponding to 3 downsampled volumes
    mcSample1 = mat2gray(imgradient3(dwnV1));
    % mcSample1 = dwnV1;
    %      mcSample2 = mat2gray(imgradient3(dwnV2));
    %      mcSample3 = mat2gray(imgradient3(dwnV3));
    
    [m1, m2, m3] = size(mcSample1);
    
    if (o1 > m1) ||   (o2 > m2) ||  (o3 > m3)
        likelihood = 0;
    else
        % Sigma: How quickly Gaussian falls off from mean. High sigma implies
        % Gaussian is broad and falls of slowly.
        if(strcmp(method,'correlation'))
            %sample1 = mcSample1(1:o1, 1:o2,1:o3);
            %sample2 = mcSample2(1:o1, 1:o2,1:o3);
            %sample3 = mcSample3(1:o1, 1:o2,1:o3);
            %likelihood = pearsonCorrelation(observation, sample1) + pearsonCorrelation(observation, sample2) + pearsonCorrelation(observation, sample3);
        elseif (strcmp(method,'Gaussian'))
            sample1 = mcSample1(1:o1, 1:o2,1:o3);
            likelihood = ssim(sample1, observation);
            %                 sample2 = mcSample2(1:o1, 1:o2,1:o3);
            %                 sample3 = mcSample3(1:o1, 1:o2,1:o3);
            %                 likelihood = abs(sum(abs(observation(:))) - sum(abs(sample1(:)))) + abs(sum(abs(observation(:))) - sum(abs(sample2(:)))) + abs(sum(abs(observation(:))) - sum(abs(sample3(:))));
            %likelihood = getDiffNormGaussianDistance(observation, sample1, 500) + getDiffNormGaussianDistance(observation, sample2, 500) + getDiffNormGaussianDistance(observation, sample3, 500);
            %likelihood = getDiffNormGaussianDistance(observation, sample1, 500);
        elseif (strcmp(method,'ssim'))
            sample1 = mcSample1(1:o1, 1:o2,1:o3);
            likelihood = ssim(sample1, observation, 'Exponents', [0, 3, 5]);
            %                 sample2 = mcSample2(1:o1, 1:o2,1:o3);
            %                 sample3 = mcSample3(1:o1, 1:o2,1:o3);
            %                 likelihood = abs(sum(abs(observation(:))) - sum(abs(sample1(:)))) + abs(sum(abs(observation(:))) - sum(abs(sample2(:)))) + abs(sum(abs(observation(:))) - sum(abs(sample3(:))));
        elseif (strcmp(method,'KL'))
            %sample1 = mcSample1(1:o1, 1:o2,1:o3);
            %sample2 = mcSample2(1:o1, 1:o2,1:o3);
            %sample3 = mcSample3(1:o1, 1:o2,1:o3);
            %likelihood = KLDmain(observation, sample1) + KLDmain(observation, sample2) + KLDmain(observation, sample3);
        end
    end
    
    % Store center location and likelihood
    uncertainCenters(linId,:) = [center, likelihood];
end
toc


% map likelihood to range 0 and 1
if(strcmp(method,'correlation'))
    minCorrelation = min(uncertainCenters(:,4));
    maxCorrelation = max(uncertainCenters(:,4));
    uncertainCenters(:,4) = (uncertainCenters(:,4) - minCorrelation)/(maxCorrelation - minCorrelation);
elseif (strcmp(method,'Gaussian'))
    uncertainCenters(:,4) = (uncertainCenters(:,4) - min(uncertainCenters(:,4)))/(max(uncertainCenters(:,4)) - min(uncertainCenters(:,4)));
     % compute variance of differences
     %var = sum(uncertainCenters(:,4))/length(uncertainCenters(:,4));
     uncertainCenters(:,4) = exp(-uncertainCenters(:,4));
     %uncertainCenters(:,4) = (uncertainCenters(:,4) - min(uncertainCenters(:,4)))/(max(uncertainCenters(:,4)) - min(uncertainCenters(:,4)));
elseif (strcmp(method,'ssim'))
    uncertainCenters(:,4) = (uncertainCenters(:,4) - min(uncertainCenters(:,4)))/(max(uncertainCenters(:,4)) - min(uncertainCenters(:,4)));
end

% X = reshape(uncertainCenters(:,1), [numel(xOffsets), numel(yOffsets), numel(zOffsets)]);
% Y = reshape(uncertainCenters(:,2), [numel(xOffsets), numel(yOffsets), numel(zOffsets)]);
% Z = reshape(uncertainCenters(:,3), [numel(xOffsets), numel(yOffsets), numel(zOffsets)]);
% scalarGrid = reshape(uncertainCenters(:,4), [numel(xOffsets), numel(yOffsets), numel(zOffsets)]);