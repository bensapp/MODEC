%% prep examples for training by cropping and updating groundtruth
examples = loadvar('../FLIC/examples.mat');
examples = flip_backwards_facing_groundtruth(examples);
% where to save the cropped images.
imgdir = './cropped-images/';
examples = make_cropped_training_dataset(examples, '../FLIC/images/', imgdir);
save examples-cropped.mat examples
postrain = examples([examples.istrain]);

%% define modes
clusterinfo = define_modes(postrain, 32);
% collect warped-to-centroid-joints and unwarped image data for making 
% thumbnail pics and training the mode filtering model.
% Takes up 963.6MB of RAM
imgdata = examples2modes(clusterinfo, postrain);
% for purposes of pretty pictures of each mode, adds 'thumbs' field.
clusterinfo = make_thumbnails(clusterinfo, imgdata);

%% train mode filter model
[params.mode_filter_w, params.mode_filter_alpha] = learn_mode_filter_cascade_model(imgdata); 

%% setup parameters and prepare groundtruth for learning
filterinfo.fdims = [5 5 32];
filterinfo.fdims_full = [9 9 10];
filterinfo.cellsize = 8;
filterinfo.cellsize_full = 16;
[postrain,params.mus,params.globalfeats] = compute_groundtruth(postrain,filterinfo,clusterinfo.mean_coords);
params = make_params(params, filterinfo, postrain);
% not a bad idea to save this for later:
mkdir('output');
save('output/training-data.mat','postrain','params','clusterinfo');

%% train MODEC
[model, trainstats] = learn_model_constraint_generation(postrain, params, clusterinfo);
save('output/model.mat','model','trainstats')

%% [optional] constrained relabeling using the learned model: this is not an exact science
postrain_relabel = postrain;
display = false;
tl = CTimeleft(length(postrain));
for i=1:length(postrain)
    tl.timeleft;
    postrain_relabel(i) = relabel_groundtruth(model,postrain(i),params,display);
end

%% [optional] retrain MODEC with updated groundtruth
[model2, trainstats2] = learn_model_constraint_generation(postrain_relabel, params, clusterinfo);
save('output/model-relabel.mat','model2','trainstats')