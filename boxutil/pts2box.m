function bbox=pts2box(pts)
bbox = [min(pts(1,:)) min(pts(2,:)) max(pts(1,:)) max(pts(2,:))];
