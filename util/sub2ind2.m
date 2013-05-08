function ind = sub2ind2(pq,x,y);
% Timothee Cour, 06-Jun-2008 05:41:57 -- DO NOT DISTRIBUTE

if nargin<3
    if isempty(x)
        ind=x;
        return;
    end

    y=x(:,2);
    x=x(:,1);
end
ind = x+pq(1)*(y-1);