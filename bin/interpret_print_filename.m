function [dev,res] = interpret_print_filename(filename)

% SeroHet software version 1.0
% Copyright (c) 2021 Hanjun Lee, Seo Yihl Kim, Dong Wook Kim,
% Young Soo Park, Jin-Hyeok Hwang, Sukki Cho, and Je-Yoel Cho.
%
% See the accompanying file LICENSE.txt for licensing details.


tmp = regexp(filename, '(\.[^\.]*)$', 'tokens');
if isempty(tmp) || isempty(tmp{1})
  error('Please specify output file with extension .png, .jpg, .eps, .pdf, or .tif'); ...
end

ext = tmp{1}{1}(2:end);
if strcmpi(ext,'jpeg') || strcmpi(ext,'jpg')
  dev = 'jpeg';
  res = 600;
elseif strcmpi(ext,'eps')
  dev = 'epsc';
  res = 600;
elseif strcmpi(ext,'tif') || strcmpi(ext,'tiff')
  dev = 'tiff';
  res = 600;
elseif strcmpi(ext,'png')
  dev = 'png';
  res = 600;
elseif strcmpi(ext,'pdf')
  dev = 'pdf';
  res = 1200;
else
  error('Unknown output format: please specify .png, .jpg, .eps, .pdf, or .tif');
end

end
