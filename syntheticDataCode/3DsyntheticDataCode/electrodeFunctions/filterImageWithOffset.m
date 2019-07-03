function dwnV = filterImageWithOffset(V, dwnRate, offset,  interp, voxelSpacing)

[a, b, c] = size(V);
offset = [floor(offset(1)/voxelSpacing(1,1)), floor(offset(2)/voxelSpacing(1,2)), floor(offset(3)/voxelSpacing(1,3))];
smpRate = [floor(dwnRate(1)/voxelSpacing(1,1)), floor(dwnRate(2)/voxelSpacing(1,2)), floor(dwnRate(3)/voxelSpacing(1,3))];
% Filter width is currently set as a downsampling rate in each direction
% since slice thickness (filter width) being same as the inter-slice (downsampling rate)
% distance makes sense
% For high inter-slice distance you might need to choose smaller thickness
h = fspecial3(interp,smpRate); 
filteredV = imfilter(V,h);
% Select every n'th sample of the filteredV starting at offset. Find
% image slices that capture artifact region
dwnV = filteredV(1+offset(1):smpRate(1):a - floor(smpRate(1)/2),1+offset(2):smpRate(2):floor(b-smpRate(2)/2),1+offset(3):smpRate(3):floor(c-smpRate(3)/2));

