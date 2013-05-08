function box = mask2box(mask)
if ndims(mask) == 3
    mask = mask(:,:,1);
end

[y,x] = find(mask);
left = min(x);
right = max(x);
top = min(y);
bottom = max(y);
box = [left top right bottom];
