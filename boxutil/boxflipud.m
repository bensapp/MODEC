function newbox = boxflipud(box,dims)
[h,w] = deal(dims(1),dims(2));
top = h-box(4);
bottom = h - box(2);
newbox = [box(1) top box(3) bottom];