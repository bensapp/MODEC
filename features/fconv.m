function response = fconv(varargin)
global do_multithread_fconv;
if do_multithread_fconv
    response = fconv_multithread(varargin{:});
else
    response = fconv_singlethread(varargin{:});
end