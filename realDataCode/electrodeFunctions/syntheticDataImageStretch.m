function imageStretch = syntheticDataImageStretch(underlyingTrajStretch, dwnSmpRate, offset, estimatedContactStretch)

    Cx = underlyingTrajStretch(1);
    Cy = underlyingTrajStretch(2);
    Cz = underlyingTrajStretch(3);
    Sx = underlyingTrajStretch(4);
    Sy = underlyingTrajStretch(5);
    Sz = underlyingTrajStretch(6);
    
    offsetX =offset(1);
    offsetY =offset(2);
    offsetZ =offset(3);
    
estCx = estimatedContactStretch(1);
estCy = estimatedContactStretch(2);
estCz = estimatedContactStretch(3);

dwnX = dwnSmpRate(1);
dwnY = dwnSmpRate(2);
dwnZ = dwnSmpRate(3);

if(estCx > dwnX)
    % (Number of slices on which artifacts can be seen - 1)*dwnSamplingRate
    % + min(downSamplingRate, contactStretch)
    stretchX = floor((Sx-offsetX)/dwnX)*dwnX + dwnX;
else
    % since contact can completely lie between the planes
    stretchX = floor((Sx-offsetX)/dwnX)*dwnX + estCx;
end

if(estCy > dwnY)
    stretchY = floor((Sy-offsetY)/dwnY)*dwnY + dwnY;
else
    % since contact can completely lie between the planes
    stretchY = floor((Sy-offsetY)/dwnY)*dwnY + estCy;
end

if(estCz > dwnZ)
    stretchZ = floor((Sz-offsetZ)/dwnZ)*dwnZ + dwnZ;
else
    % since contact can completely lie between the planes
    stretchZ = floor((Sz-offsetZ)/dwnZ)*dwnZ + estCz;
end

imageStretch = [stretchX, stretchY, stretchZ];
