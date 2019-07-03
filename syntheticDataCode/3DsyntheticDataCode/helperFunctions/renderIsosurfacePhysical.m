function renderIsosurfacePhysical(V,isoval,ax,color,alpha,viewDirection,physLimits)

% Load data
[a, b, c] = size(V);

% Create a meshgrid
%[X,Y,Z] = meshgrid(1:1:b,1:1:a,1:1:c);

rangeX = linspace(physLimits(1,1),physLimits(1,2),a);
rangeY = linspace(physLimits(1,3),physLimits(1,4),b);
rangeZ = linspace(physLimits(1,5),physLimits(1,6),c);

[X,Y,Z] = meshgrid(rangeY,rangeX,rangeZ);

% Render isosurface: Isovalue 28
[fac, ver] = isosurface(X,Y,Z,V,isoval);

%getRotationMatrixBB(ver)

p = patch(ax,isosurface(X,Y,Z,V,isoval));
isonormals(X,Y,Z,V,p)
p.FaceColor = color;
p.FaceAlpha = alpha;
p.EdgeColor = 'none';
daspect([1 1 1])
view([1.5 2 1]); 
%axis tight
camlight 
lighting gouraud