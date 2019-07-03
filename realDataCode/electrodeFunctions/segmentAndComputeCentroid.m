% segment out electrode image on a slice and compute the centroid of
% non-zero intensity pixels

% sl: Slice, a 2-D image
% dwnSmpRate: inter-slice distance for the test image in mm
% upFactor: Factor used to supersample a test image for easy segmentation
% sliceNum: slice number in Z direction provided for computation of
% z-coordinte of centroid
function [centroid] = segmentAndComputeCentroid(sl, dwnSmpRate, upFactor, sliceNum)

% Distance between consecutive slices in millimeters
dwnSmpRateX = dwnSmpRate(1);
dwnSmpRateY = dwnSmpRate(2);
dwnSmpRateZ = dwnSmpRate(3);

[a, b] = size(sl);

% Upsample volume for clear segmentation
[X, Y] = meshgrid(1:1:b, 1:1:a);
[Xq,Yq] = meshgrid(1:1/upFactor:b, 1:1/upFactor:a);
Vq = interp2(X,Y,sl,Xq,Yq,'cubic');

I = mat2gray(Vq);

% Otsu's automatic thresholding
level = graythresh(I);

[x, y] = find(I >= level);
d = Vq(ceil(mean(x)),ceil(mean(y)));
% Compute centroid in millimeters
% dwnSmpRateX/upfactor = distance between consecutice slices in upsampled
% volume

% This is inreference to what we visually see and how data is stored. Every
% attemt is made to be consistent with the origin in visual scene for
% deciding IP
%  The plane at location l has coordinates (l-1)*dwnSmpRate. eg, coordinate
%  of plane 1 is 0
%centroid = [ (a-1)*dwnSmpRateX - ((mean(x)/upFactor)-1)*dwnSmpRateX, (b-1)*dwnSmpRateY - ((mean(y)/upFactor) - 1)*dwnSmpRateY, sliceNum];
centroid = [ ((mean(x)/upFactor)-1)*dwnSmpRateX, ((mean(y)/upFactor) - 1)*dwnSmpRateY, sliceNum*dwnSmpRateZ];

BW = imbinarize(I,level);
figure
imshowpair(I,BW,'montage')