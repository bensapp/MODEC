function [Wavg, alpha] = learn_mode_filter_cascade_model(imgdata)

%% features
n = length(imgdata.exinds);
X = [];
fprintf('Computing hog features.\n');
tl = CTimeleft(n);
for i=n:-1:1
    tl.timeleft;
    % It turns out that training with warped-to-mode-centroid images leads to 
    % better performing models, even when at test time the images are not
    % warped to mode centers (obviously, because we don't know which mode
    % they belong to).
    X(i,:) = vec(hog_features_no_contrast(imgdata.warped{i},8));
end

% add a bias term
X(:,end+1) = 1;
y = imgdata.modeinds(:);
whos2 X y

%% training
fprintf('Training multiclass model with cascade-loss.\n');
alpha = 0.6;
sgd_iters = 5e5;
lambda = 0.001;
wcell = mex_cascade_multiclass(X,y',alpha,sgd_iters,lambda);
% wcell holds snapshots of the sgd at different iterations.  Averaging is
% better than taking just the last iteration.
wcell(cellfun(@isempty,wcell)) = [];
Wavg = sum(cat(3,wcell{20:length(wcell)}),3)';
fprintf('Training finished.\n');


