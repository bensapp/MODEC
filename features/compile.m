mex -O resize.cc
mex -O reduce.cc
mex -O dt.cc
mex -O features.cc

% use one of the following depending on your setup
% 1 is fastest, 3 is slowest
% 1) multithreaded convolution using blas
% mex -O fconvblas.cc -lmwblas -o fconv_blas
% 2) mulththreaded convolution without blas
mex -O fconvMT.cc -o fconv_multithread
% mex -O fconvcMT.cc -o fconvc
% 3) basic convolution, very compatible
mex -O fconv.cc -o fconv_singlethread