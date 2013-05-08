function varargout = plotboxrot(boxr,varargin)
%plots rotated box, in format as output from
% rotatebox (See Also rotatebox)
if isempty(boxr), warning('box isempty,not plotting...'), return; end
if size(boxr,2) ~= 4, warning('box wrong format, not plotting...'), return; end
if nargin > 1
    h = myplot(boxr(:,[ 1 2 3 4 1]),varargin{:});
else
    h = myplot(boxr(:,[ 1 2 3 4 1]),'-');
end

% mytext(boxr,{'1','2','3','4'})

if nargout == 1
    varargout{1} = h;
end