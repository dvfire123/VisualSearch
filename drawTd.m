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

% Last Modified by GUIDE v2.5 28-Oct-2015 20:44:59

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
global latestDFolder;
[folder, ~, ~] = fileparts(mfilename('fullpath'));
if isdeployed
    folder = pwd;
end

%The folder to store the latest drawings
latestDFolder = fullfile(folder, 'SysFiles');
if ~exist(latestDFolder, 'dir')
   mkdir(latestDFolder); 
end


%Drawing parameters
global isTarg num drawing colour;
global targCell disCell targCVec disCVec;
global dim;
dim = 20;   %DO NOT CHANGE THIS!


isTarg = getappdata(0, 'isTarg');
num = getappdata(0, 'num');

targCell = getappdata(0, 'targCell');    
disCell = getappdata(0, 'disCell');      
targCVec = getappdata(0, 'tcCell');
disCVec = getappdata(0, 'dcCell');

if isTarg == 1;
    drawing = targCell{num};
    colour = targCVec{num};
else
    drawing = disCell{num};
    colour = disCVec{num};
end

xTick = linspace(0, 1, dim+1);
yTick = xTick;

set(handles.td, 'XTick', xTick);
set(handles.td, 'YTick', yTick);

%Store the current drawing
delete(get(handles.td, 'Children'));
hold on;
imHandle = displayTd(drawing, colour, handles.td);
set(imHandle, 'HitTest', 'off');

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
global dim drawing colour;

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

% --- Executes on button press in colourButton.
function colourButton_Callback(hObject, eventdata, handles)
% hObject    handle to colourButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global colour drawing;
c = uisetcolor(colour);   %if user press 'Cancel', c = oldC
colour = c;
axes(handles.td);

hold on;
delete(get(handles.td, 'Children'));
displayTd(drawing, c, handles.td);

%Helper to clear
function clearDrawing(handles)
global dim drawing colour;
axes(handles.td);
drawing = ones(dim, dim);
delete(get(handles.td, 'Children'));
hold on;
imHandle = displayTd(drawing, colour, handles.td);
set(imHandle, 'HitTest', 'off');


% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearDrawing(handles);

%Helper Functions
%Save the relevant target data
function saveTarget(targ, targColour, targNum)
global targCVec targCell drawing colour;
drawing = targ;
colour = targColour;
targCVec{targNum} = targColour;
targCell{targNum} = targ;
setappdata(0, 'targCell', targCell);
setappdata(0, 'tcCell', targCVec);

%Save the relevant distractor data
function saveDistractor(dis, disColour, disNum)
global disCVec disCell drawing colour;
drawing = dis;
colour = disColour;
disCVec{disNum} = disColour;
disCell{disNum} = dis;
setappdata(0, 'disCell', disCell);
setappdata(0, 'dcCell', disCVec);

function saveDrawing(drawing, colour)
global isTarg num;
if isTarg == 1
    saveTarget(drawing, colour, num);
else
    saveDistractor(drawing, colour, num);
end

function saveDrawingToFile()
global isTarg num drawing colour latestDFolder dim;
if isTarg == 1
    fileName = sprintf('t%s.pic', num2str(num));
else
    fileName = sprintf('d%s.pic', num2str(num));
end

file = fullfile(latestDFolder, fileName);
fid = fopen(file, 'wt+');
if isZeroMatrix(drawing - ones(dim, dim)) == 1
    %blank drawing
    %Do nothing
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
       fprintf(fid, '%f\n', colour(i)); 
    end 
end
fclose(fid);
%End Helper Functions

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%sdt stands for signal detection target
global dim drawing colour;
[FileName, pathname] = uiputfile('*.pic', 'Saving your drawing');

%If the dialog box is cancelled
if pathname == 0
    return;
end

file = fullfile(pathname, FileName);

fid = fopen(file, 'wt+');

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
saveDrawing(drawing, colour);

imHandle = displayTd(drawing, colour, handles.td);
set(imHandle, 'HitTest', 'off');


% --- Executes on button press in doneButton.
function doneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global drawing colour;
saveDrawing(drawing, colour);
saveDrawingToFile();
close;
figure(drawingHub);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
setappdata(0, 'drawing', 0);
delete(hObject);


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0, 'drawing', 0);
close;
