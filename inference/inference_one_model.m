function [yhat,maxscore] = inference_one_model(model,unary,unary_full,pyra,pyra_full,param,genfeatures)
nlvls = length(unary_full);
fdims = param.hog.maxsize;
cellsize  = param.hog.sbin;
if isfield(model,'wvec') && ~isempty(model(1).wvec)
    wvec = model(1).wvec;
else
    wvec = [];
end
[maxscore,maxpred,maxrootpred,maxlvl,maxfeats,fhog] = deal(-inf,[1;1],[1;1],1,[],[]);
for l=1:nlvls
    %% root filter score
    ufl = unary_full{l};
    [root_score,root_amax] = max(ufl(:));
    if all(ufl(:)==0)
        root_amax = randi(numel(ufl));
    end
    root_pred = ind2pts(size(ufl),root_amax);
    %% inference
    model = setfield2(model,'scores',unary(:,l));
    [score_l,pred_l] = inference_chain(model);
    score_l = score_l + root_score;
    if (score_l > maxscore || (score_l==maxscore && rand>0.5))
        maxscore = score_l;
        maxrootscore = root_score;
        maxpred = pred_l;
        maxrootpred = root_pred;
        maxlvl = l;
        if genfeatures
            [maxfeats,fhog] = extract_features(pred_l,pyra.feat{l},fdims,root_pred,pyra_full.feat{l},size(model(1).filter_root),[model.mu]);
        end
    end
end
%%
yhat.pts_hog = maxpred;
yhat.root_pt_hog = maxrootpred;
[yhat.pts,yhat.boxes] = pred2pixels(maxpred,pyra.scale(maxlvl),pyra.padx,pyra.pady,fdims);
yhat.root_pt = pred2pixels(maxrootpred,pyra_full.scale(maxlvl),pyra_full.padx,pyra_full.pady,param.hogf.maxsize);
yhat.maxlvl = maxlvl;
yhat.feats = maxfeats;
maxscore = maxscore+model(1).bias;
yhat.maxscore = maxscore;
yhat.maxrootscore = maxrootscore;
yhat.fhog = fhog;
