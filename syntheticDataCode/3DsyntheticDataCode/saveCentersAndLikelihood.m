% Store visualization files into a specified directory. The generated
% visualization files can be visualized in ParaView

% foldername: Directory in which you want to store the visualization files
% uncertainCenterPos: Point cloud representing uncertain contact center
% positions for all four DBS contacts
% uncertainCenterLikelihood: existential likelihood values for points in a point cloud
% represented by uncertainCenterPos
% mostProbableCenterPos: Spatial positions with highest exitential
% likelihood for contacts
% mostProbableCenterLikelihood: Existential likelihood for point
% represented by mostProbableCenterPos
% trueCenterPos: True spatial positions for DBS contacts (computed analytically 
% by mapping geometry (Sec. 3.1 in paper) to volume)
% trueCenterLikelihood: Existential likelihood of true DBS center positions
% (which is 1 always)
%  testImage, dwnSmpRate: the test image, inter-slice distance in mm for the test image,


function saveCentersAndLikelihood(foldername, uncertainCenterPos, uncertainCenterLikelihood, mostProbableCenterPos, mostProbableCenterLikelihood, trueCenterPos, trueCenterLikelihood, testImage, dwnSmpRate)

% If the folder doesn't exist, create a folder
if (exist(foldername,'dir')~=7)
    mkdir(foldername)
end

% Save data into visualization files, which can visualized in ParaView
% dlmwrite('results/uncertainCenterPos.txt', uncertainCenterPos(:,1:3), 'delimiter', '\t');
% dlmwrite('results/mostProbableCenterPos.txt', mostProbableCenterPos(:, 1:3), 'delimiter', '\t');
% save 'results/uncertainCenterLikelihood.mat' uncertainCenterLikelihood;
% save 'results/mostProbableCenterLiklihood.mat' mostProbableCenterLikelihood ;
% myNrrdWriter('results/testImage.nrrd', testImage, dwnSmpRate, [0 0 0], 'ascii');
vtkwrite(strcat(foldername,'meanDirection.vtk'),'polydata','lines',mostProbableCenterPos(:,1),mostProbableCenterPos(:,2),mostProbableCenterPos(:,3));
vtkwrite(strcat(foldername,'trueDirection.vtk'),'polydata','lines',trueCenterPos(:,1),trueCenterPos(:,2),trueCenterPos(:,3));
vtkwrite(strcat(foldername, 'Likelihood.vtk'), 'unstructured_grid',uncertainCenterPos(:,1),uncertainCenterPos(:,2),uncertainCenterPos(:,3), 'scalars','Likelihood',uncertainCenterLikelihood);
vtkwrite(strcat(foldername, 'mostProbableCenters.vtk'), 'unstructured_grid',mostProbableCenterPos(:,1),mostProbableCenterPos(:,2),mostProbableCenterPos(:,3), 'scalars','Likelihood',mostProbableCenterLikelihood); 
vtkwrite(strcat(foldername, 'trueCenters.vtk'), 'unstructured_grid',trueCenterPos(:,1),trueCenterPos(:,2),trueCenterPos(:,3), 'scalars','Likelihood',trueCenterLikelihood); 
myNrrdWriter(strcat(foldername,'testImage.nrrd'), testImage, dwnSmpRate, [0 0 0], 'ascii');