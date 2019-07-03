% Function to downsample a high-resolution image
% V: High-resolution image 
% dwnRate: downsampling rate (in mm)
% offset: Starting offset (in mm) along X, Y,Z directions used for
% downsampling
% voxelSpacing: spacing between voxels in mm for the rotated ground truth
% image
% interp: Kernal used for downsampling process
% noiseDeviation: simulate reconstruction noise
% kSize: the support of the interpolation kernel (lxmxn mm^3)
function dwnV = fastFilterImageWithOffset(V, dwnRate, offset,  interp, voxelSpacing, kSize, signArray)

[a, b, c] = size(V);

offset = [round(offset(1)/voxelSpacing(1,1)), round(offset(2)/voxelSpacing(1,2)), round(offset(3)/voxelSpacing(1,3))];
smpRate = [round(dwnRate(1)/voxelSpacing(1,1)), round(dwnRate(2)/voxelSpacing(1,2)), round(dwnRate(3)/voxelSpacing(1,3))];

% xArr = 1+offset(1):smpRate(1):a - floor(smpRate(1)/2);
% yArr = 1+offset(2):smpRate(2):b - floor(smpRate(2)/2);
% zArr = 1+offset(3):smpRate(3):c - floor(smpRate(3)/2);
 xArr = 1+offset(1):smpRate(1):a;
 yArr = 1+offset(2):smpRate(2):b;
 zArr = 1+offset(3):smpRate(3):c;

 % Confirm the following
 % For -ve directions V contains data stored in appropriate 
%Depending upon the signArray, choose xArr, yArr or zArr direction
% Downsample (pick planes at specific offset)
% if(signArray(1) > 0 && signArray(2) > 0)	
% 	xArr = 1+offset(1):smpRate(1):a;
%     yArr = 1+offset(2):smpRate(2):b;
%     zArr = 1+offset(3):smpRate(3):c;
% elseif(signArray(1) > 0 && signArray(2) < 0)	
% 	xArr = 1+offset(1):smpRate(1):a;
%     yArr = b-offset(2):-smpRate(2):1;
%     zArr = 1+offset(3):smpRate(3):c;
% elseif(signArray(1) < 0 && signArray(2) > 0)
% 	xArr = a-offset(1):-smpRate(1):1;
%     yArr = 1+offset(2):smpRate(2):b;
%     zArr = 1+offset(3):smpRate(3):c;
% elseif(signArray(1) < 0 && signArray(2) < 0)
%     % weird MATLAB storage when both X and Y are -ve/+ve
% % 	xArr = a-offset(1):-smpRate(1):1;
% %     yArr = b-offset(2):-smpRate(2):1;
% %     zArr = 1+offset(3):smpRate(3):c;
%     xArr = 1+offset(1):smpRate(1):a;
%     yArr = 1+offset(2):smpRate(2):b;
%     zArr = 1+offset(3):smpRate(3):c;
% end

% Convert kernel size specified in mm into number of voxels
kSize(1,1) = round(kSize(1,1)/voxelSpacing(1,1));
kSize(1,2) = round(kSize(1,2)/voxelSpacing(1,2));
kSize(1,3) = round(kSize(1,3)/voxelSpacing(1,3));

% Keep kernel size odd so that it can be centered on a voxel 
if(mod(kSize(1),2) == 0)
    kernelSizeX = kSize(1) + 1;
else
    kernelSizeX = kSize(1);
end
if(mod(kSize(2),2) == 0)
    kernelSizeY = kSize(2) + 1;
else
    kernelSizeY = kSize(2);
end
if(mod(kSize(3),2) == 0)
    kernelSizeZ = kSize(3) + 1;
else
    kernelSizeZ = kSize(3);
end
kernelSize = [kernelSizeX, kernelSizeY,kernelSizeZ];

h = fspecial3(interp,kernelSize); 
dwnV = zeros(numel(xArr), numel(yArr), numel(zArr));

for i = 1:numel(xArr)
    for j = 1:numel(yArr)
        for k=1:numel(zArr)
            % get a block of filter size at specific voxel in groundtruth
            % image
%             i = 9;
%             j = 1;
%             k = 1;
            xlow = xArr(i) - (kernelSize(1)-1)/2;
            xhigh = xArr(i) + (kernelSize(1)-1)/2;
            ylow = yArr(j) -(kernelSize(2)-1)/2;
            yhigh = yArr(j) + (kernelSize(2)-1)/2;
            zlow = zArr(k) - (kernelSize(3)-1)/2;
            zhigh = zArr(k) +(kernelSize(3)-1)/2;
            limits = [xlow, xhigh, ylow, yhigh, zlow, zhigh];
            subvol = getSubsetVolume(V,limits);
            dwnV(i,j,k) = sum(sum(sum(h.*subvol)));
        end
    end
end
