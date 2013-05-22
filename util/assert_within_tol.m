function assert_within_tol(a,b,tol)
denom = min(abs(a),abs(b));
if denom == 0
    assert(a==0 && b==0)
    return;
end

err = abs(single(a)-single(b));
rel_err = 100*err/denom;
if(rel_err > tol)
    error(sprintf('difference between %f and %f too great!\n',a,b))
    0;
    
end