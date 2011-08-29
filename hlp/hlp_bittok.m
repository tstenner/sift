function idx = hlp_bittok(x,bit)
% segment binary vector x and return start-stop indices of sequences of
% value=bit. 'bit' can 0 or 1
% 
% Input: 
%   X:      a binary vector
%   bit:    0 or 1 (the bit-sequence to scan for)
% Output:   
%   idx:    matrix where each row contains [start end] indices of the
%           sequence of bits
%
% Author: Tim Mullen (C) 2011, SCCN/INC/UCSD

if ~(bit==0 || bit==1)
    error('bit must be either 0 or 1');
end

if ~all(x==1 | x==0)
    error('x must be a binary sequence');
end
   
x = x(:)';

x = num2str(x);
x(isspace(x))=[];

[startidx endidx] = regexp(x,sprintf('[%d]*%d',bit),'start','end');

if isempty(startidx)
    idx = [];
else
    idx = [startidx; endidx]';
end
