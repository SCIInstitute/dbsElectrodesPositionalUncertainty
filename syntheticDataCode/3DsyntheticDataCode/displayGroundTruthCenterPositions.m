function underlyingPosMM = displayGroundTruthCenterPositions(signArray, dwnSmpRate, testImageOffset, gtMPContactStretchArr, gtMPElectrodeStretchArr,  numPlanes)

oX = testImageOffset(1);
oY = testImageOffset(2);
oZ = testImageOffset(3);

Cx = gtMPContactStretchArr(1);
Cy = gtMPContactStretchArr(2);
Cz = gtMPContactStretchArr(3);

Ex = gtMPElectrodeStretchArr(1);
Ey = gtMPElectrodeStretchArr(2);
Ez = gtMPElectrodeStretchArr(3);

totalElectrodeStretchX= numPlanes*dwnSmpRate(1) + Ex + numPlanes*dwnSmpRate(1);
totalElectrodeStretchY= numPlanes*dwnSmpRate(2) + Ey + numPlanes*dwnSmpRate(2);
totalElectrodeStretchZ= numPlanes*dwnSmpRate(3) + Ez + numPlanes*dwnSmpRate(3);

% Computation of center in space
if(signArray(1) > 0)
    xCenter =  numPlanes*dwnSmpRate(1) + Cx/2 - oX;
else
    xCenter =  totalElectrodeStretchX - numPlanes*dwnSmpRate(1) - Cx/2 - oX;
end
if(signArray(2) > 0)
    yCenter =  numPlanes*dwnSmpRate(2) + Cy/2 - oY;
else
    yCenter =  totalElectrodeStretchY - numPlanes*dwnSmpRate(2) - Cy/2 - oY;
end
if(signArray(3) > 0)
    zCenter =  numPlanes*dwnSmpRate(3) + Cz/2 - oZ;
else
    zCenter =  totalElectrodeStretchZ - numPlanes*dwnSmpRate(3) - Cz/2 -  oZ;
end

underlyingPosMM = [xCenter, yCenter, zCenter];
disp(strcat('The underlying coordinates for the center of the terminal contact:',  ' [', num2str(underlyingPosMM(1)),' mm,', num2str(underlyingPosMM(2)),' mm,', num2str(underlyingPosMM(3)),' mm]'));


