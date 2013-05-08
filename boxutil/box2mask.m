function mask = box2mask(box,dims)
% function mask = box2mask(box,dims)
%assumes format of box is: [left top right bottom]
% truncates box if out of bounds

box = boxinbounds(box,dims);
x = box([1 3 3 1]);
y = box([2 2 4 4]);
mask = poly2mask(x,y,dims(1),dims(2));