function pred = run_modec(model,img,torso)

if nargin > 2
    %% crop to canonical aspect ratio
    cropbox = tbox2ubbox(torso);
    imgc = uint8(subarray(img,cropbox));
else
    imgc = img;
    cropbox = [1 1 size(img,2) size(img,1)];
end

if 0
    %% 
    % for pixel-precise replication of paper results, there is an extra
    % needless jpeg compression step at this point (barely changes anything).
    imwrite(imgc,'tmp.jpg');
    imgc = imread('tmp.jpg');
end

%% run
[yhat,yhats] = run_models(imgc,model,model.params,false);
pred.pts = [yhat.left.pts flip_pts_lr(yhat.right.pts,size(imgc,2))];
pred.coords = [yhat.left.pts(:,[3 5 7]) flip_pts_lr(yhat.right.pts(:,[3 5 7]),size(imgc,2))];
pred.mode = [yhat.pred_modes];
pred.unfiltered_modes = yhat.unfiltered_modes;
if 0
    %%
    cla
    imagesc(imgc)
    hold on
    myplot(pred.pts,'go-')
end
pred.pts = bsxfun(@plus,pred.pts,cropbox(1:2)'+1);
pred.coords = bsxfun(@plus,pred.coords,cropbox(1:2)'+1);
pred.mode_scores = yhats.mode_scores;
pred.global_scores = yhats.global_scores;
%% gather output from all 32 left & right models, useful for some applications...
yl = [yhats.left{:}];
ylmean = mean(cat(3,yl.pts),3);
yr = [yhats.right{:}];
yrmean = mean(cat(3,yr.pts),3);

pred.coordsl = {};
pred.coordsr = {};
for i=1:length(yhats.left)
    if isempty(yhats.left{i})
        yhats.left{i}.pts = ylmean;
    end
    if isempty(yhats.right{i})
        yhats.right{i}.pts = yrmean;
    end
         
    pred.coordsl{i} = yhats.left{i}.pts(:,[3 5 7]);
    pred.coordsr{i} = flip_pts_lr(yhats.right{i}.pts(:,[3 5 7]),size(imgc,2));
    pred.coordsl{i} = bsxfun(@plus,pred.coordsl{i},cropbox(1:2)'+1);
    pred.coordsr{i} = bsxfun(@plus,pred.coordsr{i},cropbox(1:2)'+1);
end


