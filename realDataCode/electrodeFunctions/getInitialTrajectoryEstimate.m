% Get initital electrodes trajectory estimate for the input test image with
% given interslice distance specified by dwnSmpRate (in mm)

function estimatedDirSVD = getInitialTrajectoryEstimate(testImage, dwnSmpRate)

[a, b, c] = size(testImage);

centroidArr = zeros(c-2,3);
 
% Step through each slice of test image in axial (Z) direction
for sliceNum = 2:c-1

%sl= reshape(testImage(:,:,sliceNum), [a b]);
sl = testImage(:,:,sliceNum);
% Factor used to supersample a test image for easy segmentation
upFactor = 10;
% segment out electrode image on a slice, and compute the centroid of
% non-zero intensity pixels
[centroid] = segmentAndComputeCentroid(sl, dwnSmpRate, upFactor, sliceNum);
% Store centroid for each axial slice into an array
centroidArr(sliceNum - 1, 1:3) = centroid;
end

% Fit line to array of centroids
estimatedDirSVD = fitLine3(centroidArr, c-2);

% Always assume electrode from down to up or +ve Z direction
if(estimatedDirSVD(3) < 0)
    estimatedDirSVD = -estimatedDirSVD;
end
 
 
 
 