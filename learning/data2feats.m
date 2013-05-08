function [feats,is_pos] = data2feats(hogf,pts,mus)
d = -diff(pts,[],2)-round(mus);
geom = vec([-d.^2]);
feats = vec(cellfun(@vec,hogf,'uniformoutput',false));
feats = [feats; geom(:)];
if nargout == 2
    is_pos = numel(feats)-numel(geom)+1:numel(feats);
end