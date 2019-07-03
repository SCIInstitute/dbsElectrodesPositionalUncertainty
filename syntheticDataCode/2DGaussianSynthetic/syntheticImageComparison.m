% Quantification of sub-voxel level uncertainties for 2D Gaussians (Fig.7 in paper) using
% SSIM (structural similarity index) 

% mean and covariance of Gaussians
mu = [0 0];
Sigma = [3 1; 1 3];
% Discretize Gaussian
x1 = -10:.1:10; x2 = -10:.1:10;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
F = F*20;
% Visualize Gaussian: Consider this as a groundtruth (Fig. 7a in paper)
figure;
imshow(F);
title('Ground truth (high-resolution)');

% Generate a test image  (Fig. 7b in paper) by downsampling at offset
% offsetX, offsetY = [0, 0] units
% downSampling rate X = 0.5 units
% downsamling rate Y = 1 unit
% test image is generated to simulate a postoperative DBS CT image of
% patient head
Dx = 0.5;
Dy = 1;
numX = Dx/0.1;
numY = Dy/0.1;
testImage = F(1:numX:end, 1:numY:end);
figure;
imshow(testImage);
title('test image (low-resolution)');

% Pad ground truth F on both side by numplanes (Fig. 7c in paper)
numPlanes = 25;
padPixelsX = numPlanes*Dx/0.1;
padPixelsY = numPlanes*Dy/0.1;
Fnew = padarray(F, [padPixelsX, padPixelsY], 'both');
figure;
imshow(Fnew);
title('ground truth padded with zeros');

% downsample with offset sampling numplanes -3, numplanes + 3 units
xOffsets = (numPlanes-3)*Dx:0.1:(numPlanes+3)*Dx;
yOffsets = (numPlanes-3)*Dy:0.1:(numPlanes+3)*Dy;

uncertainCenters = zeros(length(xOffsets)*length(yOffsets),3);
%observation = testImage;
observation = mat2gray(imgradient(testImage));
[o1, o2] = size(observation);

% Draw low-resolution samples from the ground truth image and compare
% their similarity index (SSIM) with the test image. Comparisons can be
% parallelized since samples are independent of each other and similarity 
% value is stored in uncertainCenters array
% You may play with SSIM exponent parameter values
parfor  linId=1:numel(xOffsets)*numel(yOffsets)
            [i, j] = ind2sub([numel(xOffsets), numel(yOffsets)], linId);
            oX = xOffsets(i);
            oY = yOffsets(j);
            % linId = sub2ind([numel(xOffsets), numel(yOffsets)], i, j );
            % obtain samples along X and Y
            numPixX = oX/0.1;
            numPixY = oY/0.1;
            dwnX = Dx/0.1;
            dwnY = Dy/0.1;
            mSample= Fnew(numPixX:dwnX:end, numPixY:dwnY:end);
            center = [numPlanes*Dx + 10 - oX, numPlanes*Dy + 10 - oY];
            [m1, m2] = size(mSample);
            if(o1 > m1) || (o2 > m2)
                likelihood = 0;
            else
                sample = mat2gray(imgradient(mSample(1:o1, 1:o2)*10));
                likelihood = ssim(sample, observation, 'Exponents', [0, 25, 25]);
            end
             uncertainCenters(linId,:) = [center, likelihood];
end

% Visualize Gaussian center spatial position likelihoods (Similar to Fig. 7d-f in paper)
% The highest likelihood can be seen at the offset=numplanes
probabilities = reshape(uncertainCenters(:,3), [length(xOffsets), length(yOffsets)]);
figure
imshow(probabilities)
title('Gaussian-mean positional likelihood visualization');