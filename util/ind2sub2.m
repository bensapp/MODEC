function [y,x] = ind2sub2(siz,ind)
%IND2SUB Multiple subscripts from linear index.
%   Faster version than ind2sub; only works with 2d matrices
assert(length(siz) < 3)
x = floor((ind-1)/siz(1))+1;
y = ind-(x-1)*siz(1);