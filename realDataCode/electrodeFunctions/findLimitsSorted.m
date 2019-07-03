% Find limits of sum random variable assuming x2>x1 and y2>y1

function [s1,s2,s3,s4] = findLimitsSorted(x1,x2,y1,y2)

s1 = x1+y1;
s4 = x2+y2;

if (x2-x1) >= (y2-y1)
    
 s2 = x1+y2;
 s3 = x2+y1;
 
else
  
 s2 = x2+y1;
 s3 = x1+y2;
 
end
 