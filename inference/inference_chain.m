function [maxscore,pred,ps] = inference_chain_model(ps)
%% pairwise
msgsum = 0;
ninf = -1e5;
oobval = ninf;
for i=length(ps):-1:2
    msgsum = msgsum+ps(i).scores;
    [msgDT,argmax_x,argmax_y] = dt(msgsum,ps(i).coeff_dx2,0,ps(i).coeff_dy2,0);
    %%
    a = shiftmat(msgDT,ps(i).mu([2 1]),oobval);
    b = shiftmat(argmax_x,ps(i).mu([2 1]),max(argmax_x(:)));
    c = shiftmat(argmax_y,ps(i).mu([2 1]),max(argmax_y(:)));
    %% 
    msgup = a;
    ps(i).argmax_x = b;
    ps(i).argmax_y = c;
    
    %%
    msgsum = msgup;
end
msgsum = msgsum+ps(1).scores;
[maxscore,maxind] = max(msgsum(:));
%% backtrack
foff = 0;
ps(1).maxind = maxind;
ps(1).maxpt = double(ind2pts(size(msgsum),ps(1).maxind)-foff);
for i=2:length(ps)
    ps(i).maxpt = double([ps(i).argmax_x(ps(i-1).maxind); ps(i).argmax_y(ps(i-1).maxind)]);
    ps(i).maxind = double(sub2ind2(size(ps(i).argmax_x),ps(i).maxpt(2),ps(i).maxpt(1)));
end
pred = [ps.maxpt];

