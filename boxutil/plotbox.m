function varargout = plotbox(b,varargin)
% function varargout = plotbox(b,varargin)
nbox = size(b,1);

hs = [];
hold on
for i=1:nbox
    c = boxcenter(b);
    h = plot([b(i,1) b(i,3) b(i,3) b(i,1) b(i,1)],[b(i,2) b(i,2) b(i,4) b(i,4) b(i,2)],varargin{:});
    hs = [hs; h];
%     drawnow
%     plot(c(1),c(2),'x',varargin{:})
end


if nargout == 1
    varargout{:} = hs;
end