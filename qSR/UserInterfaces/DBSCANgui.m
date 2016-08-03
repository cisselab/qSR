function varargout = DBSCANgui(varargin)
% DBSCANgui MATLAB code for DBSCANgui.fig
%      DBSCANgui, by itself, creates a new DBSCANgui or raises the existing
%      singleton*.
%
%      H = DBSCANgui returns the handle to a new DBSCANgui or the handle to
%      the existing singleton*.
%
%      DBSCANgui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DBSCANgui.M with the given input arguments.
%
%      DBSCANgui('Property','Value',...) creates a new DBSCANgui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DBSCANgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DBSCANgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DBSCANgui

% Last Modified by GUIDE v2.5 26-May-2016 16:22:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DBSCANgui_OpeningFcn, ...
                   'gui_OutputFcn',  @DBSCANgui_OutputFcn, ...
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


% --- Executes just before DBSCANgui is made visible.
function DBSCANgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DBSCANgui (see VARARGIN)

handles.mainObject=varargin{1};

% Choose default command line output for DBSCANgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DBSCANgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = DBSCANgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SaveClusters.
function SaveClusters_Callback(hObject, eventdata, handles)
% hObject    handle to SaveClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'cluster_IDs')
    mainHandles=guidata(handles.mainObject);
    mainHandles.sp_clusters=handles.cluster_IDs;
    mainHandles.valid_sp_clusters=true;

    mainHandles.sp_clust_algorithm = 'DBSCAN';

    lengthscale = str2num(get(handles.LengthScale,'String'));
    nmin = str2num(get(handles.MinPoints,'String'));
    mainHandles.dbscan_length=lengthscale;
    mainHandles.dbscan_nmin=nmin;

    guidata(handles.mainObject,mainHandles)
    
    msgbox('Export complete!')
else
    msgbox('You must first run the analysis!')
end

% --- Executes on button press in PlotGraph.
function PlotGraph_Callback(hObject, eventdata, handles)
% hObject    handle to PlotGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'cluster_IDs')
    mainHandles=guidata(handles.mainObject);
    data=[mainHandles.fXpos',mainHandles.fYpos'];
    ids=handles.cluster_IDs;
    plot_2d_clusters(data,ids)
else
    msgbox('You must first run the analysis!')
end

function LengthScale_Callback(hObject, eventdata, handles)
% hObject    handle to LengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LengthScale as text
%        str2double(get(hObject,'String')) returns contents of LengthScale as a double

length_scale = str2num(get(handles.LengthScale,'String'));
if isempty(length_scale)
    msgbox('Length scale must be a positive number!')
    set(handles.LengthScale,'String',100)
    guidata(hObject,handles)
elseif length_scale <=0
    msgbox('Length scale must be a positive number!')
    set(handles.LengthScale,'String',100)
    guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function LengthScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinPoints_Callback(hObject, eventdata, handles)
% hObject    handle to MinPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinPoints as text
%        str2double(get(hObject,'String')) returns contents of MinPoints as a double

min_pts = str2num(get(handles.MinPoints,'String'));
if isempty(min_pts)
    msgbox('Minimum Points must be a positive integer!')
    set(handles.MinPoints,'String',10)
    guidata(hObject,handles)
elseif min_pts <=0
    msgbox('Minimum Points must be a positive integer!')
    set(handles.MinPoints,'String',10)
    guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function MinPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunAnalysis.
function RunAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lengthscale = str2num(get(handles.LengthScale,'String'));
nmin = str2num(get(handles.MinPoints,'String'));
mainHandles=guidata(handles.mainObject);
data=[mainHandles.fXpos',mainHandles.fYpos']; %mainHandles.fFrames
[handles.cluster_IDs,~] = DBSCAN(data,lengthscale,nmin);
guidata(hObject,handles)

if isfield(handles,'cluster_IDs')
    mainHandles=guidata(handles.mainObject);
    data=[mainHandles.fXpos',mainHandles.fYpos'];
    ids=handles.cluster_IDs;
    plot_2d_clusters(data,ids)
else
    msgbox('You must first run the analysis!')
end
