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

% Last Modified by GUIDE v2.5 22-Oct-2015 00:27:12

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
global targCVec disCVec targCell disCell dispTime waitTime;
global sHeight sWidth minDist bgColour dim nCopies prob numTrials;
global waitTimer dispTimer timeLeft waitTimeLeft;
global outFile correct totTime;

dim = 20;
sHeight = 400;
sWidth = 600;
bgColour = [1 1 1]; %white
minDist = ceil(dim/4);

%Load parameters
inputs = getappdata(beginTest, 'inputs');
close(beginTest);
targCell = getappdata(0, 'targCell');    %could be more than one target
disCell = getappdata(0, 'disCell');      %could be more than one distractor
targCVec = getappdata(0, 'tcCell');
disCVec = getappdata(0, 'dcCell');

prob = str2double(inputs{3});
nCopies = str2double(inputs{4});
dispTime = str2double(inputs{5});
waitTime = str2double(inputs{6});
numTrials = str2double(inputs{7});

correct = 0;
totTime = 0;

%plot the targets
[~, numTarg] = size(targCell);
[~, numDis] = size(disCell);

for num = 1:numTarg
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

% Choose default command line output for ActualTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

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
fprintf(fid, 'Name: %s, %s\n', ln, fn);
fprintf(fid, '%s\n', datestr(now));
fprintf(fid, '\nTest Parameters:\n');
fprintf(fid, 'Stimulus height (no. of dots): %d\n', sHeight);
fprintf(fid, 'Stimulus width (no. of dots): %d\n', sWidth);
fprintf(fid, 'Number of targets: %d\n', numTarg);
fprintf(fid, 'Number of distractors: %d\n', numDis);
fprintf(fid, 'Target/Distractor dots per dimension: %d\n', dim);
fprintf(fid, 'Probability of target presence: %f\n', prob);
fprintf(fid, 'Number of copies of each distractor: %d\n', nCopies);
fprintf(fid, 'Number of trials: %d\n', numTrials);
fprintf(fid, 'Display Time for each stimulus: %f sec\n', dispTime);
fprintf(fid, 'Wait time between consecutive trials: %f sec\n', waitTime);
fprintf(fid, '\n');
fclose(fid);

%Now we have to set up the timer before displaying the stimulus
waitTimer = timer;
waitTimer.period = 1;
set(waitTimer,'ExecutionMode','fixedrate','StartDelay',1);
set(waitTimer, 'TimerFcn', {@countDown, handles});
set(waitTimer, 'StopFcn', {@timesup, handles});
waitTimeLeft = waitTime;

%Set up display timer, but of course don't start it until wait timer
%is done
dispTimer = timer;
dispTimer.period = 1;
set(dispTimer,'ExecutionMode','fixedrate','StartDelay', 0);
set(dispTimer, 'TimerFcn', {@dispTimeGoing, handles});
set(dispTimer, 'StopFcn', {@dispTimesUp, handles});
timeLeft = dispTime;

%begin the actual test
drawCross(handles);
start(waitTimer);

% UIWAIT makes ActualTest wait for user response (see UIRESUME)
% uiwait(handles.actualTest);

% Choose default command line output for actualTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes actualTest wait for user response (see UIRESUME)
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
function yesButton_Callback(hObject, eventdata, handles)
% hObject    handle to yesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
response(hObject, eventdata, handles, 1);


% --- Executes on button press in noButton.
function noButton_Callback(hObject, eventdata, handles)
% hObject    handle to noButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
response(hObject, eventdata, handles, 0);


%%Helpers%%
%Records User Response
function response(hObject, eventdata, handles, isYes)
global outFile correct totTime dispTimer numTrials;
stop(dispTimer);

timeSpent = toc;
totTime = totTime + timeSpent;

%log response:
testNum = get(handles.testCountLabel, 'UserData');
res = get(gcf, 'UserData');
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

s = sprintf('Trial %d of %d\tUser: %s\tActual: %s (%s)\tResponse time: %f sec',...
    testNum, numTrials, userStr, resStr, corrStr, timeSpent);
fid = fopen(outFile, 'at');
fprintf(fid, '%s', s);
fprintf(fid, '\n');
fclose(fid);

testNum = testNum + 1;

if testNum > numTrials
   hitRate = 100*correct/numTrials;
   avgTime = totTime/numTrials;
   fid = fopen(outFile, 'at');
   fprintf(fid, '\nYou got %d out of %d correct\n', correct, numTrials);
   fprintf(fid, 'Hit Rate: %f percent\n', hitRate);
   fprintf(fid, 'Average response time: %f sec\n', avgTime);
   fprintf(fid, '----------\n');
   fclose(fid);
   
   close;
   figure(beginTest);
else
    s = sprintf('Test: %d/%d', testNum, numTrials);
    set(handles.testCountLabel, 'String', s);
    set(handles.testCountLabel, 'UserData', testNum);
    restartWaitTimer(handles);
end

%draw blank stimulus
function drawBlankStim(handles)
global sHeight sWidth;
blankStimulus(sHeight, sWidth, handles.stim);

%draw cover (with cross in the middle)
function drawCross(handles)
global sHeight sWidth;
SHRINK_FACTOR = 5;
height = sHeight/SHRINK_FACTOR;
width = sWidth/SHRINK_FACTOR;
crossStimulus(height, width, handles.stim);

%---Timer Callbacks---
%wait timer callbacks
function countDown(hObject, eventdata, handles)
global waitTimer dispTimer waitTimeLeft;
stop(dispTimer);
waitTimeLeft = waitTimeLeft - 1;
if waitTimeLeft <= 0
   stop(waitTimer); 
end

%This is call back to stop wait timer
function timesup(hObject, eventdata, handles)
global targCVec disCVec targCell disCell;
global sHeight sWidth minDist bgColour dim nCopies prob;

set(handles.yesButton, 'Enable', 'on');
set(handles.noButton, 'Enable', 'on');

%delete(get(handles.stim, 'Children'));
%res = createStimulus(sHeight, sWidth, dim, targCell, disCell,...
%   targCVec, disCVec, nCopies, prob, minDist, bgColour, handles.stim);
res = 1;
set(gcf, 'UserData', res);

restartDispTimer(handles)
tic;

function restartWaitTimer(handles)
global waitTimer waitTime waitTimeLeft;
set(handles.yesButton, 'Enable', 'off');
set(handles.noButton, 'Enable', 'off');
waitTimeLeft = waitTime;
drawCross(handles);
start(waitTimer);

%Display timer callbacks
function dispTimesUp(hObject, eventdata, handles)
%Empty function

function dispTimeGoing(hObject, eventdata, handles)
global dispTimer timeLeft;
timeLeft = timeLeft - 1;
if timeLeft < 0
    stop(dispTimer);
    drawBlankStim(handles);
end

function restartDispTimer(handles)
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
        yesButton_Callback(hObject, eventdata, handles) 
     end
  case 'n'
      if strcmp(get(handles.noButton, 'Enable'), 'on')
        noButton_Callback(hObject, eventdata, handles)
      end
end
