function [acc,auc] = accuracyCurve(vals,range,varargin)
% range = 15:1:40;
% ps = partidx;
vals = vals(:);
acc = [];
for k = 1:numel(range)
    acc(k) = 100*mean(vals<=range(k));
end
auc = area_under_curve(scale01(range),acc);

% if nargout==0
    plot(range,acc,varargin{:})
% end