function model = modelvec2models(w,p)
[fdims,fdims_full,k,d,mus] = deal(p.hog.maxsize,p.hogf.maxsize,p.k,p.d,p.mus);

% negative threshold
model.negthresh = w(end);
w = w(1:end-1);

model.lr_compatibility = w(end-p.d_full+1:end);
w = w(1:end-p.d_full);
W = reshape(w,[d+1 k]);
for i=1:k
   model.models{i} = svm2model(W(:,i),fdims,fdims_full,mus{i});
end
model.params = rmfield2(p,{'patterns','labels','constraintFn','featureFn','examples','negfiles'});
