function varargout = panorama_gui(varargin)
% PANORAMA_GUI MATLAB code for panorama_gui.fig
%      PANORAMA_GUI, by itself, creates a new PANORAMA_GUI or raises the existing
%      singleton*.
%
%      H = PANORAMA_GUI returns the handle to a new PANORAMA_GUI or the handle to
%      the existing singleton*.
%
%      PANORAMA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANORAMA_GUI.M with the given input arguments.
%
%      PANORAMA_GUI('Property','Value',...) creates a new PANORAMA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before panorama_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to panorama_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help panorama_gui

% Last Modified by GUIDE v2.5 12-Mar-2015 14:42:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @panorama_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @panorama_gui_OutputFcn, ...
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


% --- Executes just before panorama_gui is made visible.
function panorama_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to panorama_gui (see VARARGIN)

% Choose default command line output for panorama_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes panorama_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = panorama_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
pos = get(handles.single,'Position');
width = pos(3);% get the height
if width > 1
    val = get(hObject,'Value');
    xPos = -(width-1) + (width-1)*(1-val);
    pos(1) = xPos;
    set(handles.single,'Position',pos);
end

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function menu_Callback(hObject, eventdata, handles)
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider,'Value',1.0); % reset slider

% --------------------------------------------------------------------
function hom_Callback(hObject, eventdata, handles)
% hObject    handle to hom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function cyl_Callback(hObject, eventdata, handles)
% hObject    handle to cyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
