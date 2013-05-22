function info = define_modes(examples,nC)
% this function only works if all the examples have been cropped and scaled
% to the same dimensions
imgdims = examples(1).imgdims;
assert(all(vec(bsxfun(@eq,imgdims,cat(1,examples.imgdims)))));
linds = lookupPart('lsho','lelb','lwri');
rinds = lookupPart('rsho','relb','rwri');
coords = cat(3,examples.coords);
coordsL = coords(:,linds,:);
coordsR = coords(:,rinds,:);
coordsR(1,:) = imgdims(2)-coordsR(1,:);
coordsL = reshape(coordsL,6,size(coordsL,3));
coordsR = reshape(coordsR,6,size(coordsR,3));

n = length(examples);
coords0 = [coordsL coordsR ];
exinds = [1:n 1:n];
isflipped = [false(1,n) true(1,n)];

% kmeans from the MATLAB stats toolbox.  Although we ran 100 replicates for
% the paper, 20 seems like more than enough
[inds,ctrs,energy] = kmeans(coords0',nC,'Display','final','Replicates', 20, 'MaxIter', 1000);
energy = sum(energy)

%{
clusterinfo = 
            mean_coords: {1x32 cell}
                 thumbs: {1x32 cell}
    example_per_cluster: [32x1 double]
%}
info.thumbs = cell(1,nC);
info.mean_coords = cell(1,nC);
info.examples_per_cluster = zeros(nC,1);

for i=1:nC
    indsi = find(inds==i);
    coords = {};
    for j=1:length(indsi)
        exij = exinds(indsi(j));
        coords{j} = examples(exij).coords(:,linds);  
        if isflipped(indsi(j))
            coords{j} = flip_pts_lr(examples(exij).coords(:,rinds), examples(exij).imgdims(2));
        end
    end
    if 0
        %% view clusters
        clf, hold on
        for i=1:length(coords)
            myplot(coords{i}(:,1:3),'k.-')
            myplot(coords{i}(:,1),'bo')
        end
        axis equal ij
        axis([1 imgdims(2) 1 imgdims(1)])
    end
    %%
    info.mean_coords{i} = mean(cat(3,coords{:}),3);
    info.examples_per_cluster(i) = length(indsi);
end

%% for convenience, sort cluster defns by frequency, so that cluster #1 is 
% most common. I didn't do this for paper version, but it's a nice-to-have.
[~,order] = sort(info.examples_per_cluster,'descend');
info.mean_coords = info.mean_coords(order);
info.examples_per_cluster = info.examples_per_cluster(order);
0;