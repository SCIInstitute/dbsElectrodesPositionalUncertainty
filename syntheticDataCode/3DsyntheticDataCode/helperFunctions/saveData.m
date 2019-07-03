% Save the test data to a specified directory in files gaussian.nrrd and
% gaussian.mat
% metadata.txt: The first row: underlying DBS lead direction, the second
% row: Downsampling rate (in mm), the third row: starting offset for downsampling (in mm)
% kernelSize.txt: kernel size in mm

function saveData(folderName,testData1,testData2,testData3,directionDwnRateOffset, kernelSize)  

if (exist(folderName,'dir')~=7)
    mkdir(folderName)
end

dwnSmpRate = directionDwnRateOffset(2,:);
dlmwrite(strcat(folderName, '/metadata.txt'), directionDwnRateOffset , 'delimiter', '\t');
dlmwrite(strcat(folderName, '/KernelSize.txt'), kernelSize , 'delimiter', '\t');

% % Average
% myNrrdWriter(strcat(folderName, '/average.nrrd'), testData1, dwnSmpRate, [0 0 0], 'ascii');
% save(strcat(folderName, '/average.mat'), 'testData1');
% 
% % Ellipsoid
% myNrrdWriter(strcat(folderName, '/ellipsoid.nrrd'), testData2, dwnSmpRate, [0 0 0], 'ascii');
% save(strcat(folderName, '/ellipsoid.mat'), 'testData2');

% Gaussian
myNrrdWriter(strcat(folderName, '/gaussian.nrrd'), testData3, dwnSmpRate, [0 0 0], 'ascii');
save(strcat(folderName, '/gaussian.mat'), 'testData3');
