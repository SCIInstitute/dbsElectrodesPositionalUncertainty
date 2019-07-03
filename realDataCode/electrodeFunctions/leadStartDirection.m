function [start,dir] = leadStartDirection(trf)

initStart = [0 0 1.5 1]';
initDir = [0 0 1 0]';
start = trf*initStart;
dir = trf*initDir;
% Make dir a row vector
dir = dir';
dir = dir(1:3);





