% V: Input data
% smpRate: Downsample Rate in millimeters
% offset: offset from the starting slice in millimeters

function dwnV = dwnsamSpacingOffset(testImage, V, dwnRate, offset, electrodeStretchArr, voxelSpacing, interp)

% Bacause of padding of electrode bodunding box with 1 slice on both sides
% at a ditance of downsampling rate in millimeters
% Compute the range in millimeters for the groundtruth image
rangeX = electrodeStretchArr(1,1) + 2*dwnRate(1);
rangeY = electrodeStretchArr(1,2) + 2*dwnRate(2);
rangeZ = electrodeStretchArr(1,3) + 2*dwnRate(3);

[tx, ty, tz] = size(testImage);
% Caluculate number of voxels in groundtruth corresponing to test image
% resolution
% tx voxels in direction X means tx-1 spaces

% sampling width in millimeters
widthX = rangeX/(tx-1);
widthY = rangeY/(ty-1);
widthZ = rangeZ/(tz-1);

% %******** If widthX, widthY, and widthZ are close to downsampling rate.. Great!! 
% you are close to longitudinal direction
% Otherwise, farther the resolution, assign lower weight.
% Don't use widthX, widthY and widthZ for computation of resolution
% It leads to considerable error. Just use them to verify if they are
% closer to the downsampling rate. For computing resolution, use the downsampling rate 
numVoxelsX = floor(dwnRate(1)/voxelSpacing(1,1));
numVoxelsY = floor(dwnRate(2)/voxelSpacing(1,2));
numVoxelsZ = floor(dwnRate(3)/voxelSpacing(1,3));

offset = [floor(offset(1)/voxelSpacing(1,1)), floor(offset(2)/voxelSpacing(1,2)), floor(offset(3)/voxelSpacing(1,3))];

[a, b, c] = size(V);
[x,y,z] = ndgrid(1:1:a,1:1:b,1:1:c);
[xi,yi,zi] = ndgrid(1+offset(1):numVoxelsX:a+offset(1),1+offset(2):numVoxelsY:b+offset(2),1+offset(3):numVoxelsZ:c+offset(3));
dwnV = interpn(x,y,z,V,xi,yi,zi,interp,0);
% Don't use linspace. Validated through experiement.
%[xi,yi,zi] = ndgrid(linspace(1+offset(1), a+offset(1), tx), linspace(1+offset(2), b+offset(2), ty), linspace(1+offset(3), c+offset(3), tz));
% 0 for values that lie outside domain
