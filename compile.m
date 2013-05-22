mex -O boxutil/mex_all_pairs_box_IoU.cpp -o boxutil/mex_all_pairs_box_IoU
mex -O features/resize.cc -o features/resize
mex -O features/reduce.cc -o features/reduce
mex -O features/features.cc -o features/features
mex -O features/mex_hog_features_no_contrast.cpp -o features/mex_hog_features_no_contrast
mex -O inference/dt.cc -o inference/dt
% the -lut here is to link in ctrl-c press awareness in the mex:
mex -O learning/mex_cascade_multiclass.cpp -o learning/mex_cascade_multiclass -lut
mex -O util/mex_shiftmat.cpp -o util/mex_shiftmat
mex -O util/mex_subarray.cpp -o util/mex_subarray
mex -O poselets-lite/mex_poselet_dists_fast.cpp -o poselets-lite/mex_poselet_dists_fast

% use one of the following depending on your setup
% 1 is fastest, 3 is slowest
% 1) multithreaded convolution using blas
% mex -O fconvblas.cc -lmwblas -o fconv_blas
% 2) mulththreaded convolution without blas
mex -O features/fconvMT.cc -o features/fconv_multithread
% mex -O fconvcMT.cc -o fconvc
% 3) basic convolution, very compatible
mex -O features/fconv.cc -o features/fconv_singlethread