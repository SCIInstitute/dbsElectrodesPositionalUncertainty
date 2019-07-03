function isosurfaceVis(X, Y, Z, V, isoval)

% Starting Isosurface
p = patch(isosurface(X,Y,Z,V,isoval));
isonormals(X,Y,Z,V,p)
p.FaceColor = 'red';
p.EdgeColor = 'none';
daspect([1 1 1])
view([-1 -0.12 0.12]); 
%axis tight
axis off
grid off
camlight 
lighting gouraud