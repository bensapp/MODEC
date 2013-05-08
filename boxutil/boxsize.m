function varargout = boxsize(b)
% function sz = boxsize(b)
% sz = [b(:,4)-b(:,2)+1 b(:,3)-b(:,1)+1];

sz = [b(:,4)-b(:,2) b(:,3)-b(:,1)];

if nargout==2
    varargout{1}=sz(1);
    varargout{2}=sz(2);
else
    varargout{1}=sz;
end
    
