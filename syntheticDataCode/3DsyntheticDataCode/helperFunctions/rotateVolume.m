% V is volume and trf is transformation matrix
function rotatedV = rotateVolume (V,trf)
tform = affine3d(trf);
rotatedV = imwarp(V,tform);







