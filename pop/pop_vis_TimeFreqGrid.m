
function [cfg handles] = pop_vis_TimeFreqGrid(ALLEEG,varargin)
%
% Create a Time-Frequency Grid from a connectivity matrix. For details on
% the Interactive Time-Frequency Grid see [1]. 
% This function generates an interactive GUI. Default GUI options can be
% pre-specified as <name, value> pairs as listed in vis_TimeFreqGrid().
% Alternately, an arg configuration structure can be provided in lieu of
% name, value pairs (see Example below).
%
% Inputs:
% 
%       ALLEEG:     Array of 1 or 2 EEGLAB datasets. If 2 sets, this function
%                   plots difference (and Conn must also be 1x2 array of
%                   structs)
%       Conn:       SIFT Connectivity Structure
%
% Optional:
%
%       <Name, Value> pairs as defined in vis_TimeFreqGrid()
%
% Outputs:
%
%       cfg:                          Argument specification struct. Can be
%                                     supplied in lieu of <name, value>
%                                     argument pairs to exactly reconstruct
%                                     TF-grid.
%       figureHandles:                Handles to figures.
%
% Example:  >> cfg = pop_vis_TimeFreqGrid(ALLEEG);    % now select some options from GUI and click "OK"
%           >> vis_TimeFreqGrid(ALLEEG,cfg);          % TF-grid will now be recreated from command-line 
%                                                     % exactly as specified in GUI 
%
% See Also: vis_TimeFreqGrid() 
%
% References: 
% 
% [1] Mullen T (2010) The Source Information Flow Toolbox (SIFT):
%   Theoretical Handbook and User Manual. Chapter 6.
%   Available at: http://www.sccn.ucsd.edu/wiki/Sift
%
% Author: Tim Mullen, 2010, SCCN/INC, UCSD. 
% Email:  tim@sccn.ucsd.edu

% This function is part of the Source Information Flow Toolbox (SIFT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA



handles = [];


% if isunix
%     SLASH = '/';
% else
%     SLASH = '\';
% end

% [fnpath fnname] = fileparts(which('pop_vis_TimeFreqGrid'));
% if exist('tfgrid.cfg','file')
%     load('tfgrid.cfg','-mat');
% else
%     cfg = [];
% end
% 
% varargin = [cfg varargin];

if length(varargin) == 1 && isempty(varargin{1})
    varargin = {};
end

% varargin = [cfg varargin];

% check the dataset
res = hlp_checkeegset(ALLEEG,{'conn'});
if ~isempty(res)
    error('SIFT:causalBrainMovie',res{1});
end

% extract the Connectivity structures
for cnd=1:length(ALLEEG);
    Conn(cnd) = ALLEEG(cnd).CAT.Conn;
    ALLEEG(cnd).CAT.Conn = [];
end

% render the GUI
[PGh figh] = gui_TimeFreqGrid(ALLEEG,Conn,varargin{:});

if isempty(PGh)
    % user chose to cancel
    cfg = [];
    return;
end

% get the specification of the PropertyGrid
ps = PGh.GetPropertySpecification;
cfg = arg_tovals(ps,false);

% save([fnpath SLASH '@configs' SLASH 'tfgrid.cfg'],'cfg');

% execute the low-level function
handles = vis_TimeFreqGrid('ALLEEG',ALLEEG,'Conn',Conn,cfg);



