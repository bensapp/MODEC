function [postrain,mus,globalfeats] = compute_groundtruth(postrain,filterinfo,mode_ctrs)
nex = length(postrain);
fprintf('Computing groundtruth.\n');
tl = CTimeleft(nex);
for i=1:nex
    tl.timeleft;
    postrain(i).gt_left = compute_groundtruth_side(postrain(i),filterinfo.fdims,filterinfo.cellsize,{'nose','lsho','lelb','lwri'});
    postrain(i).gt_right = compute_groundtruth_side(postrain(i),filterinfo.fdims,filterinfo.cellsize,{'nose','rsho','relb','rwri'});
end

%% map to modes
linds = lookupPart('lsho','lelb','lwri');
Tc = cellfun(@(x)(x(:,linds)),mode_ctrs,'uniformoutput',false);
Tc = cat(3,Tc{:});
Tc = bsxfun(@minus,Tc,mean(Tc,2));
Tc = bsxfun(@times,Tc,1./sqrt(sum(sum(Tc.^2,1),2)));


%%
tl = CTimeleft(nex);
for i=1:nex
    tl.timeleft;
    ptsl = procrustes2(postrain(i).gt_left.pts_hog(:,[3 5 7]));
    ptsr = procrustes2(postrain(i).gt_right.pts_hog(:,[3 5 7]));
    ptsrf = bsxfun(@times,ptsr,[-1;1]);
    
    postrain(i).gt_left.mode = argmin(mean(normcols(bsxfun(@minus,Tc,ptsl)),2));
    postrain(i).gt_right.mode = argmin(mean(normcols(bsxfun(@minus,Tc,ptsrf)),2));
    
    if 0
        %%
        figure(1)
        imsc(postrain(i).filepath)
        figure(2)
        imsc(thumbs{postrain(i).gt_left.mode})
        sfigure(3)
        imsc(fliplr(thumbs{postrain(i).gt_right.mode}))
        0;
        drawnow
    end
end


%% estimate mus
gtl = [postrain.gt_left];
gtr = [postrain.gt_right];
gtlmode = [gtl.mode];
gtrmode = [gtr.mode];
mus = {};
k = length(mode_ctrs);
for i=1:k
%     cla, hold on
    ptsl = cat(3,gtl(gtlmode==i).pts_hog);
    ptsr = cat(3,gtr(gtrmode==i).pts_hog);
    if ~isempty(ptsr)
        ptsr(1,:) = -ptsr(1,:);    
    end
    
    pts = cat(3,ptsl,ptsr);
%     for q=1:min(size(pts,3))
%         myplot(pts(:,:,q),'bo-')
%     end
%     axis image ij
    mus{i} = -median(diff(pts,[],2),3);
end

%% left-right mode compatability, of the form
% compatability(mode1, mode2, j) = 1{mode1 is ranked j^th closest mode to
% mode2 || mode2 is ranked j^th closest to mode1}
compatmat = zeros(k);
for i=1:length(postrain)
   [r,c] = deal(postrain(i).gt_left.mode ,postrain(i).gt_right.mode);
   compatmat(r,c) = compatmat(r,c)+1;
   compatmat(c,r) = compatmat(c,r)+1;
end

rs = [1 3 5 16];
R = zeros(k,k,length(rs));
for i = 1:k
    [~,order] = sort(compatmat(i,:),'descend');
    for j=1:length(rs)
        R(i,order(1:rs(j)),j) = true;
    end
end

for j=1:length(rs)
    R(:,:,j) = triu(R(:,:,j));
    R(:,:,j) = R(:,:,j)' + R(:,:,j);
end
R = R>0;
globalfeats = R;

%% compute positive example feature vectors
fprintf('Extracting groundtruth feature vectors.\n');
tl = CTimeleft(nex);
for i=1:nex
    tl.timeleft;
    [fl,fr,flr] = gt2feats(postrain(i),filterinfo.fdims,filterinfo.fdims_full,filterinfo.cellsize,filterinfo.cellsize_full,mus,globalfeats);
    postrain(i).gt_left.feats = fl;
    postrain(i).gt_right.feats = fr;
    postrain(i).gt_full.feats = flr;
end
nparts = 7;
d = length(postrain(1).gt_left.feats);
n = length(postrain);

function gt = compute_groundtruth_side(example,fdims,cellsize,partnames)
pts = example.coords(:,lookupPart(partnames));
pts2 = [mean(pts(:,1:2),2) mean(pts(:,2:3),2) mean(pts(:,3:4),2)];
ptsall = [interleave(pts(1,:),pts2(1,:))';interleave(pts(2,:),pts2(2,:))'];
img = imread(example.filepath);
n = size(ptsall,2);
boxes = example2boxes(ptsall,norm(pts(:,2)-pts(:,3)));
pad = boxsize(boxes(1,:))./fdims(1:2);
bdims = boxsize(boxes(1,:)+[-pad pad]);

targetdims = (fdims(1:2)+2)*cellsize;
imgs = imresize(img,targetdims(1)./bdims(1),'bilinear');
h = features(double(imgs),cellsize);
s1 = size(imgs(:,:,1)) ./ size(img(:,:,1));
s2 = size(h)./size(imgs);
scale = mean(s1.*s2(1:2));

pts_hog = ptsall*scale;

if 0
    %% display / debug
    imsc(img)
    hold on
    plotboxes(boxes)
    myplot(boxcenter(boxes),'w.-')
    0;
end

gt.pts = ptsall;
gt.pts_hog = pts_hog;
gt.pyra_scale = mean(s1);
gt.scale = scale;
gt.boxes = boxes;
gt.imgsdims = size(imgs);
gt.imgdims = size(img);
