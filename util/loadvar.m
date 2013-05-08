function X=load2(filename,field);
%{
% Timothee Cour, 05-Mar-2009 17:51:01 -- DO NOT DISTRIBUTE

whos('-file',filepath)
%}

if nargin<2 || isempty(field)
    temp=load(filename);
    fields= fieldnames(temp);
    if length(fields)==1
        X=temp.(fields{1});
    else
        X=temp;
    end
else
    temp=load(filename,field);
    X=temp.(field);
end
