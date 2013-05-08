function a=boxarea(b)
% function v=boxarea(b)
% a = prod([b(:,3)-b(:,1) b(:,4)-b(:,2)]);
if isempty(b), a = []; return; end
a = prod(double([b(:,3)-b(:,1) b(:,4)-b(:,2)]),2);
