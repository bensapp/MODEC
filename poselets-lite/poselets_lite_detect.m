function [bounds_predictions,poselet_hits,torso_predictions] = poselets_lite_detect(img)
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

time=clock;
init;

config.USE_MEX_HOG = true;

faster_detection = true;  % Set this to false to run slower but higher quality
interactive_visualization = false; % Enable browsing the results
enable_bigq = true; % enables context poselets

if faster_detection
    config.DETECTION_IMG_MIN_NUM_PIX = 240^2;  % if the number of pixels in a detection image is < DETECTION_IMG_SIDE^2, scales up the image to meet that threshold
    config.DETECTION_IMG_MAX_NUM_PIX = 640^2;  
    config.PYRAMID_SCALE_RATIO = 2;
end

% Loads the SVMs for each poselet and the Hough voting params
load('person-model.mat'); % model, label_masks, poselet_thumbs
if ~enable_bigq
   model =rmfield(model,'bigq_weights');
   model =rmfield(model,'bigq_logit_coef');
end

[bounds_predictions,poselet_hits,torso_predictions] = detect_objects_in_image(img,model);

warning('off','MATLAB:structOnObject')
bounds_predictions = struct(bounds_predictions);
torso_predictions = struct(torso_predictions);
poselet_hits = struct(poselet_hits);
warning('on','MATLAB:structOnObject')
0;