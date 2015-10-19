function varargout = drawTd(varargin)
% DRAWTD MATLAB code for drawTd.fig
%      DRAWTD, by itself, creates a new DRAWTD or raises the existing
%      singleton*.
%
%      H = DRAWTD returns the handle to a new DRAWTD or the handle to
%      the existing singleton*.
%
%      DRAWTD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWTD.M with the given input arguments.
%
%      DRAWTD('Property','Value',...) creates a new DRAWTD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drawTd_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drawTd_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drawTd

% Last Modified by GUIDE v2.5 19-Oct-2015 12:00:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drawTd_OpeningFcn, ...
                   'gui_OutputFcn',  @drawTd_OutputFcn, ...
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


% --- Executes just before drawTd is made visible.
function drawTd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawTd (see VARARGIN)
global targCVec disCVec targCell disCell;
global dim;
dim = 20;
targCVec = {[0, 0, 0]};   %black by default
disCVec = targCVec;
set(handles.colourButton, 'UserData', targCVec{1});

xTick = linspace(0, 1, dim+1);
yTick = xTick;

set(handles.td, 'XTick', xTick);
set(handles.td, 'YTick', yTick);

emptyTarg = ones(dim, dim);
emptyDistractor = ones(dim, dim);
targCell = {emptyTarg};
disCell = {emptyDistractor};
setappdata(0, 'targCell', targCell);    %could be more than one target
setappdata(0, 'disCell', disCell);      %could be more than one distractor
setappdata(0, 'tcCell', targCVec);
setappdata(0, 'dcCell', disCVec);

%Store the current drawing
set(handles.td, 'UserData', targCell{1});

% Choose default command line output for drawTd
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drawTd wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drawTd_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function td_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to td (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dim;
targ = get(hObject, 'UserData');
targColour = get(handles.colourButton, 'UserData');

hold on;
delete(get(hObject, 'Children'));
coordinates = get(hObject, 'CurrentPoint'); 
coordinates = coordinates(1, 1:2);

pix = getPix(coordinates, dim);
xpix = pix(1);
ypix = pix(2);

if targ(xpix, ypix) == 0
    targ(xpix, ypix) = 1;
else
    targ(xpix, ypix) = 0;
end

imHandle = displayTd(targ, targColour, hObject);
set(imHandle, 'HitTest', 'off');
saveTarget(handles, targ, targColour, 1);

% --- Executes on button press in colourButton.
function colourButton_Callback(hObject, eventdata, handles)
% hObject    handle to colourButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor;
set(hObject, 'UserData', c);
axes(handles.td);
targ = get(handles.td, 'UserData');

hold on;
delete(get(handles.td, 'Children'));
imHandle = displayTd(targ, c, handles.td);
set(imHandle, 'HitTest', 'off');


% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dim;
axes(handles.td);
targ = ones(dim, dim);
set(handles.td, 'UserData', targ);
delete(get(handles.td, 'Children'));


%Helper Functions
%Save the relevant target data
function saveTarget(handles, targ, targColour, targNum)
global targCVec targCell;
set(handles.td, 'UserData', targ);
targCVec{targNum} = targColour;
targCell{targNum} = targ;
setappdata(0, 'targCell', targCell);
setappdata(0, 'tcCell', targCVec);

%Save the relevant distractor data
function saveDistractor(handles, dis, disColour, disNum)
global disCVec disCell;
set(handles.td, 'UserData', dis);
disCVec{disNum} = disColour;
disCell{disNum} = dis;
setappdata(0, 'targCell', disCell);
setappdata(0, 'tcCell', disCVec);

