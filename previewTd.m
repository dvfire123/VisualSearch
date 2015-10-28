function varargout = previewTd(varargin)
% PREVIEWTD MATLAB code for previewTd.fig
%      PREVIEWTD, by itself, creates a new PREVIEWTD or raises the existing
%      singleton*.
%
%      H = PREVIEWTD returns the handle to a new PREVIEWTD or the handle to
%      the existing singleton*.
%
%      PREVIEWTD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREVIEWTD.M with the given input arguments.
%
%      PREVIEWTD('Property','Value',...) creates a new PREVIEWTD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before previewTd_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to previewTd_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help previewTd

% Last Modified by GUIDE v2.5 22-Oct-2015 14:14:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @previewTd_OpeningFcn, ...
                   'gui_OutputFcn',  @previewTd_OutputFcn, ...
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


% --- Executes just before previewTd is made visible.
function previewTd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to previewTd (see VARARGIN)
global targCVec disCVec targCell disCell inputs;
global sHeight sWidth minDist bgColour dim nCopies p;
dim = 20;
sHeight = 400;
sWidth = 600;
bgColour = [1 1 1]; %white
minDist = ceil(dim/4);

inputs = getappdata(0, 'inputs');
targCell = getappdata(0, 'targCell');    %could be more than one target
disCell = getappdata(0, 'disCell');      %could be more than one distractor
targCVec = getappdata(0, 'tcCell');
disCVec = getappdata(0, 'dcCell');

nCopies = str2double(inputs{4});
p = 1;  %So both of the targets will show in the preview

%Display a stimulus
createStimulus(sHeight, sWidth, dim, targCell, disCell,...
    targCVec, disCVec, nCopies, p, minDist, bgColour, handles.previewStim, 0);

% Choose default command line output for previewTd
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes previewTd wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = previewTd_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in showButton.
function showButton_Callback(hObject, eventdata, handles)
% hObject    handle to showButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global targCVec disCVec targCell disCell;
global sHeight sWidth minDist bgColour dim nCopies p;
createStimulus(sHeight, sWidth, dim, targCell, disCell,...
    targCVec, disCVec, nCopies, p, minDist, bgColour, handles.previewStim, 0);

% --- Executes on button press in startoverButton.
function startoverButton_Callback(hObject, eventdata, handles)
% hObject    handle to startoverButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
another = getappdata(0, 'another');
if ~isempty(another)
    rmappdata(0, 'another');
end
close;
figure(drawTd);
