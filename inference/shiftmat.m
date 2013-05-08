function X=shiftmat(X0,shifts,val)
% function X=shiftmat(X,shifts,val)
% Like padarray, shifts contents of the matrix by padding and cropping
% shifts = [num_rows_shift num_cols_shift]. Only works in 2d arrays for now.
X = mex_shiftmat(double(X0),double(round(shifts)),double(val));
