function pts = box2pts(box)
% function pts = box2pts(box)
% box = round(box);
% [x,y]=meshgrid(box(1):box(3),box(2):box(4));
% pts = [x(:)';y(:)'];

box = round(box);
[x,y]=meshgrid(box(1):box(3),box(2):box(4));
pts = [x(:)';y(:)'];
