% WHOSBETTER is a function that sorts the WHOS output according a user
% defined input (ie name, size, bytes, type etc.).  The output also
% includes the FULL size rather than the #-D labels that TMW prefers. The
% output is also human readable and incorporates the use of b (byte), kn
% (kilobyte), Mb (megabyte), and Gb(gigabyte) labeling.
%
% whosbetter -n  name ordered  (DEFAULT)
% whosbetter -s  size ordered  (NOT IMPLEMENTED)
% whosbetter -b  byte ordered
% whosbetter -t  type ordered  (NOT IMPLEMENTED)
%
% SYTNAX: whosbetter -n        (DEFAULT)
%         whosbetter -b
%
% DBE 2005/04/05
%
% Version 1.1 
%     - Now handles ALL the arguments that WHOS does
%     - Includes base stack summary (total # array elements and total size)
%
% Version 1.2
%     - Improved handling of input arguments
%     - Returns proper stack in debug mode
%     - Minor output spacing improvements
%     - Return NOTHING if the stack is clear/empty
%
% Version 1.3
%     - Improve Class labeling for ALL classes and ALL complex classes...
%
% Future Improvements:
%   1) Include handling for -s and -t options
%   2) Improve Class labeling for all classes and all complex classes...

function whosbetter(varargin);

if nargin==0 
    opt='-b';
  offset=0;
elseif isstr(varargin{end}) && isempty(strmatch(varargin{end},{'-n','-s','-b','-t'})) && ...
        ~evalin('caller',sprintf('exist(''%s'',''var'')',varargin{end})) && isempty(strfind(varargin{end},'*'))
    evalin('caller',['ans = ',varargin{end},';']);
    varargin{1} = 'ans';
    opt = '-b';
    offset = 0;
elseif strmatch(varargin{end},{'-n','-s','-b','-t'})
  opt=varargin{end};
  offset=1;
else
    opt='-b';
  offset=0;
end

% Concatenate the input variables into a WHO argument
i=1;
who_str=[];
while i<=length(varargin)-offset
  if i~=length(varargin)-offset
    who_str=[who_str,'''',char(varargin{i}),''',']; i=i+1;
  else
    who_str=[who_str,'''',char(varargin{i}),'''']; i=i+1;
  end
end
who_str=deblank(who_str);

% Exceute the WHO call
if ~isempty(who_str) & isempty(dbstack)
  S=evalin('base',['whos(',who_str,')']);
elseif isempty(who_str) & isempty(dbstack)
  S=evalin('base','whos');
elseif ~isempty(who_str) & ~isempty(dbstack)
  S=evalin('caller',['whos(',who_str,')']);
elseif isempty(who_str) & ~isempty(dbstack)
  S=evalin('caller','whos');
end

if size(S,1)==0, 
%   fprintf('Warning: No variables found in the base stack meet the criteria.\n');
%   warning('You''re input options may not be supported'); 
  return; 
end

switch lower(char(opt))
  case '-n'   % Variable NAME sorted output (DEFAULT)
    showQ(S);
  case '-s'
    error('Unfortunately the -s option is currently unsupported.');
  case '-b'   % Variable BYTE sorted output (DEFAULT)
    for k=1:size(S,1)
      bytes(k)=S(k).bytes;
    end
    [bytes_sorted,ind]=sort(bytes);

    for k=1:size(S,1)
      Q(k,1).name=S(ind(k)).name;
      Q(k,1).size=S(ind(k)).size;
      Q(k,1).bytes=S(ind(k)).bytes;
      Q(k,1).class=S(ind(k)).class;
    end
    
    showQ(Q);
  case '-t'
    error('Unfortunately the -t option is currently unsupported.');
  otherwise
    error('Input option not understood');
end

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showQ(Q);

% Determine the max/min variable NAME length
for k=1:size(Q,1)
  var_name_len(k)=length(Q(k).name);
end

% Generate the matrix SIZE string
for k=1:size(Q,1)
  tmp=[];
  for n=1:length(Q(k).size)
    if n~=length(Q(k).size)
      tmp=strcat(tmp,[num2str(Q(k).size(n)),'x']);
    else
      tmp=strcat(tmp,[num2str(Q(k).size(n))]);
    end
  end
  sz_str{k}=tmp;
end

% Generate the byte SIZE string in HUMAN readable format
for k=1:size(Q,1)
  if Q(k).bytes<1e3
    byte_str{k}={[num2str(Q(k).bytes,'%3.1f'),'b ']};
  elseif Q(k).bytes<1e6
    byte_str{k}={[num2str(Q(k).bytes/1e3,'%3.1f'),'kb']};
  elseif Q(k).bytes<1e9
    byte_str{k}={[num2str(Q(k).bytes/1e6,'%3.1f'),'Mb']};
  elseif Q(k).bytes<1e12
    byte_str{k}={[num2str(Q(k).bytes/1e9,'%3.1f'),'Gb']};
  elseif Q(k).bytes<1e15
    error('There is no WAY you have an array greater than 1Tb!!!!');
  end
end

% ALIGNMENT...
% Determine # alignment spaces after variable NAME
max_len=max(var_name_len);  % Tabs are 8 spaces...
min_len=min(var_name_len);
max_spc=ceil((max(var_name_len)-min(var_name_len)+eps));
for k=1:size(Q,1)
  n_spc1(k)=max_spc-ceil((var_name_len(k)))+6+3;
end

name_spc=max_spc-4+6;  % Space for NAME heading

% Determine # alignment spaces after array size
for k=1:size(Q,1)
  sz_str_len(k)=length(sz_str{k});
end
max_sz_str_len=max(sz_str_len);
for k=1:size(Q,1)
  n_spc2(k)=max_sz_str_len-ceil((sz_str_len(k)))+5;
end

size_spc=max_sz_str_len-4+5;  % Space after SIZE heading

% Determine # alignment spaces before byte string
for k=1:size(Q,1)
  byte_str_len(k)=length(char(byte_str{k}));
end
max_byte_str_len=max(byte_str_len);
for k=1:size(Q,1)
  n_spc3(k)=max_byte_str_len-ceil((byte_str_len(k)));
end

byte_spc=7;
complex_str=cell(1);
% Generate a COMPLEX tag for the array type...
for k=1:size(Q,1)  
  % Generate COMPLEX string
  switch Q(k).class
    case 'double'
      byte_per_num=8;
      complex_str=need_complex_str(Q,k,complex_str,byte_per_num);
    case 'single'
      byte_per_num=4;
      complex_str=need_complex_str(Q,k,complex_str,byte_per_num);
    case {'int8','uint8'}
      byte_per_num=1;
      complex_str=need_complex_str(Q,k,complex_str,byte_per_num);
    case {'int16','uint16'}
      byte_per_num=2;
      complex_str=need_complex_str(Q,k,complex_str,byte_per_num);
    case {'int32','uint32'}
      byte_per_num=4;
      complex_str=need_complex_str(Q,k,complex_str,byte_per_num);
    case {'int64','uint64'}
      byte_per_num=8;
      complex_str=need_complex_str(Q,k,complex_str,byte_per_num);
    otherwise % Logical, char, cell, struct, function_handle, CUSTOM
      complex_str{k}=[];
  end
end

% Determine the TOTAL number of bytes
for k=1:size(Q,1)
  bytes_vec(k)=Q(k).bytes;
  elem_vec(k)=prod(Q(k).size);
end
bytes_total=sum(bytes_vec);
if bytes_total<1e3
  bytes_total_str={[num2str(bytes_total,'%3.1f'),'b ']};
elseif bytes_total<1e6
  bytes_total_str={[num2str(bytes_total/1e3,'%3.1f'),'kb']};
elseif bytes_total<1e9
  bytes_total_str={[num2str(bytes_total/1e6,'%3.1f'),'Mb']};
elseif bytes_total<1e12
  bytes_total_str={[num2str(bytes_total/1e9,'%3.1f'),'Gb']};
elseif bytes_total<1e15
  error('There is no WAY you have an total array space greater than 1Tb!!!!');
end

% Insert commas in the element total to make it more readable...is there an easier way?!?!?
elem_total=fliplr(char(num2str(sum(elem_vec))));
elem_ind=[1:3:length(elem_total)];
elem_new=[];
for k=1:length(elem_ind)-1
  elem_new=[elem_new,elem_total(3*(k-1)+1:3*(k-1)+3),','];
end
elem_total=fliplr([elem_new,elem_total(3*(k-1)+4:end)]);

% Output the information...
fprintf(['  Name',repmat(' ',[1 name_spc]),'Size',repmat(' ',[1 size_spc]),'Bytes',repmat(' ',[1 byte_spc]),'Class\n']);
tmp=[];
for k=1:size(Q,1)
  tmp=strcat(tmp,['   ',Q(k).name,repmat(' ',[1 n_spc1(k)]),char(sz_str{k}),repmat(' ',[1 n_spc2(k)]),repmat(' ',[1 n_spc3(k)]),char(byte_str{k}),'     ',Q(k).class,char(complex_str{k}),'\n']);
end
fprintf(tmp);
fprintf(['\nGrand total is ',elem_total,' elements using ',char(bytes_total_str),'ytes\n\n']);

return

function complex_str=need_complex_str(Q,k,complex_str,byte_per_num)
if Q(k).bytes==0 & prod(Q(k).size)==0
  complex_str{k}=[];
elseif Q(k).bytes/(prod(Q(k).size)*byte_per_num)==1
  complex_str{k}=[];
elseif Q(k).bytes/(prod(Q(k).size)*byte_per_num)==2
  complex_str{k}=' (complex)';
else
  complex_str{k}=[]; %error('Can not determine if VARIABLE is complex or not.');
end
return