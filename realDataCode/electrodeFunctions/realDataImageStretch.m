function imageStretch = realDataImageStretch(dwnSmpRate, croppedRealData, estimatedContactStretch)

% Preprocessed real data
[dimX, dimY, dimZ] = size(croppedRealData);

estCx = estimatedContactStretch(1);
estCy = estimatedContactStretch(2);
estCz = estimatedContactStretch(3);

dwnX = dwnSmpRate(1);
dwnY = dwnSmpRate(2);
dwnZ = dwnSmpRate(3);

totalDistXmm = dwnSmpRate(1)* (dimX-3);
totalDistYmm = dwnSmpRate(2)* (dimY-3);
totalDistZmm = dwnSmpRate(3)* (dimZ-3);

if(estCx > dwnX)
    % (Number of slices on which artifacts can be seen - 1)*dwnSamplingRate
    % + min(downSamplingRate, contactStretch)
    stretchX = totalDistXmm + dwnX;
else
    % since contact can completely lie between the planes
    stretchX = totalDistXmm + estCx;
end

if(estCy > dwnY)
    stretchY = totalDistYmm + dwnY;
else
    % since contact can completely lie between the planes
    stretchY = totalDistYmm + estCy;
end

if(estCz > dwnZ)
    stretchZ = totalDistZmm + dwnZ;
else
    % since contact can completely lie between the planes
    stretchZ = totalDistZmm + estCz;
end

imageStretch = [stretchX, stretchY, stretchZ];