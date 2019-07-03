function signArray = getSignArray (mostProbableTraj)

dirX = mostProbableTraj(1);
dirY = mostProbableTraj(2);
%[tx, ty, tz]  = size(testImage);


if (dirX > 0 && dirY > 0)
    signArray = [1 1 1];
    %IP = [0 0 0];
elseif (dirX < 0 && dirY > 0)
    signArray = [-1 1 1];
    %IP = [tx-1 0 0];
elseif (dirX > 0 && dirY < 0)
    signArray = [1 -1 1];
    %IP = [0 ty-1 0];
elseif (dirX < 0 && dirY < 0)
    signArray = [-1 -1 1];
    %IP = [tx ty 0];
end
    
    