% Compute physical spread of four DBS electrodes along X, Y, and Z
% directions from input test image

% testImage: input test image
% dwnSmpRate: inter-slice distance in mm for the testImage
% estimatedContactStretch: stretch of a single elctrode computed
% analytically for a initial estimate of a trajectory

function imageStretch = latestSyntheticDataImageStretch(testImage, dwnSmpRate, estimatedContactStretch)

    [tx, ty, tz] = size(testImage);

    dwnX = dwnSmpRate(1);
    dwnY = dwnSmpRate(2);
    dwnZ = dwnSmpRate(3);
    
    % Compute total stretch of four electrodes from input test image
    % Image artifacts are seen on first as well as the last slice because
    % of the averaging with kernel a.k.a. partial volume effect simulation
    Sx = (tx-1)*dwnX;
    Sy = (ty-1)*dwnY;
    Sz = (tz-1)*dwnZ;
    
estCx = estimatedContactStretch(1);
estCy = estimatedContactStretch(2);
estCz = estimatedContactStretch(3);

% Minor adjustments to Sx, Sy, Sz may be done as follows:

% if analytically computed stretch for a single contact is greater
% downsampling rate, then test image is highly likely to capture electrode
% image one of the slices
if(estCx > dwnX)
    % (Number of slices on which artifacts can be seen - 1)*dwnSamplingRate
    % + min(downSamplingRate, contactStretch)
    stretchX = Sx;
else
    % Oterwise, contact can completely lie between the planes
    stretchX = Sx + estCx;
end

if(estCy > dwnY)
    stretchY = Sy;
else
    % since contact can completely lie between the planes
    stretchY = Sy + estCy;
end

if(estCz > dwnZ)
    stretchZ = Sz;
else
    % since contact can completely lie between the planes
    stretchZ = Sz + estCz;
end

imageStretch = [stretchX, stretchY, stretchZ];
