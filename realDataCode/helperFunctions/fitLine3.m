%pointArray: nX3 array of n 3-D points

function line = fitLine3(pointArray, num)

%[coeff,bint,residue] = regress(data,centroidArr);
[a,b] = size(pointArray);
if(num > a)
    disp('Invalid num');
end
 r0=mean(pointArray(1:num,:));
 xyz=bsxfun(@minus,pointArray(1:num,:),r0);
 [~,~,principalComponents]=svd(xyz,0);
 line = principalComponents(:,1);
 line = line';
 % make line pointing upward
 if(line(1,3) < 0)
     line(1,3) = -line(1,3);
 end