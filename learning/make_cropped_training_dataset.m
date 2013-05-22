function examples = make_cropped_training_dataset(examples, indir, outdir)
system(['mkdir -p ' outdir]);
n = length(examples);
targetdims = [240 320];
tl = CTimeleft(n);
for i=1:n
    tl.timeleft;
       
    tbox = examples(i).torsobox;
    [ubbox, scale, bdims, ctr] = tbox2ubbox(tbox);
    img = imread(fullfile(indir,examples(i).filepath));

    imgc = uint8(subarray(img,ubbox));
    origdims = size(imgc);
    imgc = imresize(imgc,targetdims,'bilinear');
    examples(i).filepath = sprintf('%s/%s',outdir,examples(i).filepath);
    examples(i).imgdims = size(imgc);
    imwrite(imgc, examples(i).filepath);

    scale = targetdims./origdims(1:2);
    examples(i).coords = bsxfun(@times,bsxfun(@minus,examples(i).coords,ubbox(1:2)'+1),scale([2 1])');
    
    if 0
        %%
        cla, imagesc(imgc), axis image, hold on
        myplot(examples(i).coords(:,1:3),'go-');
        myplot(examples(i).coords(:,4:6),'go-');
        0;
    end
end
