function idx = box2idx(box,dims)

pts = box2pts(box);
idx = sub2ind(dims,pts(2,:),pts(1,:));

