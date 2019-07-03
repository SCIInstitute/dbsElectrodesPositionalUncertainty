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
% method, testImage, dwnSmpRate, resX, resY, resZ, signArray: interpolation
% method, the test image, inter-slice distance in mm for the test image,
% resolution of the test image, information relevant to directional
% orientation of contact 3.

function visualizeRealData(uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, method, testImage, dwnSmpRate, resX, resY, resZ)

foldername = strcat('results/patient1/vis/',method, '/');

% Save center positions and likelihood data (point cloud) to visualization
% files.
saveCentersAndLikelihood(foldername, uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, testImage, dwnSmpRate);

arrayLength = resX*resY*resZ;
for  i = 1:4
xLoc = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,1), [resX, resY, resZ]);
yLoc = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,2), [resX, resY, resZ]);
zLoc = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,3), [resX, resY, resZ]);
V = reshape(uncertainCenterPos((i-1)*arrayLength+1:i*arrayLength,4), [resX, resY, resZ]);

xArr = squeeze(xLoc(:,1,1));
yArr = squeeze(yLoc(1,:,1));
zArr = squeeze(zLoc(1,1,:));

[X, Y, Z] = ndgrid(xArr, yArr, zArr);

% Resample scalar grid to a higher resolution
minX = min(xArr);
maxX = max(xArr);
minY = min(yArr);
maxY = max(yArr);
minZ = min(zArr);
maxZ = max(zArr);

resampleXArr = linspace(maxX, minX, 128);
resampleYArr = linspace(maxY, minY, 128);
resampleZArr = linspace(maxZ, minZ, 256);
[Xq, Yq, Zq] = ndgrid(resampleXArr, resampleYArr, resampleZArr);

Vq = interpn(X,Y,Z,V,Xq,Yq,Zq);
vtkwrite(strcat(foldername, 'contact',num2str(i),'.vtk'), 'structured_grid', Xq, Yq, Zq, 'scalars', 'likelihood', Vq); 
end


