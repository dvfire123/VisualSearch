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

% Last Modified by GUIDE v2.5 21-Oct-2015 17:09:34

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
global waitTimer dispTimer timeLeft;
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

%Plot the drawing
% axes(handles.stimulus);
% delete(get(handles.stimulus, 'Children'));
% hold on;
% res = genStimulus(prob, sHeight, sWidth, percentWhite, targ, handles.stimulus);
% set(gcf, 'UserData', res);
% 
% %Next we are going to store some more data:
% testNum = 1;
% s = sprintf('Test: %d/%d', testNum, Ns);
% set(handles.testCountLabel, 'String', s);
% set(handles.testCountLabel, 'UserData', testNum);

% Choose default command line output for ActualTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%Create the output folder%%
% [folder, ~, ~] = fileparts(mfilename('fullpath'));
% if isdeployed
%     folder = pwd;
% end
% resFolder = 'Results';
% resFolder = fullfile(folder, resFolder);
% if ~exist(resFolder, 'dir')
%     mkdir(resFolder);
% end
% 
% ln = inputs{2};
% fn = inputs{1};
% 
% fileName = sprintf('%s-%s-out.txt', fn, ln);
% outFile = fullfile(resFolder, fileName);
% 
% fid = fopen(outFile, 'at');
% fprintf(fid, 'Name: %s, %s\n', ln, fn);
% fprintf(fid, '%s\n', datestr(now));
% fprintf(fid, '\nTest Parameters:\n');
% fprintf(fid, 'Stimulus no. of dots per dimension: %d\n', sHeight);
% fprintf(fid, 'Percentage of whitespace: %f\n', percentWhite);
% fprintf(fid, 'Probability of target presence: %f\n', prob);
% fprintf(fid, 'Number of trials: %d\n', Ns);
% fprintf(fid, 'Display Time for each stimulus: %f sec\n', dispTime);
% fprintf(fid, 'Wait time between consecutive trials: %f sec\n', waitTime);
% fprintf(fid, '\n');
% fclose(fid);
% 
% %Now we have to set up the timer before displaying the
% %stimulus
% waitTimer = timer;
% waitTimer.period = 1;
% set(waitTimer,'ExecutionMode','fixedrate','StartDelay',1);
% set(waitTimer, 'TimerFcn', {@countDown, handles});
% set(waitTimer, 'StopFcn', {@timesup, handles});
% 
% %Set up display timer, but of course don't start it until wait timer
% %is done
% dispTimer = timer;
% dispTimer.period = 1;
% set(dispTimer,'ExecutionMode','fixedrate','StartDelay', 0);
% set(dispTimer, 'TimerFcn', {@dispTimeGoing, handles});
% set(dispTimer, 'StopFcn', {@dispTimesUp, handles});
% timeLeft = dispTime;
% 
% %begin the actual test
% start(waitTimer);

% UIWAIT makes ActualTest wait for user response (see UIRESUME)
% uiwait(handles.actualTest);

% Choose default command line output for actualTest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes actualTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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


% --- Executes on button press in noButton.
function noButton_Callback(hObject, eventdata, handles)
% hObject    handle to noButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
