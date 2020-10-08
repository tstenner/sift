function [CC,NN] = covm(X, Y)
% COVM generates covariance matrix
% X and Y can contain missing values encoded with NaN.
% NaN's are skipped, NaN do not result in a NaN output.
% The output gives NaN only if there are insufficient input data
%
% COVM(X,Y);
%      calculates the crosscorrelation between X and Y
%
% 	C = X'*X; or X'*Y correlation matrix
% see also: DECOVM, XCOVF

%	$Id: covm.m 5599 2009-03-10 12:52:20Z schloegl $
%	Copyright (C) 2000-2005,2009 by Alois Schloegl <a.schloegl@ieee.org>
%       This function is part of the NaN-toolbox
%       http://hci.tugraz.at/~schloegl/matlab/NaN/

%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; If not, see <http://www.gnu.org/licenses/>.

Xnan = isnan(X);
X(Xnan) = 0; % skip NaNs
[r1, c1] = size(X);

if nargin() < 2 % Y=X
    NN = (~Xnan)'*(~Xnan);
    CC = X'*X;
else
    [r2, c2] = size(Y);
    if r1 ~= r2
        error('X and Y must have the same number of observations (rows).');
    end
    if (c1 > r1) || (c2 > r2)
        warning('Covariance is ill-defined, because of too few observations (rows)');
    end
    
    Ynan = isnan(Y);
    Y(Ynan) = 0; % skip NaNs
    
    NN = (~Xnan)'*(~Ynan);
    CC = X'*Y;
end