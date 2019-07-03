% Compute contact-center position for a Monte Carlo sample (low resolution)
% dwnV: a Monte Carlo sample
% dwnSmpRate: inter-slice distance in mm for the test image
% gtMPContactStretchArr: Stretch of a single DBS electrode along X-Y-Z in mm for
% the mean DBS lead direction
% gtMPElectrodeStretchArr: Stretch of four DBS electrodes along X-Y-Z in mm for
% the mean DBS lead direction
% signArray: Manages the orientation of the terminal contact (contact number 3 for indexing 0-1-2-3 (see Fig. 2a in the paper))
% numPlanes: number of zero planes appended on both sides in the ground
% truth image
function center = computeCenterLocation(numPlanes, dwnV, offset, dwnSmpRate, signArray, gtMPContactStretchArr, gtMPElectrodeStretchArr)

    oX = offset(1);
    oY = offset(2);
    oZ = offset(3);

    Cx = gtMPContactStretchArr(1);
    Cy = gtMPContactStretchArr(2);
    Cz = gtMPContactStretchArr(3);
    
    Ex = gtMPElectrodeStretchArr(1);
    Ey = gtMPElectrodeStretchArr(2);
    Ez = gtMPElectrodeStretchArr(3);

totalElectrodeStretchX= numPlanes*dwnSmpRate(1) + Ex + numPlanes*dwnSmpRate(1);
totalElectrodeStretchY= numPlanes*dwnSmpRate(2) + Ey + numPlanes*dwnSmpRate(2);
totalElectrodeStretchZ= numPlanes*dwnSmpRate(3) + Ez + numPlanes*dwnSmpRate(3);

% nonZeroPlanesDwnV = identifyFirstNonZeroPlanesInVolume(dwnV, dwnSmpRate, signArray);
% nonZeroPlanesX = nonZeroPlanesDwnV(1);
% nonZeroPlanesY = nonZeroPlanesDwnV(2);
% nonZeroPlanesZ = nonZeroPlanesDwnV(3);

if(signArray(1) > 0)
    % distance from initial plane at offset oX
    xCenter =  numPlanes*dwnSmpRate(1) + Cx/2 - oX;
   % xCenter = xCenterInitial - (nonZeroPlanesX)*dwnSmpRate(1);
else
    xCenter =  totalElectrodeStretchX - numPlanes*dwnSmpRate(1) - Cx/2 - oX;
   % xCenter = xCenterInitial - (nonZeroPlanesX)*dwnSmpRate(1);
end

if(signArray(2) > 0)
    % distance from initial plane at offset oY
    yCenter =  numPlanes*dwnSmpRate(2) + Cy/2 - oY;
    %yCenter = yCenterInitial - (nonZeroPlanesY)*dwnSmpRate(2);
else
    yCenter =  totalElectrodeStretchY - numPlanes*dwnSmpRate(2) - Cy/2 - oY;
    %yCenter = yCenterInitial - (nonZeroPlanesY)*dwnSmpRate(2);
end

if(signArray(3) > 0)
     % distance from initial plane at offset oZ
    zCenter =  numPlanes*dwnSmpRate(3) + Cz/2 - oZ;
    %zCenter = zCenterInitial - (nonZeroPlanesZ)*dwnSmpRate(3);
else
    zCenter =  totalElectrodeStretchZ - numPlanes*dwnSmpRate(3) - Cz/2 -  oZ;
    %zCenter = zCenterInitial - (nonZeroPlanesZ)*dwnSmpRate(3);
end

center = [xCenter, yCenter, zCenter];
    