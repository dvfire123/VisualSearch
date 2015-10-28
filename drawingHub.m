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

% Last Modified by GUIDE v2.5 28-Oct-2015 14:40:24

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

%Helper to initialize all the draws
function initBoxes(handles)
global inputs;

inputs = getappdata(0, 'inputs');

global dim NT ND;
global nCopies;
nCopies = inputs{4};

%Note: Please do not change these parameters
dim = 20;
NT = 2;
ND = 6; 
%End Note

loadAllDrawings(handles);


% --- Executes just before drawingHub is made visible.
function drawingHub_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawingHub (see VARARGIN)
global latestDFolder latestData dataFolder inputs;
global targCVec disCVec targCell disCell;
global dim NT ND;
global nCopies;

setappdata(0, 'drawing', 0);

[folder, ~, ~] = fileparts(mfilename('fullpath'));
if isdeployed
    folder = pwd;
end

%The folder to store the latest drawings
latestDFolder = fullfile(folder, 'SysFiles');
if ~exist(latestDFolder, 'dir')
   mkdir(latestDFolder); 
end

%The folder to save to as the latest test params used
dataFolder = fullfile(folder, 'UserData');
if ~exist(dataFolder, 'dir')
   mkdir(dataFolder); 
end

latestDataFile = 'latest.txt';
latestData = fullfile(dataFolder, latestDataFile);
if ~exist(latestData, 'file')
   fid = fopen(latestData, 'wt+');
   fclose(fid);
end

%Load the user inputs
inputs = getappdata(0, 'inputs');
loadInputs(handles, inputs);

%Load the drawings
initBoxes(handles);

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

%%-----Helpers-----%%
%%--Input Readers--%%
function readInputs(handles)
global inputs;

p = get(handles.p, 'string');
nCopies = get(handles.nCopies, 'string');
dt = get(handles.dt, 'string');
numTrials = get(handles.numTrials, 'string');
hSquish = get(handles.hs, 'string');
wSquish = get(handles.ws, 'string');

inputs{3} = p;
inputs{4} = nCopies;
inputs{5} = dt;
inputs{6} = numTrials;
inputs{7} = hSquish;
inputs{8} = wSquish;

setappdata(0, 'inputs', inputs);

function loadInputs(handles, inputs)
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
setappdata(0, 'dataFileName', fileName);
updateLatestFile(file);


%%--Drawing Helpers--%%
function loadDrawing(handles, isTarg, num)
%Loads the latest drawing to the appropriate axes
global latestDFolder dim;
if isTarg == 1
    fileName = sprintf('t%s.pic', num2str(num));
    field = sprintf('targ%s', num2str(num));
else
    fileName = sprintf('d%s.pic', num2str(num));
    field = sprintf('dis%s', num2str(num));
end

file = fullfile(latestDFolder, fileName);
drawHandle = extractfield(handles, field);

if ~exist(file, 'file')
    %Create the file
    fid = fopen(file, 'wt+');
    fclose(fid);
    
    %Store empty targ to the appropriate drawings
    drawing = ones(dim, dim);
    c = [0, 0, 0];  %black by default
    saveDrawing(drawing, c, isTarg, num);
    return;
end

%The file exists!  Read it
%Assuming either the targ/dis is already saved or -1 for blank targ/dis
fid = fopen(file, 'r');
B = fscanf(fid, '%f');
if numel(B) == 0 || B(1) == -1
    %Indicates a blank drawing, so load nothing and delete the
    %corresponding box
    fclose(fid);
    delete(get(drawHandle, 'Children'));
    
    %Store empty targ to the appropriate drawings
    drawing = ones(dim, dim);
    c = [0, 0, 0];  %black by default
    saveDrawing(drawing, c, isTarg, num);
    return;
end

drawing = ones(dim, dim);
Bindx = 0;

for i = 1:dim
    for j = 1:dim
      Bindx = Bindx + 1;
      drawing(i, j) = B(Bindx);
    end
end

colour = B(Bindx+1:Bindx+3);
saveDrawing(drawing, colour, isTarg, num);

%Plot the drawing
drawing = flipdim(drawing, 1);
imHandle = displayTd(drawing, colour, drawHandle);
set(imHandle, 'HitTest', 'off');

function loadAllDrawings(handles)
global NT ND;

%Load all targets, if it exists
for i = 1:NT
    loadDrawing(handles, 1, i);
end

%Load all distractors, if it exists
for i = 1:ND
    loadDrawing(handles, 0, i);
end


%Save the relevant target data
function saveTarget(targ, targColour, targNum)
global targCVec targCell;
targCVec{targNum} = targColour;
targCell{targNum} = targ;
setappdata(0, 'targCell', targCell);
setappdata(0, 'tcCell', targCVec);

%Save the relevant distractor data
function saveDistractor(dis, disColour, disNum)
global disCVec disCell;
disCVec{disNum} = disColour;
disCell{disNum} = dis;
setappdata(0, 'disCell', disCell);
setappdata(0, 'dcCell', disCVec);

%Save the drawing data based on targ vs distractor
function saveDrawing(drawing, colour, isTarg, num)
if isTarg == 1
    saveTarget(drawing, colour, num);
else
    saveDistractor(drawing, colour, num);
end
%%--End Helpers--%%

%%--Even More Helpers--%%
function saveDrawingToFile(isTarg, num)
global latestDFolder targCVec disCVec targCell disCell dim;
if isTarg == 1
    fileName = sprintf('t%s.pic', num2str(num));
    drawing = targCell{num};
    c = targCVec{num};
else
    fileName = sprintf('d%s.pic', num2str(num));
    drawing = disCell{num};
    c = disCVec{num};
end

file = fullfile(latestDFolder, fileName);
fid = fopen(file, 'wt+');
if isZeroMatrix(drawing - ones(dim, dim)) == 1
    %blank drawing
    fprintf(fid, '%d', -1);
else
    %The drawing is stored as a column vector of 0 and 1's
    for i = 1:dim
       %10 is the height of the targ
       for j = 1:dim
           %10 is the width of the targ
          fprintf(fid, '%d\n', drawing(i, j)); 
       end
    end

    for i = 1:3
       fprintf(fid, '%f\n', c(i)); 
    end 
end
fclose(fid);

function saveAllDrawingsToFile()
global NT ND;
for i = 1:NT
    saveDrawingToFile(1, i);
end

for i = 1:ND
    saveDrawingToFile(0, i);
end
%%--End Even More Helpers--%%

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
saveAllDrawingsToFile();
figure(previewTd);


% --- Executes on button press in beginButton.
function beginButton_Callback(hObject, eventdata, handles)
% hObject    handle to beginButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveDataToFile(hObject, eventdata, handles);
saveAllDrawingsToFile();


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
        clearAllDrawings(handles);
    case 'No'
        return;
end

function clearAllDrawings(handles)
global dim NT ND;

drawing = ones(dim, dim);
c = [0, 0, 0];

for i = 1:NT
    saveDrawing(drawing, c, 1, i);
end

for i = 1:ND
    saveDrawing(drawing, c, 0, i);
end

saveAllDrawingsToFile();
loadAllDrawings(handles);

%Helper regarding drawing targets
function spawnDrawBox(isTarg, num)
%Opens the appropriate drawbox
%only 1 draw box open at a time!
isDrawing = getappdata(0, 'drawing');

if isDrawing == 0
    setappdata(0, 'drawing', 1);
    setappdata(0, 'isTarg', isTarg);
    setappdata(0, 'num', num);
    figure(drawTd);
end

% --- Executes on mouse press over axes background.
function targ1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to targ1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(1, 1);


% --- Executes on mouse press over axes background.
function targ2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to targ2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(1, 2);


% --- Executes on mouse press over axes background.
function dis1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(0, 1);


% --- Executes on mouse press over axes background.
function dis2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dis2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(0, 2);


% --- Executes on mouse press over axes background.
function dis3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dis3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(0, 3);


% --- Executes on mouse press over axes background.
function dis4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dis4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(0, 4);


% --- Executes on mouse press over axes background.
function dis5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dis5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(0, 5);


% --- Executes on mouse press over axes background.
function dis6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dis6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spawnDrawBox(0, 6);
