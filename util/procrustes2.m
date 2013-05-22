function pts = procrustes2(pts)
% subtract mean, divide by average norm
pts = bsxfun(@minus,pts,mean(pts,2));
s = sqrt(sum(pts(:).^2));
pts = pts/s;