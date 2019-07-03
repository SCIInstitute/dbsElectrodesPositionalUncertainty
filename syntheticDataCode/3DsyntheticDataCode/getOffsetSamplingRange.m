% Range in millimeters to draw Monte Carlo samples from.
% Each Monte Carlo sample will represent number of samples
% The code below assumes numPlanes values to be greater than four 
function range = getOffsetSamplingRange(dwnSmpRate, gtMPContactStretchArr, numPlanes)

% Find contact stretch for the most probable (mean) direction
Cx = gtMPContactStretchArr(1);
Cy = gtMPContactStretchArr(2);
Cz = gtMPContactStretchArr(3);

% All in millemeters
dwnSmpRateX = dwnSmpRate(1);
dwnSmpRateY = dwnSmpRate(2);
dwnSmpRateZ = dwnSmpRate(3);

start = numPlanes - 4 ;
finish = numPlanes + 4;

if(dwnSmpRateX > Cx)
   lowX = start*dwnSmpRateX;
   highX =finish*dwnSmpRateX;
else
   lowX = start*dwnSmpRateX;
   highX = finish*dwnSmpRateX;
end

if(dwnSmpRateY > Cy)
      lowY = start*dwnSmpRateY;
      highY = finish*dwnSmpRateY;
else
       lowY = start*dwnSmpRateY;
       highY = finish*dwnSmpRateY;
end

if(dwnSmpRateZ > Cz)
       lowZ = (start+2.8)*dwnSmpRateZ;
       highZ = (finish-2.6)*dwnSmpRateZ;
else
        lowZ = (start+2.8)*dwnSmpRateZ;
       highZ = (finish-2.6)*dwnSmpRateZ;
end

range = [lowX, highX, lowY, highY, lowZ, highZ];