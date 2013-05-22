function [example] = relabel_groundtruth(model,example,param,display)
img = imread(example.filepath);
lmodel = model.models{example.gt_left.mode};
rmodel = model.models{example.gt_right.mode};
[best_guess,Fl,maxlvl,pyra,pyra_full] = relabel_groundtruth_side(lmodel,img,example,param,false,display);
[best_guess,Fr,maxlvl] = relabel_groundtruth_side(rmodel,fliplr(img),example,param,true,display,pyra,pyra_full);
example.gt_left.feats = Fl;
example.gt_right.feats = Fr;
0;

function [best_guess,F,maxlvl,pyra,pyra_full] = relabel_groundtruth_side(model,img,example,param,doflip,display,pyra,pyra_full)
if doflip
    gt = example.gt_right;
    gtboxes0 = scalebox(gt.boxes,0.5);
    w = size(img,2);
    gtboxes = gtboxes0;
    gtboxes(:,3) = w-gtboxes0(:,1);
    gtboxes(:,1) = w-gtboxes0(:,3);
else
    gt = example.gt_left;
    gtboxes = scalebox(gt.boxes,0.5);
end

%% feat pyramid be picky about scale
param.hog.interval = 20;
param.hogf.interval = 20;
if ~doflip
%     tic
    pyra = featpyramid(img,param.hog);
    pyra_full = featpyramid(img,param.hogf);
%     fprintf('hog pyra took %.02f secs\n',toc);
else
%     fprintf('flipping hog pyra\n',toc);
    pyra = flip_hog_pyr(pyra);
    pyra_full = flip_hog_pyr(pyra_full);
end
sdiff = abs(gt.pyra_scale - param.hog.sbin./pyra.scale);
[~,order] = sort(sdiff,'ascend');
scales = sort(order(1:5));
pyra.feat = pyra.feat(scales);
% pyra.im = pyra.im(scales);
pyra.scale = pyra.scale(scales);
pyra_full.feat = pyra_full.feat(scales);
% pyra_full.im = pyra_full.im(scales);
pyra_full.scale = pyra_full.scale(scales);

%% compute unaries
nfilts = 7;
nlvls = min(length(pyra.feat),length(pyra_full.feat));
rootfilters = {model(1).filter_root};
filters = {model.filter};
unary = cell(nfilts,nlvls);
unaryfull = cell(1,nlvls);
tic
for l=1:nlvls
    rl = fconv(pyra.feat{l},filters,1,nfilts);
    
    for k=1:size(gtboxes,1)
        bl = gtboxes(k,:)*1/pyra.scale(l) + param.hog.maxsize([2 1 2 1])/2;
        gtpt = bl(1:2)';
        for r=0
            for c=0
                if abs(r)+abs(c) > 2, continue, end
                gtpt2 = round(gtpt + [c;r]);
                if any(gtpt2<1), continue, end
                if gtpt2(1)>size(rl{k},2), continue, end
                if gtpt2(2)>size(rl{k},1), continue, end
                rl{k}(gtpt2(2),gtpt2(1)) = rl{k}(gtpt2(2),gtpt2(1)) + 1000;
            end
        end
    end
    unary(:,l) = rl(:);
    

    % global filter
    rl = fconv(pyra_full.feat{l}(:,:,[19:27 32]),rootfilters,1,1);
    bl = round(gtboxes(4,:)*1/pyra_full.scale(l) + param.hogf.maxsize([2 1 2 1])/2);
    bl = boxinbounds(bl,size(rl{1}));
        rl{1}(bl(2):bl(4),bl(1):bl(3)) = rl{1}(bl(2):bl(4),bl(1):bl(3)) + 10;
        unaryfull(:,l) = rl;
end

if doflip
    0;
end
%%
[yhat,maxscore] = inference_one_model(model,unary,unaryfull,pyra,pyra_full,param,true);

%%
best_guess = yhat.pts;
F = yhat.feats;
maxlvl = yhat.maxlvl;
%
if display
    %%
%     mm = any(cat(3,masks{:}),3);
%     img(:,:,2) = img(:,:,2)+uint8(64*mm);
    figure(doflip+1)
    imsc(img(:,:,1:3))
    hold on
    if doflip
         myplot(flip_pts_lr(gt.pts,w),'wo-')
    else
        myplot(gt.pts,'wo-')
    end
    plotbox(gtboxes,'w-')
    myplot(yhat.pts,'m.-','markersize',20)

    scale = 5*mean(vec(yhat.pts_hog./yhat.pts));
    box = box_from_dims(120/scale,107/scale,yhat.root_pt);
    plotbox(box,'g--')
    myplot(yhat.root_pt,'gp')
    drawnow
    %{
    figure(2)
    imsc(sum(cat(3,unary{:,yhat.maxlvl}),3)>1)
    hold on
    myplot(yhat.pts_hog,'go-')
    myplot(gt.pts_hog,'wo-')
    %}
end
0;
