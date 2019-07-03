function subvol = getSubsetVolume(V,limits)

[a,b,c] = size(V);
xlow = limits(1);
xhigh = limits(2);
ylow = limits(3);
yhigh = limits(4);
zlow = limits(5);
zhigh = limits(6);

subvol = subvolume(V, [max(ylow,1), min(yhigh,b),max(xlow,1), min(xhigh,a),max(zlow,1), min(zhigh,c)]);
if(xlow < 1)
   subvol = padarray(subvol, [1-xlow 0 0], 'pre');
end
if(xhigh > a)
    subvol = padarray(subvol, [xhigh-a 0 0], 'post');
end
if(ylow < 1)
   subvol = padarray(subvol, [0 1-ylow 0], 'pre');
end
if(yhigh > b)
    subvol = padarray(subvol, [0 yhigh-b 0], 'post');
end
if(zlow < 1)
    subvol = padarray(subvol, [0 0 1-zlow], 'pre');
end
if(zhigh > c)
    subvol = padarray(subvol, [0 0 zhigh-c], 'post');
end

%subvol = permute(subvol, [2 1 3]);
