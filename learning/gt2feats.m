function [featsl,featsr,featslr,ispos] = gt2feats(example,fdims,fdims_full,cellsize,cellsize_full,mus,globalfeats);

img = imread(example.filepath);

lmode = example.gt_left.mode;
rmode = example.gt_right.mode;

[featsl,ispos] = gt2feats_side(example.gt_left,img,fdims,fdims_full,cellsize,cellsize_full,mus{lmode},false);
featsr = gt2feats_side(example.gt_right,img,fdims,fdims_full,cellsize,cellsize_full,mus{rmode},true);

featslr = globalfeats(lmode,rmode,:);
featslr = featslr(:);


function [feats,is_pos] = gt2feats_side(gt,img,fdims,fdims_full,cellsize,cellsize_full,mus,doflip)

boxes = gt.boxes;
n = size(boxes,1);
targetdims = (fdims(1:2)+2)*cellsize;
hogf = {};
patches = {};
scale = [];
for i=1:n
    pad = boxsize(boxes(i,:))./fdims(1:2);
    patchi = subarray(img,boxes(i,:)+[-pad pad]);
    patchir = imresize(patchi,targetdims,'bilinear');
    if doflip
        patchir = fliplr(patchir);
    end
    patches{i} = patchir;
    hogf{i} = features(patchir,cellsize);
    
end
pts_hog = gt.pts_hog;

%%
boxfull = scalebox(boxes(4,:),2*fdims_full(1)/fdims(1));
targetdimsfull = (fdims_full(1:2)+2)*cellsize_full;
pad = boxsize(boxfull)./fdims_full(1:2);
patchi = subarray(img,boxfull+[-pad pad]);
patchir = imresize(patchi,targetdimsfull,'bilinear');
if doflip
    patchir = fliplr(patchir);
end
hogfull = features(patchir,cellsize_full);
hogf{end+1} = hogfull(:,:,[19:27 32]);
% imsc(patchir)

if doflip
    pts_hog(1,:) = -pts_hog(1,:);
end

if nargout == 1
    feats = data2feats(hogf,pts_hog,mus);
end
if nargout == 2
    [feats,is_pos] = data2feats(hogf,pts_hog,mus);
end
