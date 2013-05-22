function params = make_params(params, filterinfo, examples)
% compatible with SVMstruct (http://svmlight.joachims.org/) but we saw
% better (faster, more accurate) performance with liblinear.
params.examples = rmfield2(examples,{'gt_left','gt_right','gt_full'});
params.nparts = size(examples(1).gt_left.pts,2);
params.n = length(examples);
params.d = length(examples(1).gt_left.feats);
params.d_full = numel(examples(1).gt_full.feats);
params.k = length(params.mus);
% # features is k modes * (d feats/mode + 1 mode prior feature) + 1 neg class feature +
% d_full left-right mode compatibility features
params.dimension = double((params.d+1)*params.k+1+params.d_full)

%% hog stuff
params.hog.interval = 10;
params.hog.maxsize = filterinfo.fdims;
params.hog.sbin = filterinfo.cellsize;
params.hogf.interval= 10;
params.hogf.maxsize = filterinfo.fdims_full;
params.hogf.sbin = filterinfo.cellsize_full;
% for convenience
params.fdims = filterinfo.fdims;
params.cellsize = filterinfo.cellsize;
params.fdims_full = filterinfo.fdims_full;
params.cellsize_full = filterinfo.cellsize_full;
%% svmstruct compatibility
for i=1:length(examples)
    gt(i).left = examples(i).gt_left;
    gt(i).right = examples(i).gt_right;
    gt(i).full = examples(i).gt_full;
end
params.labels = gt;
params.patterns = arrayfun(@(x)(x),1:params.n,'uniformoutput',false);
params.constraintFn  = @genconstraint;
params.featureFn  = @diffFeature;

params = orderfields(params);