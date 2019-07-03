% Function to downsample rotated high-resolution DBS lead image to a
% low-resolution, and hence, generate a patient-like test image
% gtFinal: Rotated ground truth image with appended zero planes 
% smpRate: downsampling rate
% offset: Starting offset (in mm) along X, Y,Z directions used for
% downsampling
% voxelSpacing: spacing between voxels in mm for the rotated ground truth
% image
% interpolation: Kernal used for downsampling process
% noiseDeviation: simulate reconstruction noise
% kSize: the support of the interpolation kernel (lxmxn voxel^3)
function testImage = setTestImageParameters(gtFinal, smpRate, offset, voxelSpacing, interpolation, noiseDeviation, kSize)

% Gaussian noise
[a, b, c] = size(gtFinal);
% Simulate the reconstruction noise
gtFinal = gtFinal+ noiseDeviation*randn(a,b,c);
% Simulate the partial volume effect. Perform fast filtering of the image
% with the downsampling rate and offset
testImage = fastFilterImageWithOffset(gtFinal, smpRate, offset,  interpolation, voxelSpacing, kSize);

%testImage = filterImageWithOffset(gtFinal, smpRate, offset, interpolation, voxelSpacing);
%testImage = dwnsampleWithOffset(gtFinal, smpRate, offset, interpolation, voxelSpacing);