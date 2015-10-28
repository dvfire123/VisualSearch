function varargout = drawingHub(varargin)
% DRAWINGHUB MATLAB code for drawingHub.fig
%      DRAWINGHUB, by itself, creates a new DRAWINGHUB or raises the existing
%      singleton*.
%
%      H = DRAWINGHUB returns the handle to a new DRAWINGHUB or the handle to
%      the existing singleton*.
%
%      DRAWINGHUB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWINGHUB.M with the given input arguments.
%
%      DRAWINGHUB('Property','Value',...) creates a new DRAWINGHUB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drawingHub_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drawingHub_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drawingHub

% Last Modified by GUIDE v2.5 27-Oct-2015 22:33:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drawingHub_OpeningFcn, ...
                   'gui_OutputFcn',  @drawingHub_OutputFcn, ...
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


% --- Executes just before drawingHub is made visible.
function drawingHub_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawingHub (see VARARGIN)

% Choose default command line output for drawingHub
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drawingHub wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drawingHub_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function p_Callback(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p as text
%        str2double(get(hObject,'String')) returns contents of p as a double
p = str2double(get(handles.p, 'string'));
p = max(0, min(p, 1));
set(handles.p, 'string', num2str(p));


% --- Executes during object creation, after setting all properties.
function p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dt_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double
dt = str2double(get(handles.dt, 'string'));
dt = max(0, dt);
set(handles.dt, 'string', num2str(dt));


% --- Executes during object creation, after setting all properties.
function dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numTrials_Callback(hObject, eventdata, handles)
% hObject    handle to numTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numTrials as text
%        str2double(get(hObject,'String')) returns contents of numTrials as a double
numTrials = str2double(get(handles.numTrials, 'string'));
numTrials = max(1, numTrials);
set(handles.numTrials, 'string', num2str(numTrials));


% --- Executes during object creation, after setting all properties.
function numTrials_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numTrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nCopies_Callback(hObject, eventdata, handles)
% hObject    handle to nCopies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nCopies as text
%        str2double(get(hObject,'String')) returns contents of nCopies as a double
nCopies = str2double(get(handles.nCopies, 'string'));
nCopies = max(1, nCopies);
set(handles.nCopies, 'string', num2str(nCopies));


% --- Executes during object creation, after setting all properties.
function nCopies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nCopies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ws_Callback(hObject, eventdata, handles)
% hObject    handle to ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ws as text
%        str2double(get(hObject,'String')) returns contents of ws as a double
ws = str2double(get(handles.ws, 'string'));
ws = max(10, min(ws, 100));
set(handles.ws, 'string', num2str(ws));


% --- Executes during object creation, after setting all properties.
function ws_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hs_Callback(hObject, eventdata, handles)
% hObject    handle to hs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hs as text
%        str2double(get(hObject,'String')) returns contents of hs as a double
hs = str2double(get(handles.hs, 'string'));
hs = max(10, min(hs, 100));
set(handles.hs, 'string', num2str(hs));


% --- Executes during object creation, after setting all properties.
function hs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previewButton.
function previewButton_Callback(hObject, eventdata, handles)
% hObject    handle to previewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in beginButton.
function beginButton_Callback(hObject, eventdata, handles)
% hObject    handle to beginButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Construct a questdlg with three options
choice = questdlg('Are you sure you want to clear all drawings?', ...
	'Clear All Drawings Confirmation', ...
	'Yes', ...
    'No', ...
    'No');
% Handle response
switch choice
    case 'Yes'
        disp('Yes Selected!');
    case 'No'
        disp('No Selected!');
end