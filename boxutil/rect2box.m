function box=rect2box(rect)
if isempty(rect), box = []; return; end

r = rect(:,1)+rect(:,3);
b = rect(:,2)+rect(:,4);
box = [rect(:,1:2) r b];