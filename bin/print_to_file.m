function print_to_file(filename,varargin)

% SeroHet software version 1.1
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.

if nargin == 1
  [dev res] = interpret_print_filename(filename);
else 
  dev = interpret_print_filename(filename);
  res = varargin{1};
end 
%keyboard

if nargin == 1
  [dev res] = interpret_print_filename(filename);
else
  dev = interpret_print_filename(filename);
  res = varargin{1};
end

fprintf('Outputting figure to %s\n', filename);
print(['-d' dev], ['-r' num2str(res)], '-bestfit', filename);

end
