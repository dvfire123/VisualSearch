function varargout = beginTest(varargin)
% BEGINTEST MATLAB code for beginTest.fig
%      BEGINTEST, by itself, creates a new BEGINTEST or raises the existing
%      singleton*.
%
%      H = BEGINTEST returns the handle to a new BEGINTEST or the handle to
%      the existing singleton*.
%
%      BEGINTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEGINTEST.M with the given input arguments.
%
%      BEGINTEST('Property','Value',...) creates a new BEGINTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beginTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beginTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beginTest

% Last Modified by GUIDE v2.5 20-Oct-2015 18:30:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beginTest_OpeningFcn, ...
                   'gui_OutputFcn',  @beginTest_OutputFcn, ...
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


% --- Executes just before beginTest is made visible.
function beginTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beginTest (see VARARGIN)
readInputs(handles);

% Choose default command line output for beginTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beginTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beginTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fn_Callback(hObject, eventdata, handles)
% hObject    handle to fn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fn as text
%        str2double(get(hObject,'String')) returns contents of fn as a double


% --- Executes during object creation, after setting all properties.
function fn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ln_Callback(hObject, eventdata, handles)
% hObject    handle to ln (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ln as text
%        str2double(get(hObject,'String')) returns contents of ln as a double


% --- Executes during object creation, after setting all properties.
function ln_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ln (see GCBO)
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
MAX_COPIES = 10;
nCopies = str2double(get(handles.nCopies, 'string'));
nCopies = max(0, min(nCopies, MAX_COPIES));
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



function p_Callback(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p as text
%        str2double(get(hObject,'String')) returns contents of p as a double
p = str2double(get(handles.nCopies, 'string'));
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



function wt_Callback(hObject, eventdata, handles)
% hObject    handle to wt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wt as text
%        str2double(get(hObject,'String')) returns contents of wt as a double


% --- Executes during object creation, after setting all properties.
function wt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wt (see GCBO)
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


% --- Executes on button press in creditsButton.
function creditsButton_Callback(hObject, eventdata, handles)
% hObject    handle to creditsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(cBox);


% --- Executes on button press in goButton.
function goButton_Callback(hObject, eventdata, handles)
% hObject    handle to goButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quitButton.
function quitButton_Callback(hObject, eventdata, handles)
% hObject    handle to quitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%-----Helpers-----%%
function readInputs(handles)
global inputs;

fn = get(handles.fn, 'string');
ln = get(handles.ln, 'string');
p = str2double(get(handles.p, 'string'));
nCopies = str2double(get(handles.nCopies, 'string'));
dt = str2double(get(handles.dt, 'string'));
wt = str2double(get(handles.wt, 'string'));
numTrials = str2double(get(handles.numTrials, 'string'));

inputs{1} = fn;
inputs{2} = ln;
inputs{3} = p;
inputs{4} = nCopies;
inputs{5} = dt;
inputs{6} = wt;
inputs{7} = numTrials;

setappdata(gcf, 'inputs', inputs);
