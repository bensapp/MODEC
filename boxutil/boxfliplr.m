function newbox = boxfliplr(box,dims)
if isempty(box), newbox = []; return, end

[h,w] = deal(dims(1),dims(2));
right = w-box(:,1);
left = w - box(:,3);
newbox = [left box(:,2) right box(:,4)];