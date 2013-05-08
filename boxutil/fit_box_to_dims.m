function box = fit_box_to_dims(box,dims)
w = dims(2);
h = dims(1);

box(box < 1) = 1;

box(box(:,1) > w,1) = w;
box(box(:,3) > w,3) = w;
box(box(:,2) > h,2) = h;
box(box(:,4) > h,4) = h;

%{
if box(1) > w, box(1) = w; end
if box(3) > w, box(3) = w; end
if box(2) > h, box(2) = h; end
if box(4) > h, box(4) = h; end

%}