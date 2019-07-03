% Conver vtk file to csv file in paraview
% Read CSV file 
% CSV Column 1: likelihood
% CSV Column 2: X
% CSV Column 3: Y
% CSV Column 4: Z

function [expected, var, std] = getExpectedPosAndVariance(filename, threshold)

V = csvread(filename,1,0);
tempV = V;

VCropped = V(find(tempV(:,1)>threshold),:);
%Normalize column 1 of V
VCropped(:,1) = VCropped(:,1)/sum(VCropped(:,1));
expectedX = sum(VCropped(:,1).*VCropped(:,2));
expectedY = sum(VCropped(:,1).*VCropped(:,3));
expectedZ = sum(VCropped(:,1).*VCropped(:,4));
expected = [expectedX, expectedY, expectedZ];

% varX = sum(VCropped(:,1).*((VCropped(:,2) - expectedX).^2))
% varY = sum(VCropped(:,1).*((VCropped(:,3) - expectedY).^2))
% varZ = sum(VCropped(:,1).*((VCropped(:,4) - expectedZ).^2))
% 
% var = norm([varX, varY, varZ]);
% 
% stdx = sqrt(varX);
% stdy = sqrt(varY);
% stdz = sqrt(varZ);

%std = norm([stdx, stdy, stdz]);

meanVariation = VCropped(:,2:4) - [expectedX, expectedY, expectedZ];
%rowVar = sqrt(meanVariation(:,1).^2 + meanVariation(:,2).^2 +meanVariation(:,3).^2);
rowVar = meanVariation(:,1).^2 + meanVariation(:,2).^2 +meanVariation(:,3).^2;
var = sum(VCropped(:,1).*rowVar);
std = sqrt(var);

