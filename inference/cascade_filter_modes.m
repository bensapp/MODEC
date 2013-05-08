function [possible_modes, scores, thresh] = cascade_filter_modes(img,W,alpha)
targetdims = [150 134];
img = imresize(img,[targetdims(1) NaN],'bilinear');
img = img(:,end-targetdims(2)+1:end,:);
hi = hog_features_no_contrast(img(:,:,1:3),8);
scores = W'*[hi(:);1];
[maxscores,pred] = max(scores);
meanscores = mean(scores);
if isinf(alpha) && alpha < 0
    thresh = -Inf;
else
    thresh = alpha*maxscores + (1-alpha)*meanscores;
end
possible_modes = (scores >= thresh);