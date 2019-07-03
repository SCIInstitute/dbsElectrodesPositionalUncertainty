% get volume cropping based on  bounding box of the isosurface
function croppedV = getCroppedVol(V, isoval)

% Extract isosurface vertices and faces
[a, b, c] = size(V);
[X,Y,Z] = meshgrid(1:1:b,1:1:a,1:1:c);
[fac, ver] = isosurface(X,Y,Z,V,isoval);

% Find the minimum bounding box around the isosurface vertices
x = ver(:,1);
y = ver(:,2);
z = ver(:,3);
[rotmat,cornerp] = minboundbox(x,y,z,'v',3);

minX = ceil(min(cornerp(:,2)));
maxX = floor(max(cornerp(:,2)));
minY = ceil(min(cornerp(:,1)));
maxY = floor(max(cornerp(:,1)));
minZ = ceil(min(cornerp(:,3)));
maxZ = floor(max(cornerp(:,3)));

% You might need to manually make minor adjustments to the bounding box limits, since algorithm
% tries best for accurate limits
croppedV = V(minX:maxX,minY:maxY,minZ:maxZ-1);
% [aCrop, bCrop, cCrop] = size(croppedV);
% [XCrop,YCrop,ZCrop] = meshgrid(1:1:bCrop,1:1:aCrop,1:1:cCrop);
% figure;
% isosurfaceVis(XCrop,YCrop,ZCrop,croppedV,isoval);