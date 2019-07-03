function [ccpVol,  xOffsetSmpRate, yOffsetSmpRate, zOffsetSmpRate] = quantifyCCPparallel(gtFinal, dwnSmpRate, contactStretch, testImage, IP)

[offsetLowX, offsetHighX, offsetLowY, offsetHighY, offsetLowZ, offsetHighZ] = quantifyOffsetRange(dwnSmpRate, contactStretch);


sX = contactStretch(1);
sY = contactStretch(2);
sZ = contactStretch(3);

% IPx = IP(1);
% IPy = IP(2);
% IPz = IP(3);

IPx = 0;
IPy = 0;
IPz = 0;

% Generate downsampled volumes and quantify correlation between downsampled
% volume and the test image.

% Select offset sampling rate in millimeters in X, Y and Z directions that
% divides Sx, Sy and Sz (explained further why).
xOffsetSmpRate =  sX/63;
yOffsetSmpRate = sY/63;
zOffsetSmpRate = sZ/63;

% Record contact center position with respect to the initial plane.
xOffsets = offsetLowX: xOffsetSmpRate : offsetHighX;
yOffsets = offsetLowY: yOffsetSmpRate: offsetHighY;
zOffsets = offsetLowZ: zOffsetSmpRate: offsetHighZ;

% terminalContactCenterPos = zeros(numel(xOffsets)*numel(yOffsets)*numel(zOffsets),3);
% CCP = zeros(numel(xOffsets)*numel(yOffsets)*numel(zOffsets),1);

% Initial plane is a starting plane for DBS electrode terminal contact in each of the directions for the test image 
% Generate a uniform volume  [IPx - sX/2, IPx + sX/2] with offset sampling
% rate which divides sX (explained further..) and fill out proper entries and correponding center probability

% Observation: If the offset sampling rate divides stretch completely, it will lead to evenly spaced grid. Also, one of the
% grid location will coinside with the initial plane indicated by IP
% exactly at the center of the volume formed by xRange, yRange, zRange

% Ranges for contact center

xRange = IPx - sX/2: xOffsetSmpRate :IPx + sX/2;
yRange = IPy - sY/2: yOffsetSmpRate :IPy + sY/2;
zRange = IPz - sZ/2: zOffsetSmpRate :IPz + sZ/2;

disp(strcat('Center range X:', num2str(IPx + sX/2 - offsetHighX), ' mm to', ' ', num2str(IPx + sX/2), ' mm'));
disp(strcat('Center range Y:', num2str(IPy + sY/2 - offsetHighY), ' mm to', ' ', num2str(IPy + sY/2), ' mm'));
disp(strcat('Center range Z:', num2str(IPz + sZ/2 - offsetHighZ), 'mm to ', ' ', num2str(IPz + sZ/2), ' mm'));

% IPs are center planes in X, Y and Z directions. Alighn them with initial
% plane in the target image

ccpVol = zeros(numel(xRange), numel(yRange), numel(zRange));
tempVol = zeros(1,numel(xRange)*numel(yRange)*numel(zRange));

tic
parfor n = 1:numel(xOffsets)*numel(yOffsets)*numel(zOffsets)
        [i, j, k] = ind2sub([numel(xOffsets), numel(yOffsets), numel(zOffsets)], n);
        oX = xOffsets(i);
        oY = yOffsets(j);
        oZ = zOffsets(k);
        dwnV = dwnsamSpacingOffset(gtFinal, dwnSmpRate, [oX, oY, oZ], 'cubic');
        c = corrcoef(dwnV,testImage);
        corrval = c(1,2);        
        tempVol(n) = corrval;
end

for n = 1:numel(xOffsets)*numel(yOffsets)*numel(zOffsets)
    [i, j, k] = ind2sub([numel(xOffsets), numel(yOffsets), numel(zOffsets)], n);
    ccpVol(numel(xRange) - (i-1), numel(yRange) - (j-1), numel(zRange) - (k-1)) = tempVol(n);
end
toc 
% IPx = IP(1);
% IPy = IP(2);
% IPz = IP(3);


% for i =1:numel(xOffsets)
%     for j = 1:numel(yOffsets)
%         for k= 1:numel(zOffsets)
%             % contact 0 center varies in the range [IP-Sx/2+slicewidth, IP+Sx/2]     
%             % Sx > inter-slice Distance 
%             oX = xOffsets(i);
%             oY = yOffsets(j);
%             oZ = zOffsets(k);
%             dwnV = dwnsamSpacingOffset(gtFinal, dwnSmpRate, [oX, oY, oZ], 'cubic');
%             
%             c = corrcoef(dwnV,testImage);
%           
%             % Pattern for values produced
%             % posX = IPx + sX/2 - oX;
%             % posX = IPx + sX/2 - 2*oX;
%             % posX = IPx + sX/2 - 3*oX;
%             % Therefore, ccpVol(numel(xRange) - (i-1))
%             % Similarly, ccpVol(numel(yRange) - (j-1))
%             % Similarly, ccpVol(numel(zRange) - (k-1))
%              ccpVol(numel(xRange) - (i-1), numel(yRange) - (j-1), numel(zRange) - (k-1)) = c(1,2);
%             
%         end
%     end
% end











