function errs = score_predictions(pred,gt,testparts,normparts)
% scale by distance between joints specified in norm_parts
assert(length(normparts)==2)
scaling = squeeze(sqrt(sum((gt(:,lookupPart(normparts{1}),:) - gt(:,lookupPart(normparts{2}),:)).^2)));
true_joints = squeeze(gt(:,lookupPart(testparts),:));
pred_joints = squeeze(pred(:,lookupPart(testparts),:));
distances = squeeze(normcols(true_joints-pred_joints));
errs = bsxfun(@times,distances,100./scaling(:)');
