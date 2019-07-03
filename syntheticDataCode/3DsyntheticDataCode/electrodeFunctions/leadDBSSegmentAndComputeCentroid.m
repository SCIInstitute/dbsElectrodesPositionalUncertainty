function centroid = leadDBSSegmentAndComputeCentroid(sl, dwnSmpRate, upFactor, sliceNum, projectedPos, xMaskLength, yMaskLength, estimatedDirSVD)

% Distance between consecutive slices in millimeters
dwnSmpRateX = dwnSmpRate(1);
dwnSmpRateY = dwnSmpRate(2);
dwnSmpRateZ = dwnSmpRate(3);

[a, b] = size(sl);

% Upsample slice for clear segmentation
[X, Y] = meshgrid(1:1:b, 1:1:a);
[Xq,Yq] = meshgrid(1:1/upFactor:b, 1:1/upFactor:a);
Vq = interp2(X,Y,sl,Xq,Yq,'cubic');
I = mat2gray(Vq);

[dim1,dim2] = size(Xq);
% If first slice, update dummy mask size and choose the starting location
% and mask size based on estimated direction
if(sliceNum == 2)
    estimatedDirX = estimatedDirSVD(1);
    estimatedDirY = estimatedDirSVD(2);
    if(estimatedDirX > 0 && estimatedDirY > 0)
            % Choose centre of the first quadrant in testImageSpace (nonupsampled)
            projectedPos(1) = floor(dim1/8)/upFactor*dwnSmpRateX;
            projectedPos(2) = floor(dim2/8)/upFactor*dwnSmpRateY;
            % mask length
            xMaskLength = floor((dim1));
            yMaskLength = floor((dim2));
    elseif(estimatedDirX > 0 && estimatedDirY < 0)
            % Choose centre of the first quadrant in testImageSpace (nonupsampled)
            projectedPos(1) = floor(dim1/8)/upFactor*dwnSmpRateX;
            projectedPos(2) = floor(7*dim2/8)/upFactor*dwnSmpRateY;
            % mask length
            xMaskLength = floor((dim1));
            yMaskLength = floor((dim2));
     elseif(estimatedDirX < 0 && estimatedDirY > 0)
            % Choose centre of the first quadrant in testImageSpace (nonupsampled)
            projectedPos(1) = floor(7*dim1/8)/upFactor*dwnSmpRateX;
            projectedPos(2) = floor(dim2/8)/upFactor*dwnSmpRateY;
            % mask length
            xMaskLength = floor((dim1));
            yMaskLength = floor((dim2));
      elseif(estimatedDirX < 0 && estimatedDirY < 0)
            % Choose centre of the first quadrant in testImageSpace (nonupsampled)
            projectedPos(1) = floor(7*dim1/8)/upFactor*dwnSmpRateX;
            projectedPos(2) = floor(7*dim2/8)/upFactor*dwnSmpRateY;
            % mask length
            xMaskLength = floor((dim1));
            yMaskLength = floor((dim2));
    end
% Program mask length for slices other than the slice number 2
else    
        xMaskLength = floor((3*dim1/4));
        yMaskLength = floor((3*dim2/4));
end

% Compute threshold within Mask around projected cetntroid
%level = graythresh(I);
% compute mean and add 0.9*stddev to mean to get threshold
% Projected position in resampled space1
% Projected position is always specified with coordinates considering
% downsampling rate
% To get the number of slice for projected position, coordinate should be first
% divided by the downsampling rate
xProj = ((projectedPos(1)/dwnSmpRateX)+1)*upFactor;
yProj = ((projectedPos(2)/dwnSmpRateY)+1)*upFactor;
% To avoid index out of bounds
xMin = max(1, ceil(xProj - xMaskLength/2));
xMax = min(dim1, floor(xProj + xMaskLength/2));
yMin = max(1, ceil(yProj - yMaskLength/2));
yMax = min(dim2, floor(yProj + yMaskLength/2));
xMask = xMin:xMax;
yMask = yMin:yMax;
maskedData = I(xMask',yMask');
mn = mean(maskedData(:));
dev = std(maskedData(:));
level = mn + 0.9*dev;

% Threshold Image
[x, y] = find(I >= level);

% Find coordinates of pixels above threshold from the thresholded version of the input image [x,y] within the Mask
count = 1;
for i=1:length(x)
        if x(i) >= xMask(1) && x(i) <= xMask(end) && y(i) >= yMask(1) && y(i) <= yMask(end)
            xWithinMask(count) = x(i);
            yWithinMask(count) = y(i);
            count = count + 1;
        end
end

% This is inreference to what we visually see and how data is stored. Every
% attemt is made to be consistent with the origin in visual scene for
% deciding IP
%  The plane at location l has coordinates (l-1)*dwnSmpRate. eg, coordinate
%  of plane 1 is 0
%centroid = [ (a-1)*dwnSmpRateX - ((mean(x)/upFactor)-1)*dwnSmpRateX, (b-1)*dwnSmpRateY - ((mean(y)/upFactor) - 1)*dwnSmpRateY, sliceNum];
centroid = [ ((mean(xWithinMask)/upFactor)-1)*dwnSmpRateX, ((mean(yWithinMask)/upFactor) - 1)*dwnSmpRateY, sliceNum*dwnSmpRateZ];

% BW = imbinarize(I,level);
% figure
% imshowpair(I,BW,'montage')

dupBW = zeros(size(I));
BW = imbinarize(I(xMask,yMask),level);
dupBW(xMask, yMask) = BW;
figure
imshowpair(I,dupBW,'montage')