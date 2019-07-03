% Display spatial uncertainty in a contact center (x-, y-, and z- ranges)
% for the fourth contact (contact number 3 for indexing like 0,1,2,3)

% dwnSmpRate: interslice distance in mm for the test image
% gtMPContactStretchArr: Stretch of a single DBS electrode along X-Y-Z for
% the mean DBS lead direction
% gtMPElectrodeStretchArr: Stretch of four DBS electrodes along X-Y-Z for
% the mean DBS lead direction
% signArray: Manages orientation of the terminal contact (contact number 3)
% numPlanes: number of zero planes appended on both sides in gtMP
% offsetRange: the range (in mm) of offsets to draw Monte Carlo samples
% from
function displayUncertainCenterRange(numPlanes, signArray, dwnSmpRate, gtMPContactStretchArr, gtMPElectrodeStretchArr, offsetRange)

Cx = gtMPContactStretchArr(1);
Cy = gtMPContactStretchArr(2);
Cz = gtMPContactStretchArr(3);

Ex = gtMPElectrodeStretchArr(1);
Ey = gtMPElectrodeStretchArr(2);
Ez = gtMPElectrodeStretchArr(3);

totalElectrodeStretchX= numPlanes*dwnSmpRate(1) + Ex + numPlanes*dwnSmpRate(1);
totalElectrodeStretchY= numPlanes*dwnSmpRate(2) + Ey + numPlanes*dwnSmpRate(2);
totalElectrodeStretchZ= numPlanes*dwnSmpRate(3) + Ez + numPlanes*dwnSmpRate(3);

% Computation of center in SCIRun space
if(signArray(1) > 0)
    xLow =   numPlanes*dwnSmpRate(1) + Cx/2 - offsetRange(2);
    xHigh =  numPlanes*dwnSmpRate(1) + Cx/2 - offsetRange(1);                                       
else
    xLow =  totalElectrodeStretchX - numPlanes*dwnSmpRate(1) - Cx/2 - offsetRange(2);
    xHigh = totalElectrodeStretchX - numPlanes*dwnSmpRate(1) - Cx/2 - offsetRange(1);
end
if(signArray(2) > 0)
     yLow =  numPlanes*dwnSmpRate(2) + Cy/2 - offsetRange(4);
     yHigh = numPlanes*dwnSmpRate(1) + Cy/2 - offsetRange(3);
else
     yLow = totalElectrodeStretchY - numPlanes*dwnSmpRate(2) - Cy/2 - offsetRange(4);
     yHigh =  totalElectrodeStretchY - numPlanes*dwnSmpRate(2) - Cy/2 - offsetRange(3);
end
if(signArray(3) > 0)
     zLow =  numPlanes*dwnSmpRate(3) + Cz/2 - offsetRange(6);
     zHigh = numPlanes*dwnSmpRate(3) + Cz/2 - offsetRange(5);
else
     zLow =   totalElectrodeStretchZ - numPlanes*dwnSmpRate(3) - Cz/2 - offsetRange(6);
     zHigh = totalElectrodeStretchZ - numPlanes*dwnSmpRate(3) - Cz/2 - offsetRange(5);
end

% Display positional uncertainty in contact center for the terminal contact
disp(strcat('Center range X:', num2str(xLow), ' mm to ', ' ', num2str(xHigh), ' mm'));
disp(strcat('Center range Y:', num2str(yLow), ' mm to ', ' ', num2str(yHigh), ' mm'));
disp(strcat('Center range Z:', num2str(zLow), 'mm to ', ' ', num2str(zHigh), ' mm'));