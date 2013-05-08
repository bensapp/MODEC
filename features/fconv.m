function response = fconv(varargin)
if usejava('desktop') % heuristic for not running multicore parallelization for learning
    response = fconv_multithread(varargin{:});
else
    response = fconv_singlethread(varargin{:});
end