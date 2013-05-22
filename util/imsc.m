function varargout = imsc(img)
if isstr(img), img = imread(img); end    
cla, h = imagesc(img); axis image, hold on, axis off
set(gca,'Position',[0 0 1 1])
if nargout == 1
    varargout{1} = h;
end