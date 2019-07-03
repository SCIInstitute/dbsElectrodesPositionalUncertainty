function range = getOffsetSamplingRange(dwnSmpRate, gtMPContactStretchArr, numPlanes)

% Find contact stretch for the most probable direction
Cx = gtMPContactStretchArr(1);
Cy = gtMPContactStretchArr(2);
Cz = gtMPContactStretchArr(3);

% All in millemeters
dwnSmpRateX = dwnSmpRate(1);
dwnSmpRateY = dwnSmpRate(2);
dwnSmpRateZ = dwnSmpRate(3);

startX = numPlanes - 2.8 ;
finishX = numPlanes + 4.4;

startY = numPlanes - 4.7 ;
finishY = numPlanes + 4;

startZ = numPlanes - 2.7 ;
finishZ = numPlanes + 2;

% startX = numPlanes - 6 ;
% finishX = numPlanes + 6;
% 
% startY = numPlanes - 6;
% finishY = numPlanes + 6;
% 
% startZ = numPlanes - 3 ;
% finishZ = numPlanes + 2;

if(dwnSmpRateX > Cx)
   lowX = startX*dwnSmpRateX;
   highX =finishX*dwnSmpRateX;
else
   lowX = startX*dwnSmpRateX;
   highX = finishX*dwnSmpRateX;
end

if(dwnSmpRateY > Cy)
      lowY = startY*dwnSmpRateY;
      highY = finishY*dwnSmpRateY;
else
       lowY = startY*dwnSmpRateY;
       highY = finishY*dwnSmpRateY;
end

if(dwnSmpRateZ > Cz)
%        lowZ = (startZ+2)*dwnSmpRateZ;
%        highZ = (finishZ-2)*dwnSmpRateZ;
       lowZ = (startZ)*dwnSmpRateZ;
       highZ = (finishZ)*dwnSmpRateZ;
else
       lowZ = (startZ)*dwnSmpRateZ;
       highZ = (finishZ)*dwnSmpRateZ;
end

range = [lowX, highX, lowY, highY, lowZ, highZ];