function varargout = myplot(x,varargin)

if nargin == 1
    varargin = {'.','MarkerSize',6};
end

if size(x,1) == 3
    h = plot3(x(1,:),x(2,:),x(3,:),varargin{:});
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    grid on
    cameratoolbar
elseif size(x,1) == 2 
    h = plot(x(1,:),x(2,:),varargin{:});
else
    warning('couldnt plot pts, wrong format')
end

if nargout == 1
    varargout{1} = h;
end