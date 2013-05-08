function pts = ind2pts(sz,inds);
if length(sz)==2
    [y,x]=ind2sub2(sz,inds);
    pts=[x(:)';y(:)'];
elseif length(sz)==3
    [y,x,z]=ind2sub(sz,inds);
    pts=[x(:)';y(:)';z(:)'];
else
    error(['ind2pts only works in 2 or 3 dimensions, not ',num2str(length(pq))]);
end
    

