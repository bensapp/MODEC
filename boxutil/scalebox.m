function [box] = scalebox(box,s)
%function [box] = scalebox(box,s)
% -shrinks or enlarges box by a factor of s around its center
%support for multiple boxes as once, one per row, and s a column vector or
%scalar
c = boxcenter(box)';

box = [box(:,1)-c(:,1) box(:,2)-c(:,2) box(:,3)-c(:,1) box(:,4)-c(:,2)];
box = bsxfun(@times,box,s);
box = [box(:,1)+c(:,1) box(:,2)+c(:,2) box(:,3)+c(:,1) box(:,4)+c(:,2)];



