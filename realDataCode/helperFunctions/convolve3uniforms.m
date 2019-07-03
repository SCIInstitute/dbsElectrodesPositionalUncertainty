% convolution of 3 uniform random variables.

% U[x1,x2]
% U[y1,y2]
% U[z1,z2]

function convolve3uniforms(x1,x2,y1,y2,z1,z2)
    
xarr = uniRand(x1,x2,10^7);
yarr = uniRand(y1,y2,10^7);
zarr = uniRand(z1,z2,10^7);

subplot(1,2,1)
hist(xarr+yarr+zarr,10000);

t = x1+y1+z1:0.01:x2+y2+z2;

% density = zeros(1,length(t));
% 
% % Normalizing constant
% N = 1/((x2-x1)*(y2-y1));
% 
% [s1,s2,s3,s4] = findLimitsSorted(x1,x2,y1,y2);  
% 
% if (x2-x1) <= (y2-y1)     
% for i = 1:length(t)
%    if t(i)>= s1 && t(i)<=s2
%        density(i) = N*(t(i) - (x1+y1));       
%    elseif t(i)>=s2 && t(i)<=s3
%        density(i) = N*(x2-x1); 
%    elseif t(i)>=s3 && t(i)<=s4
%        density(i) = N*(x2+y2-t(i));        
%    end
% end
% else
%   for i = 1:length(t)
%    if t(i)>= s1 && t(i)<=s2
%        density(i) = N*(t(i) - (x1+y1));       
%    elseif t(i)>=s2 && t(i)<=s3
%        density(i) = N*(y2-y1); 
%    elseif t(i)>=s3 && t(i)<=s4
%        density(i) = N*(x2+y2-t(i));        
%    end
%   end
% end
% 
% 
% subplot(1,2,2)
% plot(t,density);
