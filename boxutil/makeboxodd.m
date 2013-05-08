function bbox = makeBoxOdd(bbox)
w = bbox(3)-bbox(1);
if mod(w,2) == 0, w = w+1; end
h = bbox(4)-bbox(2);
if mod(h,2) == 0, h = h+1; end
bbox = [bbox(1) bbox(2) bbox(1)+w bbox(2)+h];