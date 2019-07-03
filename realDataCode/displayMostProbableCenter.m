function mostProbablePosMM = displayMostProbableCenter(ptCloud)

pos= find(abs(ptCloud(:,4) - max(ptCloud(:,4))) <eps);

% Multiple points with highest likelihood
if (length(pos) > 1)
    pos = pos(1);
end

% origin at the center of the volume
mostProbablePosMM = [ptCloud(pos,1), ptCloud(pos,2), ptCloud(pos,3)];

disp(strcat('The likely center location for the terminal contact (In SCIrun space):',  ' [', num2str(mostProbablePosMM(1)),' mm,', num2str(mostProbablePosMM(2)),' mm,', num2str(mostProbablePosMM(3)),' mm]'));