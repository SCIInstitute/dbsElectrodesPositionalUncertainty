% longitudinalDirArr: Array of direction vectors of longitudinal axes of
% DBS electrodes
% includeShaft: Whether to include or not the shaft near the tail of the
% fourth electrode
function VArr = loadGroundTruth(longitudinalDirArr, includeShaft)

% intervoxel distance = 0.033mm for vertical lead
% shaft length beyond contacts is 3 mm (3.0690 to be precise)
% So total length is 10.5 + 3 = 13.5 mm
% The cropped vertical groundtruth is stored in verticalGroundTruthWithShaftAndBoundingBox.mat

%V = importdata('groundTruth.mat');
%V = flip(V,3);

% Import high-resolution image of electrodes oriented along positive Z or
% vertical direction
V = importdata('verticalGroundTruthWithShaftAndBoundingBox.mat');
if(~ includeShaft)
    %V = V(:,:, 1:377);
    V = V(:,:, 1:318);
end
isoval = 28;

% Number of direction vectors for longitudinal axis of DBS electrodes
a = length(longitudinalDirArr(:,1));

% Store groundTruth images in cell array
VArr = cell(a,1);
for i = 1:a
        longitudinalDirArr(i,1:3) = longitudinalDirArr(i,1:3)/norm(longitudinalDirArr(i,1:3));
        dir = longitudinalDirArr(i,1:3);      
        % Following formulae applicable after normalization
        % rotation about X axis
        pitch = asind(-dir(1,2));
        % rotation about Y axis
        yaw = atan2d(dir(1,1), dir(1,3)); % Beware cos(pitch)==0, catch this exception!
        
        % Rotate the electrode along a direction vector for longitudinal axis.
        temp = imrotate3(V,pitch, [1,0,0]);
        VArr{i} = imrotate3(temp,yaw, [0,1,0]);
        
%         [a, b, c] = size(VArr{i});
%         [X,Y,Z] = meshgrid(1:1:b,1:1:a,1:1:c);
%         isosurfaceVis(X,Y,Z,VArr{i},isoval);
end

% % Get a vector corresponding to volume roation
dir1 = rotateVectorAboutX([0,0,1],pitch);
contactDir = rotateVectorAboutY(dir1,yaw);

% Visually, in matlab figures,  a represents data oriented along axis going in the paper (X-axis)
% Y-axis represents data from left to right and Z-axis is along verical
% direction.

% However, while storing X data in matrix is stored along rows of matrix (visually corresponding to direction into paper), 
% Y is along columns (visually corresponding from left to right, consistent :-))
% Z data is stored along depth of the matrix (which visually looks vertical)

% To summarize: for matrix storage: rows =X, cols =Y and depth=Z;

