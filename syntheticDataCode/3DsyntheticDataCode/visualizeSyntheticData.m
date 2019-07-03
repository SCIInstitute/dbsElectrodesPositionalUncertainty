% Store visualization files into a specified directory. The generated
% visualization files can be visualized in ParaView

% foldername: Directory in which you want to store the visualization files
% uncertainCenterPos: Point cloud representing uncertain contact center
% positions for all four DBS contacts
% uncertainCenterLikelihood: existential likelihood values for points in a point cloud
% represented by uncertainCenterPos
% mostProbableCenterPos: Spatial positions with highest exitential
% likelihood for contacts
% mostProbableCenterLikelihood: Existential likelihood for point
% represented by mostProbableCenterPos
% trueCenterPos: True spatial positions for DBS contacts (computed analytically 
% by mapping geometry (Sec. 3.1 in paper) to volume)
% trueCenterLikelihood: Existential likelihood of true DBS center positions
% (which is 1 always)
% method, testImage, dwnSmpRate, resX, resY, resZ, signArray: interpolation
% method, the test image, inter-slice distance in mm for the test image,
% resolution of the test image, information relevant to directional
% orientation of contact 3.

function visualizeSyntheticData(foldername, uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, trueCenterPos, trueCenterLikelihood, method, testImage, dwnSmpRate, resX, resY, resZ, signArray)

% Save center positions and likelihood data (point cloud) to visualization
% files.
saveCentersAndLikelihood(foldername, uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, trueCenterPos, trueCenterLikelihood, testImage, dwnSmpRate);

% Store volumes representing uncertain DBS-contact positions based on their spatial positions
arrayLength = resX*resY*resZ;

for  i = 1:4
xLoc = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,1), [resX, resY, resZ]);
yLoc = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,2), [resX, resY, resZ]);
zLoc = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,3), [resX, resY, resZ]);
V = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,4), [resX, resY, resZ]);

xArr = squeeze(xLoc(:,1,1));
yArr = squeeze(yLoc(1,:,1));
zArr = squeeze(zLoc(1,1,:));

% To make X array consistent with XLoc array after calling meshgrid
% Y turns out to be consisten with yLoc
[X, Y, Z] = ndgrid(xArr, yArr, zArr);

% Resample scalar grid to a higher resolution
minX = min(xArr);
maxX = max(xArr);
minY = min(yArr);
maxY = max(yArr);
minZ = min(zArr);
maxZ = max(zArr);

% The values in xArr, yArr and zArr are always decreasing since we contact
% centers get closer as we increase offset
resampleXArr = linspace(maxX, minX, 128);
resampleYArr = linspace(maxY, minY, 128);
resampleZArr = linspace(maxZ, minZ, 128);
    
[Xq, Yq, Zq] = ndgrid(resampleXArr, resampleYArr, resampleZArr);

Vq = interpn(X,Y,Z,V, Xq,Yq,Zq);
vtkwrite(strcat(foldername, 'contact',num2str(i),'.vtk'), 'structured_grid', Xq, Yq, Zq, 'scalars', 'likelihood', Vq); 
end


