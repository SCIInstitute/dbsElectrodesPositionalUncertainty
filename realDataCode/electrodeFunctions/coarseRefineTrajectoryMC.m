% Find most probable electrode trajectory by coarse sampling of octant around
% the initial trajectory estimate, followed by matching analytical stretch
% of each Monte-Carlo sample with stretch estimated from image

% estimatedDireSVD:  initial estimate of DBS lead direction
% imElectrodeStretch: stretch of four DBS electrodes estimated from image
% dwnSmpRate: down sampling rate in mm

function sortedTraj = coarseRefineTrajectoryMC(estimatedDirSVD,imElectrodeStretch, dwnSmpRate)

[estPhi, estTheta] = getSphericalCoord(estimatedDirSVD);

% Monte carlo samples for octant
phiArr = 1: 50;
if(estimatedDirSVD(1) > 0 && estimatedDirSVD(2) > 0)
    thetaArr = 1:89;
elseif(estimatedDirSVD(1) < 0 && estimatedDirSVD(2) > 0)
    thetaArr = 91:179;
elseif(estimatedDirSVD(1) < 0 && estimatedDirSVD(2) < 0)
    thetaArr = 181:269;
elseif(estimatedDirSVD(1) > 0 && estimatedDirSVD(2) < 0)
    thetaArr = 271:359;
end
traj = zeros(numel(phiArr)*numel(thetaArr),4);

% Stretch for four electrodes estimated from image
iX = imElectrodeStretch(1);
iY = imElectrodeStretch(2);
iZ = imElectrodeStretch(3);

count = 1;
for i = 1:numel(phiArr)
    for j = 1:numel(thetaArr)
        % get trajectory
        tempPhi = phiArr(i);
        tempTheta = thetaArr(j);
        [x,y,z] = getSphericalProjection(1,tempPhi,tempTheta);
        smpTrj = [x, y, z];
        % get the stretch for four electrodes (Ex, Ey, Ez) in closed form for the sampled direction 
        [Cx, Cy, Cz, Ex, Ey, Ez] = getContactAndElectrodeStretch([0,0,0], smpTrj);    
        
        % stretch of four electrodes estimated from image
         iXDir = iX ;
         iYDir = iY ;
         iZDir = iZ;
        
        % compute norm of difference between electrode stretch for sampled trajectory and
        % stretch computed from image (Section 3.2.2 paper)
        traj(count, 1:3) = smpTrj;
        %traj(count, 4) = norm(imElectrodeStretch - [Ex, Ey, Ez]);
        traj(count, 4) = norm([iXDir, iYDir, iZDir] - [Ex, Ey, Ez]);
        count = count+1;
    end
end

% Sort the traj array based on 4th column from smallest norm to highest norm
[~,idx] = sort(traj(:,4)); % sort just the first column
sortedTraj = traj(idx,:);   % sort the whole matrix using the sort indices
