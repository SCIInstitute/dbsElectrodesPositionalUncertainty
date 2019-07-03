function renderIsosurface(V,isoval,ax,color,alpha,viewDirection)

% Load electrode data
[a, b, c] = size(V);

% Create a meshgrid
[X,Y,Z] = meshgrid(1:1:b,1:1:a,1:1:c);

% Render isosurface: Isovalue 28
[fac, ver] = isosurface(X,Y,Z,V,isoval);

%getRotationMatrixBB(ver)

p = patch(ax,isosurface(X,Y,Z,V,isoval));
isonormals(X,Y,Z,V,p)
p.FaceColor = color;
p.FaceAlpha = alpha;
p.EdgeColor = 'none';
daspect([1 1 1])
view(3); 
%axis tight
camlight 
lighting gouraud