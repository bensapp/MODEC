function pts = flip_pts_lr(pts,w)
if nargin == 1
    w = 0;
end
pts(1,:) = w - pts(1,:);