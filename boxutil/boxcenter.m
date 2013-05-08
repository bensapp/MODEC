function c = boxcenter(b)
if isempty(b), c = []; return; end
c = [(b(:,1)+b(:,3))/2 (b(:,2)+b(:,4))/2]';