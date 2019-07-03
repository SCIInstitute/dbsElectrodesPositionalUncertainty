% V: Input data
% smpRate: Downsample Rate in millimeters
% offset: offset from the starting slice in millimeters

function dwnV = dwnsampleWithOffset(V, dwnRate, offset,  interp, voxelSpacing)

offset = [floor(offset(1)/voxelSpacing(1,1)), floor(offset(2)/voxelSpacing(1,2)), floor(offset(3)/voxelSpacing(1,3))];
smpRate = [floor(dwnRate(1)/voxelSpacing(1,1)), floor(dwnRate(2)/voxelSpacing(1,2)), floor(dwnRate(3)/voxelSpacing(1,3))];

[a, b, c] = size(V);
[x,y,z] = ndgrid(1:1:a,1:1:b,1:1:c);
[xi,yi,zi] = ndgrid(1+offset(1):smpRate(1):a+offset(1),1+offset(2):smpRate(2):b+offset(2),1+offset(3):smpRate(3):c+offset(3));
% 0 for values that lie outside domain
dwnV = interpn(x,y,z,V,xi,yi,zi,interp,0);


%str1 = ['Down Sampling Rate: ',  num2str(smpRate(1)), ' ', num2str(smpRate(2)), ' ', num2str(smpRate(3)), ' '];
%str2 = ['Offset: ',  num2str(offset(1)), ' ', num2str(offset(2)), ' ', num2str(offset(3)), ' '];
% disp(str1);
% disp(str2);

% smpRate = [ceil(dwnRate(1)/voxelSpacing(1,1)), ceil(dwnRate(2)/voxelSpacing(1,2)), ceil(dwnRate(3)/voxelSpacing(1,3))];
% offset = [ceil(offset(1)/voxelSpacing(1,1)), ceil(offset(2)/voxelSpacing(1,2)), ceil(offset(3)/voxelSpacing(1,3))];
% 
% 
% [a, b, c] = size(V);
% [x,y,z] = ndgrid(1:1:a,1:1:b,1:1:c);
% [xi,yi,zi] = ndgrid(1+offset(1):smpRate(1):a+offset(1),1+offset(2):smpRate(2):b+offset(2),1+offset(3):smpRate(3):c+offset(3));
% % 0 for values that lie outside domain
% dwnV = interpn(x,y,z,V,xi,yi,zi,interp,0);