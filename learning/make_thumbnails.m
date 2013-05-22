function info = make_thumbnails(info, imgdata)
%% read in and warp images to cluster centers before taking average
for i=1:length(info.mean_coords)
    % Increase contrast and oversaturate the average image.  This makes
    % for more exciting, possibly gloomier looking thumbnails.
    warpedi = imgdata.warped(i == imgdata.modeinds);
    info.thumbs{i} = 1.5*uint8(255*scale01(mean(cat(4,warpedi{:}),4).^4));
    subplot(4,8,i);
    cla, imagesc(info.thumbs{i}), axis image off
    title(sprintf('cluster %d --- %d images', i, length(warpedi)));
    drawnow
end