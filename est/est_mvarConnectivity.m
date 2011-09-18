
function [Conn params] = est_mvarConnectivity(EEG,MODEL,varargin)
%
% Calculate spectral, coherence, and connectivity measures from a fitted
% VAR model. See [1] for additional details on VAR model fitting and
% connectivity measures implemented here.
%
% Inputs:
%
%   EEG:        EEGLAB data structure
%   MODEL:      VAR model returned by est_fitMVAR or other SIFT model-fitting
%               routine
%   connmethods: A cell array of connectivity method names compatible with
%               the names in est_mvtransfer().
%               
%
% Optional:
%
%   <Name,Value> pairs containing model fitting parameters. See
%   est_fitMVAR(). Generally, these should be left unspecified and inferred
%   from MODEL structure.
%
% Output:
%
%   Conn
%       .<measure>        [numvar x numvar x numfreq x numtime] connectivity
%                         matrix
%       .freqs            vector of frequencies estimated
%       .erWinCenterTimes vector of window centers (seconds) relative to
%                         event onset
%   params                parameters used
%
% See Also: pop_est_mvarConnectivity(), pop_est_fitMVAR(), est_mvtransfer()
%
% References:
%
% [1] Mullen T (2010) The Source Information Flow Toolbox (SIFT):
%     Theoretical Handbook and User Manual. Chapter 4
%     Available at: http://www.sccn.ucsd.edu/wiki/Sift
%
% Author: Tim Mullen 2010, SCCN/INC, UCSD.
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

var = hlp_mergeVarargin(varargin{:});
g = finputcheck(var, hlp_getDefaultArglist('est'), 'est_mvarConnectivity','ignore','quiet');
if ischar(g), error(g); end
if ~isfield(g,'connmethods') || isempty(g.connmethods), error('you must provide a list of connectivity methods!'); end
g.connmethods = unique(g.connmethods);
if nargout > 1, params = g; end
g.winstep   = MODEL.winstep;
g.winlen    = MODEL.winlen;
params = g;
if ~isfield(g,'freqs') || isempty(g.freqs), g.freqs = 1:floor(EEG.srate/2); end
Conn = [];

numWins = length(MODEL.AR);
nchs    = EEG.CAT.nbchan;


if g.verb
    % inform user of total amount of memory (megabytes) required
    bytesReq = 4*length(g.connmethods)*numWins*length(g.freqs)*nchs^2;
    
    ret = questdlg2(sprintf('This operation will require %4.4f MB of memory (per condition). \nMake sure you have enough memory available. \nDo you want to continue?',bytesReq/(1024^2)), 'Connectivity Estimation','OK','Cancel','OK');
    if strcmpi(ret,'cancel');
        return;
    end
end

if g.verb
    h1=waitbar(0,sprintf('estimating connectivity %s...', ...
        fastif(isempty(EEG.condition),'',['for ' EEG.condition])));
end

for t=1:numWins
    
    if isempty(MODEL.AR{t})
        continue;
    end
    
    % extract noise covariance matrix
    if size(MODEL.PE{t},2)>nchs
        MODEL.PE{t} = MODEL.PE{t}(:,nchs*MODEL.morder+1:nchs*(MODEL.morder+1));
    end
    
    % estimate connectivity for this window
    ConnTmp = est_mvtransfer(MODEL.AR{t},MODEL.PE{t},g.freqs,EEG.srate,g.connmethods);
    
    for method=g.connmethods
        if t==1
            % on first run, preallocate memory for connectivity matrices
            try
                Conn.(method{1}) = zeros([size(ConnTmp.(method{1})) numWins],'single');
            catch
                errordlg2('Insuficient memory available to allocate variables');
                return;
            end
        end
        
        Conn.(method{1})(:,:,:,t) = ConnTmp.(method{1});
    end
    
    if g.verb
        waitbar(t/numWins,h1,sprintf('estimating connectivity %s (%d/%d)...', ...
            fastif(isempty(EEG.condition),'',['for ' EEG.condition]),t,numWins));
    end
end


if g.verb
    waitbar(t/numWins,h1,sprintf('Creating final connectivity object %s...', ...
        fastif(isempty(EEG.condition),'',['for ' EEG.condition])));
end

if ~strcmpi(MODEL.algorithm,'kalman')
    Conn.winCenterTimes = MODEL.winStartTimes+MODEL.winlen/2;
else
    Conn.winCenterTimes = MODEL.winStartTimes;
end

Conn.erWinCenterTimes = Conn.winCenterTimes-abs(EEG.xmin);
Conn.freqs = g.freqs;

if g.verb, close(h1); end
