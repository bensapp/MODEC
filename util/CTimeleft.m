classdef CTimeleft < handle

    properties 
        t0
        charsToDelete = [];
        done
        total
        interval = 1;
    end
    
    methods
        function t = CTimeleft(total, interval)
            
            t.done = 0;
            t.total = total;
            if nargin>1
                t.interval = interval;
            elseif ~usejava('desktop')
                t.interval = ceil(total*t.interval/100);
            else
                t.interval = ceil(total*t.interval/1000);
            end
        end
        
        function [remaining status_string] = timeleft(t,amt)
            if t.done == 0
                t.t0 = tic;
            end
            
            if nargin == 2
                t.done = amt;
            else
                t.done = t.done + 1;
            end
            
                              
            elapsed = toc(t.t0);
            
            if t.done <= 1 || mod(t.done,t.interval)==0 || t.done == t.total || nargout > 0

                % compute statistics
                avgtime = elapsed./(t.done-1);
                remaining = (t.total-t.done+1)*avgtime;
                
                if avgtime < 1
                    ratestr = sprintf('- %.2f iter/s', 1./avgtime);
                else
                    ratestr = sprintf('- %.2f s/iter', avgtime);
                end
                
                if t.done == 1
                    remaining = -1;
                    ratestr = [];
                end
                
                timesofarstr  = sec2timestr(elapsed);
                timeleftstr = sec2timestr(remaining);
                
                %my beloved progress bar
                pbarw = 30;
                pbar = repmat('.',1,pbarw);
                pbarind = max(1,1 + round((t.done-1)/(t.total-1)*(pbarw)));
                pbar(1:pbarind-1) = '=';
                if pbarind < pbarw
                    pbar(pbarind) = '>';
                else
                        0;
                    
                end
                pbar = ['[',pbar,']'];
                
                
                status_string = sprintf('%s %03d/%03d - %03d%%%% - %s|%s %s ',pbar,t.done-1,t.total,...
                    floor((t.done-1)/t.total*100),timesofarstr,timeleftstr, ratestr);
                
                delstr = [];
                if ~isempty(t.charsToDelete)
                    delstr = repmat('\b',1,t.charsToDelete-1);
                end
           
                if nargout == 0
                    fprintf([delstr status_string]);
                end
                
                t.charsToDelete = numel(status_string);
            end
            
            if t.done == t.total && nargout == 0 
                fprintf('\n');
            end
        end
    end
end
 


%{
n = 10;
t = CTimeleft(n);
for i=1:n
    t.timeleft;
    pause(3)
end
%}


