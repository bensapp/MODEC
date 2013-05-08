%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Given a set of hits coming from an image, returns a feature vector for
%%% each hit. The feature vector is of size NUM_POSELETS and the i'th element
%%% is the max score of all hits of type i compatible with the current hit.
%%% Two hits are compatible if their KL-divergence is less than a threshold.
%%%
%%% Copyright (C) 2009, Lubomir Bourdev and Jitendra Malik.
%%% This code is distributed with a non-commercial research license.
%%% Please see the license file license.txt included in the source directory.
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [features,contrib_hits,dsts]=get_context_features_in_image(all_hyps,hits)
global config;

% They must all come from the same image
%assert(all(hits.image_id(2:end)==hits.image_id(1)));
dist_thresh = config.HYP_CLUSTER_THRESH;

features=zeros(hits.size,length(all_hyps),'single');
for h=1:hits.size
    features(h,hits.poselet_id(h))=hits.score(h); % at the feature itself to the context
end

hyps  = instantiate_hypotheses(all_hyps,hits);
contrib_hits = [];
if 0 && nargout>1
    % Also returns for each hit the indices of all hits closer than the
    % distance
    for h=1:hits.size
        contrib_hits{h}=h;
    end
    for h1=1:(hits.size-1)
        for h2=(h1+1):hits.size
            dst=hyps(h1).distance(hyps(h2));
            if dst<dist_thresh
                features(h1,hits.poselet_id(h2)) = max(features(h1,hits.poselet_id(h2)),hits.score(h2));
                features(h2,hits.poselet_id(h1)) = max(features(h2,hits.poselet_id(h1)),hits.score(h1));
                contrib_hits{h1}(end+1)=h2;
                contrib_hits{h2}(end+1)=h1;
            end
        end
    end
elseif 0
    dsts_slow = zeros(hits.size);
    tic
    for h1=1:(hits.size-1)
        for h2=(h1+1):hits.size
            dst=hyps(h1).distance(hyps(h2),config);
            dsts_slow(h1,h2) = dst;
            if dst<dist_thresh
                features(h1,hits.poselet_id(h2)) = max(features(h1,hits.poselet_id(h2)),hits.score(h2));
                features(h2,hits.poselet_id(h1)) = max(features(h2,hits.poselet_id(h1)),hits.score(h1));
            end
        end
    end
    toc
else
    %% bensapp's way: vectorized
    mus = cat(3,hyps.mu);
    sigs = cat(3,hyps.sigma);
    rects = cat(1,hyps.rect);
    dsts = mex_poselet_dists_fast(squeeze(mus(:,1,:)),squeeze(mus(:,2,:)),squeeze(sigs(:,1,:)),squeeze(sigs(:,2,:)),rects(:,1),rects(:,2),rects(:,3),rects(:,4));
    dsts(dsts>1e35) = Inf;

    [r,c] = find(dsts<dist_thresh);
    inds = find(c>r);
    for i=1:length(inds)
        h1 = r(inds(i));
        h2 = c(inds(i));
        features(h1,hits.poselet_id(h2)) = max(features(h1,hits.poselet_id(h2)),hits.score(h2));
        features(h2,hits.poselet_id(h1)) = max(features(h2,hits.poselet_id(h1)),hits.score(h1));
    end
    0;
end
end