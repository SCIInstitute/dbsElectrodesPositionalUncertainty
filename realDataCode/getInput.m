% Read real data
function [croppedData, meta, contactCenter, contactDir] = getInput()

% Patient 1 data electrode 1
T1 = load('realData/NYU002_right_ml.mat');
trf1 = T1.scirunmatrix;
[contactCenter, contactDir] = leadStartDirection(trf1);

% read Nrrd
[croppedData, meta] = nrrdread('realData/Crop_NYU002_PostCT_T1space.nrrd');