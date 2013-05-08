function [feats,fhog] = extract_features(pts,feats,fdims,root_pt,featsfull,root_fdims,mus)
bd = floor(fdims([2 1])/2);
pts = double(pts);
fhog = {};
for i=1:size(pts,2)
    box = vec(pts(:,[i i]))' + [0 0 2*bd];
    fhog{i} = subarray(feats,box);
end

% add root filter
bdfull = floor(root_fdims([2 1])/2);
box = vec(root_pt(:,[1 1]))' + [0 0 2*bdfull];
fhogfull = subarray(featsfull,box);
fhogfull = fhogfull(:,:,[19:27 32]);
fhog{end+1} = fhogfull;

feats = data2feats(fhog,pts,mus);

