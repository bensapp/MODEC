function d = normcols(pts,normp)
% Computes the norm of every column of a matrix.
if nargin == 1
    p = 2;    
else
    p = normp;
end
d = (sum(abs(pts).^p,1)).^(1/p);
