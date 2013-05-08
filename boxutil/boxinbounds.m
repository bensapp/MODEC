function box = boxinbounds(box,sz)
% function box = boxinbounds(box,sz)
% makes box lie within dimensions specified by truncating 

box(box < 1) = 1;
box(box(:,1) > sz(2),1) = sz(2);
box(box(:,3) > sz(2),3) = sz(2);
box(box(:,2) > sz(1),2) = sz(1);
box(box(:,4) > sz(1),4) = sz(1);

    