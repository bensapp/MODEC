function pyra =  flip_hog_pyr(pyra)
nlvls = length(pyra.scale);
for i=1:nlvls
   pyra.feat{i} = flip_hog(pyra.feat{i});
   if isfield(pyra,'im')
    pyra.im{i} = fliplr(pyra.im{i});
   end
end
