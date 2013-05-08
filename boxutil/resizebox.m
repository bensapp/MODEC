function [box] = scalebox(box,s)
c = boxcenter(box);

box = [box(1)-c(1) box(2)-c(2) box(3)-c(1) box(4)-c(2)];
box = box*s;
box = [box(1)+c(1) box(2)+c(2) box(3)+c(1) box(4)+c(2)];


% box = [box(1)-w/2*s box(2)-h/2*s box(3)+w/2*s box(4)+h/2*s];
