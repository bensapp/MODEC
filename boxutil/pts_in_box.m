function b = pts_in_box(box,pts)
x = pts(1,:);
y = pts(2,:);
[left,top,right,bottom] = dealbox(box);
b = (x >= left & x <= right & y >= top & y <= bottom);
