function model = svm2model(w,fdims,fdims_full,mus)
clear model
model(1).wvec = w;

bias = w(end);
w = w(1:end-1);

nparts = 7;
nhog = prod(fdims);
ngeom = 2;
hog_full_start = nhog*nparts+1;
geom_start = hog_full_start+prod(fdims_full);

for i=1:nparts
    wi = w((i-1)*nhog+1:i*nhog);
    model(i).filter = reshape(wi,fdims);
end

wroot = w(hog_full_start:hog_full_start+prod(fdims_full)-1);
filter_root = reshape(wroot,fdims_full);

min_coeff = 0.001;
for i=1:nparts-1
    geom = w((i-1)*ngeom+geom_start:i*ngeom+geom_start-1);
    model(i+1).coeff_dx2 = max(min_coeff,geom(1));
    model(i+1).coeff_dy2 = max(min_coeff,geom(2));
    model(i+1).geom_unconstrained = geom;
    model(i+1).mu = mus(:,i);
end

model(1).bias = bias;
model(1).filter_root = filter_root;
