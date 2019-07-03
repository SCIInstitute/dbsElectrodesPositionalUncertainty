% contactDir: Orient  high-res electrodes image along the input direction
% dwnSmpRate: Input downsampling rate in millimeters
% testImageOffset: starting offset along X, Y, and Z directions
% interpolation : kernel used for averaging during the downsampling of
% high-res image
% kernelSize: support of interpolation kernel
% includeShaft: whether to include or not the shaft at the tail of the fourth
% DBS electrode
% numPlanes: The number of zero planes to be appended on both sides of
% high-resolution electrodes image
function testData = generateTestImage(contactDir, dwnSmpRate,  testImageOffset, interpolation, noiseDeviation, kernelSize, includeShaft, numPlanes)

% gt: contains high-res electrodes image rotated along contactDir
% gtContactStretchArr: Compute in closed form the stretch of single
% electrode along X, Y, Z directions (Section 3.1 in the paper)
% gtElectrodeStretchArr: Compute in closed form the stretch of all four
% electrodes along X, Y, Z directions (Section 3.1 in the paper)
% numPlanes: numPlanes*dwnSmpRate(in mm) to be appended to the rotated
% groundtruth image
% gtVoxelSpacing: Voxel spacing in the groundTruth is direction dependent and not fixed 0.033mm
[gt, gtContactStretchArr, gtElectrodeStretchArr, gtVoxelSpacing] = generateGroundTruthImageArray(dwnSmpRate, contactDir, numPlanes, includeShaft);

% Subsample the rotated high-res image using input parameters to generate a
% patient-like test image
testData = setTestImageParameters(gt{1}, dwnSmpRate, testImageOffset, gtVoxelSpacing, interpolation, noiseDeviation, kernelSize);