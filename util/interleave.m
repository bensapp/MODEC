function x = interleave(v1,v2)
if isempty(v2),x=v1; return; end
x = repmat(v1(1),[length(v1)+length(v2) 1]);
i1=1;
i2=1;
for i=1:length(x)
    if (i2>=i1 && i1<=length(v1)) || i2>length(v2)
        x(i) = v1(i1); i1=i1+1;
    else
        x(i) = v2(i2); i2=i2+1;
    end
end
