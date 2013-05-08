function varargout = plotboxes(b,varargin)
% This is vectorized using PATCH to be much faster than plotbox.
% Use this for many many boxes
if isempty(b), return; end
if nargin == 1
    varargin = {'EdgeColor','b'};
end
patch(b(:,[1 3 3 1])',b(:,[2 2 4 4])','w','FaceAlpha',0,varargin{:})