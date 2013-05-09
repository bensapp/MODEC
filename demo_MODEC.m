%% setup
startup;
close all;
imgfile = 'example.jpg';
model = loadvar('MODEC-model.mat','mdls');
% slower, better model:
% model = loadvar('MODEC-model-full.mat','mdls');
load cluster_info.mat

%% detect a torso
img = imread(imgfile);
[bounds_predictions,poselet_hits,torso_predictions] = poselets_lite_detect(img);
% take top scoring torso only:
torso = rect2box(torso_predictions.bounds(:,1)');

%% run pose estimator on most confident torso
pred = run_modec(model, img, torso);

%% display results
figure(1)
cla, imagesc(img), hold on, axis image
plotbox(torso,'w:')
myplot(pred.coords(:,lookupPart('lsho','lelb','lwri')),'go-','linewidth',3)
myplot(pred.coords(:,lookupPart('rsho','relb','rwri')),'bo-','linewidth',3)

%% display the top 5 right-side modes, sorted by inference score
figure(2), clf
[~,order_right] = sort(pred.mode_scores(:,2),'descend');
imagesc([cluster_info.thumbs{order_right(1:5)}]);
axis image off