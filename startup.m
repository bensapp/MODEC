addpath poselets-lite/
addpath boxutil/
addpath util/
addpath features/
addpath inference/
addpath eval/
addpath learning/

% See features/fconv.m and compile.m for use.
global do_multithread_fconv;
do_multithread_fconv = true;

% Attempt to compile if mex files don't exist
try
    subarray(rand(10),[2 2 5 7]);
catch 
    fprintf('Compiling everything because ''subarray'' function failed.\n');
    compile;
end