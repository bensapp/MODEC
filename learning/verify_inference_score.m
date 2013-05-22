function wvec = verify_inference_score(model,yhat)
wvec = model(1).wvec;
hinds = 1:length(model)*prod(size(model(1).filter));
rootinds = hinds(end)+1:hinds(end)+prod(size(model(1).filter_root));
ginds = rootinds(end)+1:length(wvec)-1;
wvec(ginds) = max(0.001,wvec(ginds));
maxfeats = yhat.feats;
fhog = yhat.fhog;
rootscore = yhat.maxrootscore;
maxscore = yhat.maxscore;
%%
h = 0;
for i=1:7
    h = h+ sum(vec(model(i).filter.*fhog{i}));
end
%%
h2 = wvec(hinds)'*maxfeats(hinds);
hfull = sum(vec(fhog{end}.*model(1).filter_root));
hfull2 = wvec(rootinds)'*maxfeats(rootinds);
g = wvec(ginds)'*maxfeats(ginds);

dot_prod = wvec'*[maxfeats;1];

tolerance = 10;
assert_within_tol(h,h2,tolerance)
assert_within_tol(hfull,hfull2,tolerance)
assert_within_tol(hfull,rootscore,tolerance)
assert_within_tol(h+hfull+g+wvec(end),maxscore,tolerance);
assert_within_tol(dot_prod,maxscore,tolerance);
0;
