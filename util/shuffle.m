function x = shuffle(x,k)
if nargin < 2
    k= length(x);
end
t = randperm(length(x));
t = t(1:k);
if size(x,1) > size(x,2)
    x = x(t,:);
else
    x = x(:,t);
end

