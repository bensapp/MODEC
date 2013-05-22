function yhat = genconstraint(p, modelvec, trainind, y)
img = imread(p.examples(trainind).filepath);
model = modelvec2models(modelvec,p);
genfeatures = true;
if iscell(y)
    y = y{:};
end
gtmodes = [y.left.mode y.right.mode];
yhat = run_models(img,model,p,genfeatures,gtmodes);

%% assert dot product matches inference score...this is very important
wleft = verify_inference_score(model.models{yhat.pred_modes(1)},yhat.left);
wright = verify_inference_score(model.models{yhat.pred_modes(2)},yhat.right);
wglobal = model.lr_compatibility(:);
dotprod = wleft'*[yhat.left.feats;1] + wright'*[yhat.right.feats;1] + wglobal'*yhat.full.feats;
assert_within_tol(dotprod,yhat.maxscore,10)