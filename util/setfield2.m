function s = setfield2(s,fname,f,idx,unpack_cells)


if nargout == 0
    error('setfield2 should assign to something!')
end

n = length(s);
if nargin < 4 || isempty(idx)
    idx = n:-1:1;
end
if nargin < 5
    unpack_cells = 1;
end

if islogical(idx)
    idx = find(idx);
end
if ischar(f), 
    f = {f};
end
idx = idx(:)';

single_val = 0;
if length(f) == 1 || isempty(f)
    single_val = 1;
end

% if matrix, make rows the entries
if isnumeric(f) && size(f,1) > 1 && size(f,2)> 1
    f = mat2cell(f,ones(size(f,1),1));
end

assert(isempty(s) || n == length(f) || single_val);

if isempty(s),
    clear s;
    idx = length(f):-1:1;
end

if single_val
    if iscell(f) && unpack_cells
        f = f{:};
        for i=idx, s(i).(fname) = f; end
    else
        for i=idx, s(i).(fname) = f; end
    end
else
    if iscell(f) && unpack_cells
        for i=idx, s(i).(fname) = f{i}; end
    else
        for i=idx, s(i).(fname) = f(i); end
    end
end