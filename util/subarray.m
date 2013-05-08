function B = subarray(A, box)

nc = size(A,3);
B = {};
for k=1:nc
    B{k} = mex_subarray(double(A(:,:,k)),round(double(box)));
end
B = cat(3,B{:});

return
%% test

img = imread(idx2file(12345));
img = img(5:end-5,5:end-5,:);
box = [-50 100 400 600];
sfigure(1)
imsc(img);

sfigure(2)
imsc(subarray(img,box))
