function [constraints,yhats] = genconstraints(params, w, iter)
% To make training feasible, it's important to generate constraints for 
% all examples in parallel.  Here we leave it as a for-loop and leave it up
% to you to parallelize using your setup of choice.  For the paper
% we had at our disposale a lab-shared 48-core setup across 10 machines, in
% which we distributed computation using the Sun Grid Engine.

constraints = cell(params.n,1);
yhats = cell(params.n,1);
for i=1:100:params.n
    warning('This loop should be parallelized! Training on 1% of the data only. See comments.');
    fprintf('epoch #%d, example %d / %d\n', iter, i, params.n);
    drawnow;
    
    yhats{i} = params.constraintFn(params, w, i, params.labels(i));
    constraints{i} = params.featureFn(params, params.labels(i), yhats{i})';
end
yhats = [yhats{:}];