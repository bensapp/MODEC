function [f,idx]=hog_features_no_contrast(img,cellsize)
% cellsize is the size of a HOG cell - it should be even.

if nargin == 1
    cellsize = 4;
end


img = im2double(img);
assert(size(img,3)==3);
assert(rem(cellsize,2)==0)

[h,w,z] = size(img);
newsize = round([h w]/cellsize)-2;

if nargout == 2
    [x,y] = meshgrid(1:h,1:w);
    newx = round(x/cellsize)-2;
    newy = round(y/cellsize)-2;
    idx = cat(3,newx,newy,0*newx);
end

f = mex_hog_features_no_contrast(img,cellsize);

assert(isempty(f)  || isequal(newsize,size2(f,[1 2])))

return

%%
%img = im2double2(imread('chicago3.jpg'));
[f] = hog_features_no_contrast(img);


figure(1), imsc(img);

figure(2), imagesc(uint8(idx));

figure(3), imsc(f(:,:,end))
figure(4); HOGpicture(f);

%%
b = 8;
s=[];
for i=20:150
   s(i,:) = size(hog_features(rand(i,2*i,3),b));
end

clf
plot(s(20:150,1),'.')
hold on
% plot(floor(((20:150)+b/2)/b-2));
plot(round((20:150)/b)-2,'ko')