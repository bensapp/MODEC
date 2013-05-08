function box = box_from_dims(w,h,ctr)
% function box = box_from_dims(boxdims,ctr)
% supports multiple boxes at once, all with the same dims, 1 ctr per column
ctr = ctr';
left = (ctr(:,1)-w/2);
right = (ctr(:,1)+w/2);
top = (ctr(:,2) - h/2);
bottom = (ctr(:,2) + h/2);
box = [left top right bottom];
