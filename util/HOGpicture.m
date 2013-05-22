function varargout = HOGpicture(w, bs)
if nargin < 2, bs = 20; end
% HOGpicture(w, bs)
% Make picture of positive HOG weights.

if size(w,3) > 9
%     assert(size(w,3)==31 || size(w,3)==32 || size(w,3)==36)
    w = foldHOG(w);
end

% construct a "glyph" for each orientaion
bim1 = zeros(bs, bs);
bim1(:,round(bs/2):round(bs/2)+1) = 1;
bim = zeros([size(bim1) 9]);
bim(:,:,1) = bim1;
for i = 2:9,
    bim(:,:,i) = imrotate(bim1, -(i-1)*20, 'crop');
end

%%

w(w<0) = 0;
%w = w+min(w(:));


im = w2im(w,bim);

%%



if nargout == 0
    d = uint8(255*scale01(im));
    imagesc((bs/20)*2*d); axis image, colormap gray
else
    varargout{1} = im;
end

function im = w2im(w,bim)
im = 0;
sz = size(bim).*size(w);
sz = sz(1:2);
W = imresize(w,sz,'nearest');
B = repmat(bim,size(w,1),size(w,2));
im = sum(B.*W,3);

function f = foldHOG(w)
% f = foldHOG(w)
% Condense HOG features into one orientation channel.

if size(w,3) >= 27
    f=w(:,:,1:9)+w(:,:,10:18)+w(:,:,19:27);
elseif size(w,3) == 36
    f = f+w(:,:,28:36);
else
    f=w(:,:,1:9);
end
