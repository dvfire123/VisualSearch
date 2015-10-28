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

% Last Modified by GUIDE v2.5 27-Oct-2015 11:06:23

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
global latestData dataFolder;

[folder, ~, ~] = fileparts(mfilename('fullpath'));
if isdeployed
    folder = pwd;
end
userFolder = 'UserData';
dataFolder = fullfile(folder, userFolder);

latestDataFile = 'latest.txt';
if ~exist(dataFolder, 'dir')
   mkdir(dataFolder); 
end

latestData = fullfile(dataFolder, latestDataFile);
if ~exist(latestData, 'file')
   fid = fopen(latestData, 'wt+');
   fclose(fid);
end

fid = fopen(latestData, 'r');
latestFile = fgetl(fid);
fclose(fid);

if ischar(latestFile)
    %There is latest file path
    %Load it
    A = loadUserData(latestFile);
    
    if ~isempty(A)
        loadInputs(handles, A);
    end
end

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

%First save the data
saveDataToFile(hObject, eventdata, handles);

%Then proceed
figure(drawingHub);


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
saveDataToFile(hObject, eventdata, handles);
figure(saveDataConfirm);


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, pathName] = uigetfile('*.vsdf', 'Select your data input (.vsdf) file');
if fileName == 0
    return;
end

file = fullfile(pathName, fileName);

A = loadUserData(file);
loadInputs(handles, A);
updateLatestFile(file);


%%-----Helpers-----%%
function readInputs(handles)
global inputs;

fn = get(handles.fn, 'string');
ln = get(handles.ln, 'string');
p = get(handles.p, 'string');
nCopies = get(handles.nCopies, 'string');
dt = get(handles.dt, 'string');
numTrials = get(handles.numTrials, 'string');
hSquish = get(handles.hs, 'string');
wSquish = get(handles.ws, 'string');

inputs{1} = fn;
inputs{2} = ln;
inputs{3} = p;
inputs{4} = nCopies;
inputs{5} = dt;
inputs{6} = numTrials;
inputs{7} = hSquish;
inputs{8} = wSquish;

setappdata(gcf, 'inputs', inputs);

function loadInputs(handles, inputs)
set(handles.fn, 'string', inputs{1});
set(handles.ln, 'string', inputs{2});
set(handles.p, 'string', inputs{3});
set(handles.nCopies, 'string', inputs{4});
set(handles.dt, 'string', inputs{5});
set(handles.numTrials, 'string', inputs{6});
set(handles.hs, 'string', inputs{7});
set(handles.ws, 'string', inputs{8});

function updateLatestFile(file)
global latestData;
fid = fopen(latestData, 'wt+');
fprintf(fid, '%s', file);
fclose(fid);

function saveDataToFile(hObject, eventdata, handles)
global inputs dataFolder;
readInputs(handles);
[fileName, file]= saveInputsToFile(inputs, dataFolder);
setappdata(gcbf, 'dataFileName', fileName);
updateLatestFile(file);

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
