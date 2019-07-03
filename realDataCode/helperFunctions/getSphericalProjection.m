function [x,y,z] = getSphericalProjection(r,phi,theta)
x = r*cosd(theta)*sind(phi);
y = r*sind(theta)*sind(phi);
z = r*cosd(phi);