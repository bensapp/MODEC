function psi = diffFeature(param,y,yhat)
if iscell(y)
    y = y{:};
end
if close_enough(y,yhat)
    psi = [];
    return;
end

fposl = y.left.feats;
fposr = y.right.feats;

fnegl = yhat.left.feats;
fnegr = yhat.right.feats;

fposl(end+1) = 1;
fposr(end+1) = 1;
fnegl(end+1) = 1;
fnegr(end+1) = 1;

% is there a faster way to construct this?
psi = zeros(numel(fposr),param.k);
psi(:,y.left.mode)     = psi(:,y.left.mode)     + fposl;
psi(:,y.right.mode)    = psi(:,y.right.mode)    + fposr;
psi(:,yhat.left.mode)  = psi(:,yhat.left.mode)  - fnegl;
psi(:,yhat.right.mode) = psi(:,yhat.right.mode) - fnegr;

% add global left-right features
psi = [psi(:); (y.full.feats-yhat.full.feats)];

% add a "i am negative image" feature (negative class prior indicator)
psi(end+1) = 0;

psi = sparse(psi(:));

function ok = close_enough(y,yhat)
ptsguess = [yhat.left.pts_hog yhat.right.pts_hog];
pts = [y.left.pts_hog y.right.pts_hog];
ok = all(normcols(pts - ptsguess)<2);
