function o = boxoverlap(b1,b2)
% function o = boxoverlap(b1,b2)
% computes intersection over union (IoU)
% can compute all pairs overlaps in b1 and b2 efficiently
if nargin == 1
    b2 = b1;
end
assert(size(b1,2) == 4);
assert(size(b2,2) == 4);
assert(ndims(b1)==2);
assert(ndims(b2)==2);

o = mex_all_pairs_box_IoU(double(b1)',double(b2)');

% b1m = [b1(1:2) b1(3)-b1(1) b1(4)-b1(2)];
% b2m = [b2(1:2) b2(3)-b2(1) b2(4)-b2(2)];
% a1 = prod(b1m(3:4));
% a2 = prod(b2m(3:4));
% ao = rectint(b1m,b2m);
% o = ao/(a1+a2-ao);
