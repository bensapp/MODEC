function imgdata = examples2modes(info, examples)
% this function only works if all the examples have been cropped and scaled
% to the same dimensions
imgdims = examples(1).imgdims;
assert(all(vec(bsxfun(@eq,imgdims,cat(1,examples.imgdims)))));

%% get mode memberships
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

nC = length(info.mean_coords);
mean_coords = cat(3,info.mean_coords{:});
mean_coords = reshape(mean_coords,6,size(mean_coords,3));

% all pairs distance between examples and cluster centers
modeinds = argmin(pdist2(coords0', mean_coords'),[],2);
0;
%% read in and warp images to cluster centers before taking average
unwarped = cell(2*n,1);
warped = cell(2*n,1);
target_dims = [150 134];
tl = CTimeleft(2*n);
for i=1:2*n
    tl.timeleft;
    to_pts = info.mean_coords{modeinds(i)}(:,lookupPart('lsho','lelb','lwri'));
    exi = exinds(i);
    img = imread(examples(exi).filepath);
    from_pts = examples(exi).coords(:,linds);
    if isflipped(i)
        img = fliplr(img);
        from_pts = flip_pts_lr(examples(exi).coords(:,rinds), imgdims(2));
    end
    unwarped{i} = imresize(halfimg(img), target_dims,'bilinear');
    warped{i} = imresize(halfimg(warpimg(from_pts, to_pts, img)),target_dims,'bilinear');
end
imgdata = bundle(exinds, isflipped, modeinds, warped, unwarped);

function img2 = halfimg(img)
img2 = img(:,round(end/3):end,:);