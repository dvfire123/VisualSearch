function varargout = actualTest(varargin)
% ACTUALTEST MATLAB code for actualTest.fig
%      ACTUALTEST, by itself, creates a new ACTUALTEST or raises the existing
%      singleton*.
%
%      H = ACTUALTEST returns the handle to a new ACTUALTEST or the handle to
%      the existing singleton*.
%
%      ACTUALTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACTUALTEST.M with the given input arguments.
%
%      ACTUALTEST('Property','Value',...) creates a new ACTUALTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before actualTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to actualTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help actualTest

% Last Modified by GUIDE v2.5 28-Oct-2015 17:08:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @actualTest_OpeningFcn, ...
                   'gui_OutputFcn',  @actualTest_OutputFcn, ...
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


% --- Executes just before actualTest is made visible.
function actualTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to actualTest (see VARARGIN)
global targCVec disCVec targCell disCell dispTime;
global FULL_HEIGHT FULL_WIDTH sHeight sWidth minDist bgColour dim;
global nCopies prob numTrials numTarg numDis NT ND;
global dispTimer timeLeft;
global outFile correct totTime;

set(handles.yesButton, 'visible', 'off');
set(handles.noButton, 'visible', 'off');

%Note: DO NOT Change!
dim = 20;
NT = 2;
ND = 6;
FULL_HEIGHT = 400;
FULL_WIDTH = 600;
bgColour = [1 1 1]; %white
minDist = ceil(dim/4);
%End Note

%Load parameters
inputs = getappdata(0, 'inputs');
targCell = getappdata(0, 'targCell');    %could be more than one target
disCell = getappdata(0, 'disCell');      %could be more than one distractor
targCVec = getappdata(0, 'tcCell');
disCVec = getappdata(0, 'dcCell');

prob = str2double(inputs{3});
nCopies = str2double(inputs{4});
dispTime = str2double(inputs{5});
numTrials = str2double(inputs{6});
hs = str2double(inputs{7});
ws = str2double(inputs{8});

sHeight = FULL_HEIGHT*hs/100;
sWidth = FULL_WIDTH*ws/100;

correct = 0;
totTime = 0;

[numTarg, numDis] = countDrawings();

%plot the targets
for num = 1:NT
   targ = flipdim(targCell{num}, 1);
   c = targCVec{num};
   if num == 1
      ax = handles.targ1;
   else
      ax = handles.targ2;
   end
   
   displayTd(targ, c, ax);
end

% Next we are going to store some more data:
testNum = 1;
s = sprintf('Test: %d/%d', testNum, numTrials);
set(handles.testCountLabel, 'String', s);
set(handles.testCountLabel, 'UserData', testNum);

%%Create the output folder%%
[folder, ~, ~] = fileparts(mfilename('fullpath'));
if isdeployed
    folder = pwd;
end
resFolder = 'Results';
resFolder = fullfile(folder, resFolder);
if ~exist(resFolder, 'dir')
    mkdir(resFolder);
end

ln = inputs{2};
fn = inputs{1};

fileName = sprintf('%s-%s-out.txt', fn, ln);
outFile = fullfile(resFolder, fileName);

%Parameters for each experiment
fid = fopen(outFile, 'at');
fprintf(fid, 'Name %s, %s\n', ln, fn);
fprintf(fid, '%s\n', datestr(now));

fprintf(fid, '\nTest Parameters\n');
fprintf(fid, 'Maximum stimulus height (no. of dots) %d\n', FULL_HEIGHT);
fprintf(fid, 'Maximum stimulus height (no. of dots) %d\n', FULL_WIDTH);
fprintf(fid, 'Actual stimulus height (no. of dots) %d\n', sHeight);
fprintf(fid, 'Actual stimulus width (no. of dots) %d\n', sWidth);
fprintf(fid, 'Percent of full height used %f\n', hs);
fprintf(fid, 'Percent of full width used %f\n', ws);

fprintf(fid, 'Number of Targets %d\n', numTarg);
fprintf(fid, 'Number of Distractors %d\n', numDis);
fprintf(fid, 'Target/Distractor dots per dimension %d\n', dim);
fprintf(fid, 'Probability of target presence %f\n', prob);
fprintf(fid, 'Number of copies of each distractor %d\n', nCopies);
fprintf(fid, 'Number of trials %d\n', numTrials);
fprintf(fid, 'Display Time for each stimulus %f sec\n', dispTime);
fprintf(fid, '\n');
fclose(fid);

% Choose default command line output for ActualTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Set up display timer, but of course don't start it until wait timer
%is done
dispTimer = timer;
dispTimer.period = 1;
set(dispTimer,'ExecutionMode','fixedrate','StartDelay', 0);
set(dispTimer, 'TimerFcn', {@dispTimeGoing, handles});
timeLeft = dispTime;

%Set up the cover:
%to overlap with the stim axes
pos = get(handles.stim, 'Position');
set(handles.coverLabel, 'Position', pos);
set(handles.coverLabel, 'visible', 'off');

%begin the actual test
nextTrial(handles);

% UIWAIT makes ActualTest wait for user response (see UIRESUME)
% uiwait(handles.actualTest);


% --- Outputs from this function are returned to the command line.
function varargout = actualTest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in yesButton.
function yesResponse(hObject, eventdata, handles)
% hObject    handle to yesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
response(hObject, eventdata, handles, 1);


% --- Executes on button press in noButton.
function noResponse(hObject, eventdata, handles)
% hObject    handle to noButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
response(hObject, eventdata, handles, 0);



%%Helpers%%
%Records User Response
function response(hObject, eventdata, handles, isYes)
global outFile correct totTime dispTimer numTrials res;

stop(dispTimer);

timeSpent = toc;
totTime = totTime + timeSpent;

%log response:
testNum = get(handles.testCountLabel, 'UserData');
corrStr = 'Incorrect';

resStr = 'No';
if res == 1
    resStr = 'Yes';
end

userStr = 'No';
if isYes == 1
    userStr = 'Yes';
end

if res == isYes
    correct = correct + 1;
    corrStr = 'correct';
end

s = sprintf('Trial %d of %d\tUser %s\tActual %s (%s)\tResponse time %f sec',...
    testNum, numTrials, userStr, resStr, corrStr, timeSpent);
fid = fopen(outFile, 'at');
fprintf(fid, '%s', s);
fprintf(fid, '\n');
fclose(fid);

testNum = testNum + 1;

if testNum > numTrials
   %All of the trials are completed
   hitRate = 100*correct/numTrials;
   avgTime = totTime/numTrials;
   fid = fopen(outFile, 'at');
   fprintf(fid, '\nYou got %d out of %d correct\n', correct, numTrials);
   fprintf(fid, 'Hit Rate %f percent\n', hitRate);
   fprintf(fid, 'Average response time %f sec\n', avgTime);
   fprintf(fid, '----------\n');
   fclose(fid);
   
   close;
   figure(beginTest);
else
    %Still more trials to go
    s = sprintf('Test: %d/%d', testNum, numTrials);
    set(handles.testCountLabel, 'String', s);
    set(handles.testCountLabel, 'UserData', testNum);
    nextTrial(handles);
end


%draw fixations (with cross in the middle)
function crossHandle = drawCross(handles)
global FULL_HEIGHT FULL_WIDTH;
SHRINK_FACTOR = 10;
height = FULL_HEIGHT/SHRINK_FACTOR;
width = FULL_WIDTH/SHRINK_FACTOR;

axes(handles.stim);
crossHandle = crossStimulus(height, width, handles.stim);


%helper to draw stim
function showStim(handles)
global targCVec disCVec targCell disCell;
global sHeight sWidth minDist bgColour dim nCopies prob res;
global FULL_HEIGHT FULL_WIDTH;

axes(handles.stim);
delete(get(handles.stim, 'Children'));
res = createStimulus(FULL_HEIGHT, sHeight, FULL_WIDTH, sWidth, dim, targCell, disCell,...
        targCVec, disCVec, nCopies, prob, minDist, bgColour, handles.stim, 1);
    
set(handles.stimulusLabel, 'string', 'Stimulus');

set(handles.yesButton, 'Enable', 'on');
set(handles.noButton, 'Enable', 'on');

restartDispTimer();
tic;


function nextTrial(handles)
%Dummy buttons: not actually shown
set(handles.yesButton, 'Enable', 'off');
set(handles.noButton, 'Enable', 'off');

axes(handles.stim);
delete(get(handles.stim, 'Children'));
drawCross(handles);
set(handles.coverLabel, 'visible', 'off');
set(handles.stimulusLabel, 'string', 'Please fixate on the cross; press the space bar to show stimulus');

%Display timer callbacks
function dispTimeGoing(hObject, eventdata, handles)
global dispTimer timeLeft;

timeLeft = timeLeft - 1;
if timeLeft < 0
    stop(dispTimer);
    set(handles.coverLabel, 'visible', 'on');
end

function restartDispTimer()
global dispTimer timeLeft dispTime;
timeLeft = dispTime;
start(dispTimer);


% --- Executes on key press with focus on actualTest or any of its controls.
function actualTest_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to actualTest (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
  case 'y'
     if strcmp(get(handles.yesButton, 'Enable'), 'on')
        yesResponse(hObject, eventdata, handles) 
     end
  case 'n'
      if strcmp(get(handles.noButton, 'Enable'), 'on')
        noResponse(hObject, eventdata, handles)
      end
    case 'space'
        %Show stimulus here only if the stim hasn't been shown
        if strcmp(get(handles.yesButton, 'Enable'), 'off')
            showStim(handles);
        end
end


% --- Executes on button press in yesButton.
function yesButton_Callback(hObject, eventdata, handles)
% hObject    handle to yesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in noButton.
function noButton_Callback(hObject, eventdata, handles)
% hObject    handle to noButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function [numTarg, numDis] = countDrawings()
global targCell disCell dim NT ND;
numTarg = 0;
numDis = 0;

for i = 1:NT
    drawing = targCell{i};
    if isZeroMatrix(drawing-ones(dim, dim)) == 0
        numTarg = numTarg + 1;
    end
end

for i = 1:ND
    drawing = disCell{i};
    if isZeroMatrix(drawing-ones(dim, dim)) == 0
        numDis = numDis + 1;
    end
end
