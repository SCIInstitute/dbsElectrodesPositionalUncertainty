% Generate  a patient-like DBS post-operative image by
% First, rotating a high-resolution DBS image by arbitrary solid angle (theta,phi) 
% Then subsampling the rotated high-resolution DBS lead image

function testImageGenerateHarness()

rng('default') ;

% sample contact directions
numSamples = 1;

% Keep electrode pointing upward i.e  positive Z
% Usually in DBS angle with positive Z is less than 45
phiSamples = 45*rand(numSamples,1);
thetaSamples = 360*rand(numSamples,1);
contDirs = zeros(numSamples,3);

% Get direction corresponding to random solid angle chosen for 
% the DBS lead (spherical -> cartesian)
for i =1:numSamples
    [x, y, z] = getSphericalProjection(1,phiSamples(i),thetaSamples(i));
    contDirs(i,1:3) = [x, y, z] ;
end

tic
% for each direction vary downsampling rate, interpolation
% direction number
%!!!!!!!! Rememeber to change back to 1
% for i = 1 :numSamples
%    dir = contDirs(i,1:3);
%    % downSampling rate along Z
%    for j = 1:0.5:3
%        % offset along X and Y [0.45 - 0.45/2, 0.45 + 0.45/2] 
%        for k = 0.3: 0.25: 0.65
%            % offset along Z 
%            for  l = j/2:0.8:3*j/2

            % i: ID of Monte Carlo sample
            i = 1;
            dir = contDirs(i,1:3);
            % j: Downsampling rate in mm along Z (vertical) direction
            j = 1;
            % k: starting offset along X and Y directions
            k = 0.55;
            % l: starting offset along Z direction
            l = 1.3;
%            if (i == 2) && (j ==1) && (k == 0.55 ) && (l == 1.3)
%                 here = 1;
%            else
%                continue;
%            end
           %specify the kernel size in MM
          kernelSize = [1, 1, 1]; 
          dwnSmpRate = [0.45, 0.45, j];
          offset = [k, k, l];
%          testData1 = generateTestImage(dir, dwnSmpRate, offset, 'average', noiseDeviation);
%          testData2 = generateTestImage(dir, dwnSmpRate, offset, 'ellipsoid', noiseDeviation);

          includeShaft = true;
          numPlanes = 1;
          noiseDeviation = 0;
          % Generate a patient-like test image
          testData3 = generateTestImage(dir, dwnSmpRate, offset, 'gaussian', noiseDeviation, kernelSize, includeShaft, numPlanes);     
          testData1 = testData3;
          testData2 = testData3;
          % put underlying DBS lead direction, downsampling rate, and
          % offset into a single matrix
          directionDwnRateOffset = [dir;dwnSmpRate;offset];
          parentFolder = '../syntheticData/noisyData/smoothing1/';
          folderName = strcat(parentFolder, num2str(i),'_',num2str(j),'_',num2str(k), '_', num2str(l));
          % Save the test data to a specified directory: files generated
          % are gaussian.nrrd, gaussian.mat, metadata.txt, kernelsize.txt
          saveData(folderName,testData1,testData2,testData3,directionDwnRateOffset, kernelSize);        
%           end
%        end
%    end    
% end
toc
