function box = rotatebox(box0,theta)
% box = rotatebox(box0,theta)
% rotates box around center point by theta (in radians)
% outputs points of four corners in order [tl,tr,br,bl]

tl = box0(1:2)';
br = box0(3:4)';
tr = box0([3 2])';
bl = box0([1 4])';

pts = [tl tr br bl];
ptsr = rotatePts(pts,theta,mean(pts,2));

box = ptsr;

%{

ca
figure
myplot(pts,'b')
hold on
myplot(ptsr,'g')

%}