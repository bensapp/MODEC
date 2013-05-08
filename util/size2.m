function [varargout] = size2(x,idx)
% Like the builtin size(), but can request specific dimension sizes (idx) back.
s = size(x);
if nargin < 2
    idx = 1:max(length(s),nargout);
end
extra = max(idx)-length(s);
if extra > 0
    s = [s ones(1,extra)];
end

s = s(idx);

if nargout <= 1
    varargout = {s};
else
    nout = max(nargout,1);
    for i=1:nout,
        varargout{i} = s(i);
    end
end