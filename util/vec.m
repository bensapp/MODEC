function v=vec(A)

if iscell(A)
    v = cat(1,A{:});
else
    v=A(:);
end
