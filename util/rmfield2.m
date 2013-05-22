function s = rmfield2(s,slist)
assert(iscell(slist));
inds = isfield(s,slist);
if any(inds)
    s = rmfield(s,slist(inds));
end
