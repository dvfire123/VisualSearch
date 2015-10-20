function varargout = cBox(varargin)
% CBOX MATLAB code for cBox.fig
%      CBOX, by itself, creates a new CBOX or raises the existing
%      singleton*.
%
%      H = CBOX returns the handle to a new CBOX or the handle to
%      the existing singleton*.
%
%      CBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CBOX.M with the given input arguments.
%
%      CBOX('Property','Value',...) creates a new CBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cBox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cBox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cBox

% Last Modified by GUIDE v2.5 20-Oct-2015 15:48:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cBox_OpeningFcn, ...
                   'gui_OutputFcn',  @cBox_OutputFcn, ...
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


% --- Executes just before cBox is made visible.
function cBox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cBox (see VARARGIN)
s = sprintf('%s\n\n%s\n\n%s\n\n%s', ...
                'Application created by: David Yiwei Ding', ...
                'October 2015', ...
                'Special thanks to: Prof. Milgram and his team for their valuable inputs, advice, and feedback.', ...
                'Visit: www.davidyding.com');
set(handles.creditText, 'string', s);

% Choose default command line output for cBox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cBox wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cBox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in okayButton.
function okayButton_Callback(hObject, eventdata, handles)
% hObject    handle to okayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
