%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Demo file that loads an image, finds the people and draws bounding
%%% boxes around them.
%%%
%%% Copyright (C) 2009, Lubomir Bourdev and Jitendra Malik.
%%% This code is distributed with a non-commercial research license.
%%% Please see the license file license.txt included in the source directory.
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global config;
init;
time=clock;

config.USE_MEX_HOG=true;

% Choose the category here
category = 'person';
data_root = [config.DATA_DIR '/' category];
disp(['Running on ' category]);
faster_detection = true;  % Set this to false to run slower but higher quality
interactive_visualization = false; % Enable browsing the results
enable_bigq = true; % enables context poselets
config.DETECTION_IMG_MIN_NUM_PIX = 500^2;  % if the number of pixels in a detection image is < DETECTION_IMG_SIDE^2, scales up the image to meet that threshold
config.DETECTION_IMG_MAX_NUM_PIX = 750^2;
config.PYRAMID_SCALE_RATIO = 2;

% Loads the SVMs for each poselet and the Hough voting params
load('person-model');
img = imread('test.jpg');

%%
[bounds_predictions,poselet_hits,torso_predictions]=detect_objects_in_image(img,model);


%%
display_thresh=5.7; % detection rate vs false positive rate threshold
cla, imagesc(img); axis image
bounds_predictions.select(bounds_predictions.score>display_thresh).draw_bounds;
torso_predictions.select(bounds_predictions.score>display_thresh).draw_bounds('blue');
