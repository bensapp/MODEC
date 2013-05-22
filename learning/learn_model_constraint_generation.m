function [mdls, trainstats] = learn_model_constraint_generation(postrain, params, clusterinfo)

%% set up positivity constraints for deformation parameters
[~,~,~,pos_params] = gt2feats(postrain(1),params.fdims,params.fdims_full,params.cellsize,params.cellsize_full,params.mus,params.globalfeats);
pos_constraints_k = sparse(1:length(pos_params),pos_params,1.0,length(pos_params),params.d+1);
pos_constraints = repmat({pos_constraints_k},[params.k 1]);
Xpositivity = blkdiag(pos_constraints{:});
% Set the minimum positivity to be epsilon,
epsilon = 0.001;
% makes constraint w_i > epsilon + slack_i
Xpositivity = 1/epsilon*Xpositivity;
% extra "is neg" bias feature
Xpositivity(:,end+1) = 0;
% extra left-right compatibility features
Xpositivity(:,end+1:end+4) = 0;
assert(size(Xpositivity,2)==params.dimension)
% we found that parsing constraints work  better than detection constraints
params.get_parsing_constraints = true;
params.get_detection_constraints = false;

%% training settings. 
% 20 epochs results in about 64GB of RAM. C value 
% found from cross-validation.
nepochs = 20;
t_start = clock;
C = 0.0008;

% trainging info
liblinear_times = zeros(nepochs,1);
constraint_gen_times = zeros(nepochs,1);
Xsizes = zeros(nepochs,3);

model.w = zeros(params.dimension,1);
X = [];
%% main training loop:
for iter=1:nepochs
    tic
    constraints = genconstraints(params,model.w, iter);
    constraint_gen_times(iter) = toc;
    fprintf('constraint generation time: %s\n',sec2timestr(constraint_gen_times(iter)))
    
    tic
    X = vertcat(X,Xpositivity,constraints{:});
    fprintf('constraint concatenation time: %s\n',sec2timestr(toc))
    
    whos2 X
    tmp=whos('X');
    Xsizes(iter,:)=[size(X) tmp.bytes/2^30];
    
    tic
    model = liblinear_train(ones(size(X,1),1),X,sprintf('-s 1 -c %f -B -1',C));
    liblinear_times(iter) = toc;
    fprintf('training time: %s\n',sec2timestr(liblinear_times(iter)))
    
    % prune, very conservatively
    tic
    scores = X*model.w(:);
    to_prune = (scores >= 1.1) & (~params.get_detection_constraints|(1:size(X,1))'>params.n);
    X = X(~to_prune,:);
    fprintf('dropped %d (%.01f%%) constraints, time: %s\n',sum(to_prune), 100*mean(to_prune),sec2timestr(toc))
    
    
    figure(1)
    % show scores and decision margin 
    cla,
    plot(sort(scores))
    hold on
    plot([1 size(X,1)],[1 1],'k--')
    xlabel('sorted constraint scores')
    set(gcf,'name',sprintf('iter %d',iter))
    
    figure(2)
    % pick a random model to show
    mdls = modelvec2models(model.w,params) 
    rr = randi(32);
    HOGpicture(mdls.models{rr}(1).filter_root)
    set(gcf,'name',sprintf('iter %d, showing model %d',iter,rr))
    
    drawnow
end
t_end = clock;
fprintf('TOTAL cutting plane training time: %s\n',sec2timestr(etime(t_end,t_start)))

trainstats = bundle(liblinear_times, Xsizes, constraint_gen_times);