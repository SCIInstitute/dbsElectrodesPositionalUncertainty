function [t1,t2, averageMismatch] = matchSize(testImage, dwnV, IP, signArray, bOuter)

% Do any changes at the end of data and not the start of the data
% So, at the 'post' part. See how many of planes are comparable and derive
% statistics on them
[tx, ty, tz] = size(testImage);
[vx, vy, vz] = size(dwnV);
[bx, by, bz] = size(bOuter);

avgBoxSize = [(bx+ (bx-1))/2, (by+ (by-1))/2, (bz+ (bz-1))/2];

diffx = abs(bx - vx);
diffy = abs(by - vy);
diffz = abs(bz - vz);

% Number of image planes to compare near the terminal contact
averageMismatch = (diffx + diffy + diffz)/3;

i1 = IP(1);
i2 = IP(2);
i3 = IP(3);

% simulate air (you might need to change it for the real dataset)
%padValue = max(max(max(bOuter)));
padValue = 0;

% Fill mismathced planes with values with numbers that will result in high
% gaussian error or low correlation e.g. -256. Don't fill them with zeros
% since image planes with 0s will result in high correlation
if signArray(1) >0 && signArray(2) >0
    % v: downsampled version
    % b: test image
    if (vx > bx)
        t1 = padarray(bOuter, [vx-bx, 0, 0],  padValue, 'post');
        t2 = dwnV(1:vx,:,:);
    else
        t1 = bOuter(1:bx,:,:);
        t2 = padarray(dwnV, [bx-vx, 0, 0], padValue, 'post');
    end
    
    if (vy > by)
        t1 = padarray(t1, [0, vy-by, 0],  padValue, 'post');
        t2 = t2(:,1:vy,:);
    else
        t1 = t1(:,1:by,:);
        t2 = padarray(t2, [0, by-vy, 0], padValue, 'post');
    end
    
     if (vz > bz)
        t1 = padarray(t1, [0, 0, vz-bz],  padValue, 'post');
        t2 = t2(:, :, 1:vz);
    else
        t1 = t1(:, :, 1:bz);
        t2 = padarray(t2, [0, 0, bz-vz], padValue, 'post');
     end

elseif signArray(1) <0 && signArray(2) >0
     
    if (vx > bx)
        t1 = padarray(bOuter, [vx-bx, 0, 0],  padValue, 'pre');
        t2 = dwnV(1:vx,:,:);
    else
        t1 = bOuter(1:bx,:,:);
        t2 = padarray(dwnV, [bx-vx, 0, 0], padValue, 'pre');
    end
    
    if (vy > by)
        t1 = padarray(t1, [0, vy-by, 0],  padValue, 'post');
        t2 = t2(:,1:vy,:);
    else
        t1 = t1(:,1:by,:);
        t2 = padarray(t2, [0, by-vy, 0], padValue, 'post');
    end
    
     if (vz > bz)
        t1 = padarray(t1, [0, 0, vz-bz],  padValue, 'post');
        t2 = t2(:, :, 1:vz);
    else
        t1 = t1(:, :, 1:bz);
        t2 = padarray(t2, [0, 0, bz-vz], padValue, 'post');
    end

elseif signArray(1) >0 && signArray(2) <0
   if (vx > bx)
        t1 = padarray(bOuter, [vx-bx, 0, 0],  padValue, 'post');
        t2 = dwnV(1:vx,:,:);
    else
        t1 = bOuter(1:bx,:,:);
        t2 = padarray(dwnV, [bx-vx, 0, 0], padValue, 'post');
   end
    
   if (vy > by)
        t1 = padarray(t1, [0, vy-by, 0],  padValue, 'pre');
        t2 = t2(:,1:vy,:);
    else
        t1 = t1(:,1:by,:);
        t2 = padarray(t2, [0, by-vy, 0], padValue, 'pre');
   end

   if (vz > bz)
        t1 = padarray(t1, [0, 0, vz-bz],  padValue, 'post');
        t2 = t2(:, :, 1:vz);
   else
        t1 = t1(:, :, 1:bz);
        t2 = padarray(t2, [0, 0, bz-vz], padValue, 'post');
   end

elseif signArray(1) <0 && signArray(2) <0
    
    if (vx > bx)
        t1 = padarray(bOuter, [vx-bx, 0, 0],  padValue, 'pre');
        t2 = dwnV(1:vx,:,:);
    else
        t1 = bOuter(1:bx,:,:);
        t2 = padarray(dwnV, [bx-vx, 0, 0], padValue, 'pre');
    end
    
    if (vy > by)
        t1 = padarray(t1, [0, vy-by, 0],  padValue, 'pre');
        t2 = t2(:,1:vy,:);
    else
        t1 = t1(:,1:by,:);
        t2 = padarray(t2, [0, by-vy, 0], padValue, 'pre');
   end

   if (vz > bz)
        t1 = padarray(t1, [0, 0, vz-bz],  padValue, 'post');
        t2 = t2(:, :, 1:vz);
   else
        t1 = t1(:, :, 1:bz);
        t2 = padarray(t2, [0, 0, bz-vz], padValue, 'post');
   end
   
end

