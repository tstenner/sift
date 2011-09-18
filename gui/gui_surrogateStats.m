function varargout = gui_surrogateStats(varargin)
%
% GUI_SURROGATESTATS M-file for gui_surrogateStats.fig
%      GUI_SURROGATESTATS, by itself, creates a new GUI_SURROGATESTATS or raises the existing
%      singleton*.
%
%      H = GUI_SURROGATESTATS returns the handle to a new GUI_SURROGATESTATS or the handle to
%      the existing singleton*.
%
%      GUI_SURROGATESTATS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SURROGATESTATS.M with the given input arguments.
%
%      GUI_SURROGATESTATS('Property','Value',...) creates a new GUI_SURROGATESTATS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_surrogateStats_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_surrogateStats_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_surrogateStats

% Last Modified by GUIDE v2.5 16-Sep-2011 14:37:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_surrogateStats_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_surrogateStats_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_surrogateStats is made visible.
function gui_surrogateStats_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_surrogateStats (see VARARGIN)

set(hObject,'name','Compute Surrogate Statistics');

handles.output = hObject;

% set default termination behavior
handles.ExitButtonClicked = 'Cancel';

% extract some data from command-line input
if isempty(varargin)
    error('You must pass PConn to gui_surrogateStats');
end

% Extract input parameters/data and store
handles.ud.PConn  = varargin{1};  
varargin(1) = [];

% set default EEGLAB background and text colors
%-----------------------------------------------
try, icadefs;
catch,
	GUIBACKCOLOR        =   [.8 .8 .8];     
	GUIPOPBUTTONCOLOR   =   [.8 .8 .8];    
	GUITEXTCOLOR        =   [0 0 0];
end;

allhandlers = hObject;

hh = findobj(allhandlers,'style', 'text');
%set(hh, 'BackgroundColor', get(hObject, 'color'), 'horizontalalignment', 'left');
set(hh, 'Backgroundcolor', GUIBACKCOLOR);
set(hh, 'foregroundcolor', GUITEXTCOLOR);
set(hObject, 'color',GUIBACKCOLOR );
% set(hh, 'horizontalalignment', g.horizontalalignment);

hh = findobj(allhandlers, 'style', 'edit');
set(hh, 'BackgroundColor', [1 1 1]); %, 'horizontalalignment', 'right');

hh =findobj(allhandlers, 'parent', hObject, 'style', 'pushbutton');
if ~strcmpi(computer, 'MAC') && ~strcmpi(computer, 'MACI') % this puts the wrong background on macs
    set(hh, 'backgroundcolor', GUIPOPBUTTONCOLOR);
    set(hh, 'foregroundcolor', GUITEXTCOLOR);
end;
hh =findobj(allhandlers, 'parent', hObject, 'style', 'popupmenu');
set(hh, 'backgroundcolor', GUIPOPBUTTONCOLOR);
set(hh, 'foregroundcolor', GUITEXTCOLOR);
hh =findobj(allhandlers, 'parent', hObject, 'style', 'checkbox');
set(hh, 'backgroundcolor', GUIBACKCOLOR);
set(hh, 'foregroundcolor', GUITEXTCOLOR);
hh =findobj(allhandlers, 'parent', hObject, 'style', 'listbox');
set(hh, 'backgroundcolor', GUIPOPBUTTONCOLOR);
set(hh, 'foregroundcolor', GUITEXTCOLOR);
hh =findobj(allhandlers, 'parent', hObject, 'style', 'radio');
set(hh, 'foregroundcolor', GUITEXTCOLOR);
set(hh, 'backgroundcolor', GUIPOPBUTTONCOLOR);
set(hObject, 'visible', 'on');

set(handles.pnlPropertyGrid,'backgroundcolor', GUIBACKCOLOR);
set(handles.pnlPropertyGrid,'foregroundcolor', GUITEXTCOLOR);
%-----------------------------------------------

drawnow

% render the PropertyGrid in the correct panel
handles.PropertyGridHandle = arg_guipanel( ...
                 handles.pnlPropertyGrid, ...
                'Function',@stat_surrogateStats, ...
                'params',{'PConn',handles.ud.PConn, varargin{:}});

% Update handles structure
guidata(hObject, handles);

% Wait for user to click OK, Cancel or close figure
uiwait(handles.gui_PrepData);


% --- Outputs from this function are returned to the command line.
function varargout = gui_surrogateStats_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles)
    % user closed the figure
    varargout = {[] hObject};
elseif strcmpi(handles.ExitButtonClicked,'OK')
    % user clicked OK
    % get PropertySpecification
    varargout = {handles.PropertyGridHandle handles.output};
else
    % user clicked cancel
    varargout = {[] handles.output};
end

try, close(hObject);
catch; end


function cmdCancel_Callback(hObject, eventdata, handles)

handles.ExitButtonClicked = 'Cancel';
guidata(hObject,handles);
uiresume(handles.gui_PrepData)


function cmdOK_Callback(hObject, eventdata, handles)

handles.ExitButtonClicked ='OK';
guidata(hObject,handles);
uiresume(handles.gui_PrepData);

function cmdHelp_Callback(hObject, eventdata, handles)
warndlg2('Coming soon!'); % use pophelp


function gui_PrepData_ResizeFcn(hObject, eventdata, handles)
