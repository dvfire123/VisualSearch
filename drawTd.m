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

% Last Modified by GUIDE v2.5 20-Oct-2015 20:05:46

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

function initDrawBox(handles)
inputs = getappdata(beginTest, 'inputs');
set(beginTest, 'visible', 'off');

global targCVec disCVec targCell disCell isTarg num;
global dim NT ND;
global nCopies

dim = 20;
targCVec = {[0, 0, 0]};   %black by default
disCVec = targCVec;
set(handles.colourButton, 'UserData', targCVec{1});

isTarg = 1;
setappdata(0, 'isTarg', isTarg);

num = 1;
NT = 2;
ND = 10;

nCopies = inputs{4};

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
set(handles.td, 'UserData', targCell{num});

% --- Executes just before drawTd is made visible.
function drawTd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawTd (see VARARGIN)
global num dim NT isTarg;
another = getappdata(0, 'another');

if isempty(another)
    if ~isempty(get(handles.td, 'Children'))
        delete(get(handles.td, 'Children'));
    end
    initDrawBox(handles);
elseif another == 1
    axes(handles.td);
    drawing = ones(dim, dim);
    set(handles.td, 'UserData', drawing);
    delete(get(handles.td, 'Children'));
    num = num + 1;
else
    %Target drawing done.  Now let the users design the distractors
    changeToDis(hObject, eventdata, handles);
end

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
drawing = get(hObject, 'UserData');
colour = get(handles.colourButton, 'UserData');

hold on;
delete(get(hObject, 'Children'));
coordinates = get(hObject, 'CurrentPoint'); 
coordinates = coordinates(1, 1:2);

pix = getPix(coordinates, dim);
xpix = pix(1);
ypix = pix(2);

if drawing(xpix, ypix) == 0
    drawing(xpix, ypix) = 1;
else
    drawing(xpix, ypix) = 0;
end

imHandle = displayTd(drawing, colour, hObject);
set(imHandle, 'HitTest', 'off');
saveDrawing(handles, drawing, colour);

% --- Executes on button press in colourButton.
function colourButton_Callback(hObject, eventdata, handles)
% hObject    handle to colourButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldC = get(hObject, 'UserData');
c = uisetcolor(oldC);   %if user press 'Cancel', c = oldC
set(hObject, 'UserData', c);
axes(handles.td);
drawing = get(handles.td, 'UserData');

hold on;
delete(get(handles.td, 'Children'));
imHandle = displayTd(drawing, c, handles.td);
set(imHandle, 'HitTest', 'off');

%Helper to clear
function clearDrawing(handles)
global dim;
axes(handles.td);
drawing = ones(dim, dim);
set(handles.td, 'UserData', drawing);
delete(get(handles.td, 'Children'));

% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearDrawing(handles);

%Helper Functions
%Save the relevant target data
function saveTarget(handles, targ, targColour, targNum)
global targCVec targCell;
set(handles.td, 'UserData', targ);
set(handles.colourButton, 'UserData', targColour);
targCVec{targNum} = targColour;
targCell{targNum} = targ;
setappdata(0, 'targCell', targCell);
setappdata(0, 'tcCell', targCVec);

%Save the relevant distractor data
function saveDistractor(handles, dis, disColour, disNum)
global disCVec disCell;
set(handles.td, 'UserData', dis);
set(handles.colourButton, 'UserData', disColour);
disCVec{disNum} = disColour;
disCell{disNum} = dis;
setappdata(0, 'disCell', disCell);
setappdata(0, 'dcCell', disCVec);

function saveDrawing(handles, drawing, colour)
global isTarg num;
if isTarg == 1
    saveTarget(handles, drawing, colour, num);
else
    saveDistractor(handles, drawing, colour, num);
end
%End Helper Functions

% --- Executes on button press in previewButton.
function previewButton_Callback(hObject, eventdata, handles)
% hObject    handle to previewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(previewTd);


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%sdt stands for signal detection target
global dim;
[FileName, pathname] = uiputfile('*.pic', 'Saving your drawing');

%If the dialog box is cancelled
if pathname == 0
    return;
end

file = fullfile(pathname, FileName);

fid = fopen(file, 'wt+');
drawing = get(handles.td, 'UserData');
colour = get(handles.colourButton, 'UserData');

%The target is stored as a column vector of 0 and 1's
for i = 1:dim
   %10 is the height of the targ
   for j = 1:dim
       %10 is the width of the targ
      fprintf(fid, '%d\n', drawing(i, j)); 
   end
end

for i = 1:3
   fprintf(fid, '%f\n', colour(i)); 
end

fclose(fid);

% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dim;

drawing = ones(dim, dim);
[fileName, pathname] = uigetfile('*.pic', 'Please Select a .pic file');

if pathname == 0
    return;
end

delete(get(handles.td, 'Children'));
axes(handles.td);
hold on;

file = fullfile(pathname, fileName);
fid = fopen(file, 'r');

B = fscanf(fid, '%f');

Bindx = 0;

for i = 1:dim
    for j = 1:dim
      Bindx = Bindx + 1;
      drawing(i, j) = B(Bindx);
    end
end

colour = B(Bindx+1:Bindx+3);
saveDrawing(handles, drawing, colour);

imHandle = displayTd(drawing, colour, handles.td);
set(imHandle, 'HitTest', 'off');


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global targCVec disCVec targCell disCell isTarg num nCopies NT ND;
drawing = get(handles.td, 'UserData');
colour = get(handles.colourButton, 'UserData');
saveDrawing(handles, drawing, colour);
if (isTarg == 1 && num < NT) || (isTarg == 0 && num < ND)
    figure(drawNextBox);
elseif isTarg == 1 && num >= NT
   %We have reached the limit of drawing the target
   %commencing drawing of distractor now
   changeToDis(hObject, eventdata, handles);
else
    %Temp
    close;
    figure(actualTest);
end

function changeToDis(hObject, eventdata, handles)
global isTarg num;
clearDrawing(handles);
isTarg = 0; 
setappdata(0, 'isTarg', isTarg);
num = 1;
set(handles.drawPrompt, 'string', 'Draw Your Distractor Below:');
set(handles.previewButton, 'enable', 'on'); %now one can preview the stimulus
