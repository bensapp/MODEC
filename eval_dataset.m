%% load test set
load ../FLIC/examples.mat
examples = flip_backwards_facing_groundtruth(examples);
testex = examples([examples.istest]);
ntest = length(testex);
model = loadvar('MODEC-model.mat','mdls');

%% run MODEC over every test example, saving wrist, elbow and shoulder locations
pred_coords = nan(2,6,ntest);
for i=1:ntest
    tstart = clock;
    img = imread(fullfile('../FLIC/images/',testex(i).filepath));
    pred_i = run_modec(model, img, testex(i).torsobox);
    pred_coords(:,:,i) = pred_i.coords;
    fprintf('example %d / %d took %s\n',i,ntest,sec2timestr(etime(clock,tstart)));
end
save results.mat pred_coords
%% evaluate
load results.mat pred_coords
gt_coords = cat(3,testex.coords);

scale_by_parts = {'lsho','rhip'};
elbow_err = score_predictions(pred_coords, gt_coords, {'lelb','relb'}, scale_by_parts);
wrist_err = score_predictions(pred_coords, gt_coords, {'lwri','rwri'}, scale_by_parts);

%display 
clf
range = 1:20;
accuracyCurve(elbow_err(:),range,'b-','linewidth',3);
hold on
accuracyCurve(wrist_err(:),range,'g-','linewidth',3);
axis square, grid on
axis([range([1 end]) 1 100])