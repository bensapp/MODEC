function [box, scale, bdims, ctr] = tbox2ubbox(tbox)
ctr = [mean(tbox([1 3])); tbox(2)];
width = abs(diff(tbox([1 3])));
width = width*1.4;
scale = 50/width;
bdims = [-100 -50 100 100];
imgdims = [bdims(4)-bdims(2),bdims(3)-bdims(1)];
box = ctr([1 2 1 2])' + bdims/scale;
    