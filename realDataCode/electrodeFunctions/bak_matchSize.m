function [t1,t2, averageMismatch] = matchSize(testImage, dwnV, IP, signArray, bOuter)

% Do any changes at the end of data and not the start of the data
% So, at the 'post' part. See how many of planes are comparable and derive
% statistics on them
[tx, ty, tz] = size(testImage);
[vx, vy, vz] = size(dwnV);
[bx, by, bz] = size(bOuter);

avgBoxSize = [(bx+ (bx-1))/2, (by+ (by-1))/2, (bz+ (bz-1))/2];

diffx = abs(avgBoxSize(1) - vx);
diffy = abs(avgBoxSize(2) - vy);
diffz = abs(avgBoxSize(3) - vz);

% Number of image planes to compare near the terminal contact
numPlanesX = vx;
numPlanesY = vy;
numPlanesZ = 1;
averageMismatch = (diffx + diffy + diffz)/3;

% t1 = dwnV;
i1 = IP(1);
i2 = IP(2);
i3 = IP(3);
% if signArray(1) >0 && signArray(2) >0
%     t2 = testImage(i1:i1+vx-1, i2:i2+vy-1, i3:i3+vz-1);
% elseif signArray(1) <0 && signArray(2) >0
%     t2 = testImage(i1-vx+1:i1, i2:i2+vy-1, i3:i3+vz-1);
% elseif signArray(1) >0 && signArray(2) <0
%     t2 = testImage(i1:i1+vx-1, i2-vy+1:i2, i3:i3+vz-1);
% elseif signArray(1) <0 && signArray(2) <0
%     t2 = testImage(i1-vx+1:i1, i2-vy+1:i2, i3:i3+vz-1);
% end

if signArray(1) >0 && signArray(2) >0
    t1 = dwnV(1:numPlanesX, 1:numPlanesY, 1:numPlanesZ);
    t2 = testImage(i1:i1+numPlanesX-1, i2:i2+numPlanesY-1, i3:i3+numPlanesZ-1);
elseif signArray(1) <0 && signArray(2) >0
    t1 = dwnV(vx-numPlanesX+1:vx, 1:numPlanesY, 1:numPlanesZ);
    t2 = testImage(i1-numPlanesX+1:i1, i2:i2+numPlanesY-1, i3:i3+numPlanesZ-1);
elseif signArray(1) >0 && signArray(2) <0
    t1 = dwnV(1:numPlanesX, vy-numPlanesY+1:vy, 1:numPlanesZ);
    t2 = testImage(i1:i1+numPlanesX-1, i2-numPlanesY+1:i2, i3:i3+numPlanesZ-1);
elseif signArray(1) <0 && signArray(2) <0
    t1 = dwnV(vx-numPlanesX+1:vx, vy-numPlanesY+1:vy, 1:numPlanesZ);
    t2 = testImage(i1-numPlanesX+1:i1, i2-numPlanesY+1:i2, i3:i3+numPlanesZ-1);
end

