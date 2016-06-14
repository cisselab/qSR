function varargout = PairCorrelation(varargin)
% PAIRCORRELATION MATLAB code for PairCorrelation.fig
%      PAIRCORRELATION, by itself, creates a new PAIRCORRELATION or raises the existing
%      singleton*.
%
%      H = PAIRCORRELATION returns the handle to a new PAIRCORRELATION or the handle to
%      the existing singleton*.
%
%      PAIRCORRELATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAIRCORRELATION.M with the given input arguments.
%
%      PAIRCORRELATION('Property','Value',...) creates a new PAIRCORRELATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PairCorrelation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PairCorrelation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PairCorrelation

% Last Modified by GUIDE v2.5 26-May-2016 17:37:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PairCorrelation_OpeningFcn, ...
                   'gui_OutputFcn',  @PairCorrelation_OutputFcn, ...
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


% --- Executes just before PairCorrelation is made visible.
function PairCorrelation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PairCorrelation (see VARARGIN)

handles.mainObject=varargin{1};

% Choose default command line output for PairCorrelation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PairCorrelation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PairCorrelation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectRegion.
function SelectRegion_Callback(hObject, eventdata, handles)
% hObject    handle to SelectRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainHandles=guidata(handles.mainObject);

if isfield(mainHandles,'pointillist_handle')
    if ishandle(mainHandles.pointillist_handle)
        figure(mainHandles.pointillist_handle)
    else
        mainHandles.pointillist_handle = figure;
        guidata(handles.mainObject, mainHandles);
        pointillist([mainHandles.fXpos;mainHandles.fYpos])
    end
    
else
    mainHandles.pointillist_handle = figure;
    guidata(handles.mainObject, mainHandles);
    pointillist([mainHandles.fXpos;mainHandles.fYpos])
end

handles.FreehandROICoordinateList = DrawFreehandRegion; %Returns an ordered list of the x and y coordinates that defines the boundary.
handles.included_points = inpolygon(mainHandles.fXpos,mainHandles.fYpos,handles.FreehandROICoordinateList(:,1),handles.FreehandROICoordinateList(:,2)); %Returns a logical defining which points lie within the ROI. 

guidata(hObject,handles)


% --- Executes on button press in RunAnalysis.
function RunAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pc_bin_size = str2num(get(handles.BinSize,'String'));
pc_max_length = str2num(get(handles.MaxLength,'String'));

mainHandles=guidata(handles.mainObject);

XposIN = mainHandles.fXpos(handles.included_points);
YposIN = mainHandles.fYpos(handles.included_points);

[image,mask,~,~]=create_pc_image(XposIN,YposIN,pc_bin_size,handles.FreehandROICoordinateList);

[~,handles.r,handles.g,~] = pair_corr(image,mask,pc_bin_size,pc_max_length);
guidata(hObject,handles)

figure
plot(handles.r,handles.g,'.k')
xlabel('r (nm)')
ylabel('g(r)')
title('Spatial Pair Correlation Function')

% --- Executes on button press in SaveOutput.
function SaveOutput_Callback(hObject, eventdata, handles)
% hObject    handle to SaveOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Add saving feature.
if isfield(handles,'r')
    mainHandles=guidata(handles.mainObject);
    test_dir_name = 'pc_data';
    count = 1;
    while exist([mainHandles.directory,test_dir_name],'dir')
        count=count+1;
        test_dir_name=['pc_data_',num2str(count)];
    end
    mkdir([mainHandles.directory,test_dir_name])
    
    %save filter state of data
    
    filter_status_filename = [mainHandles.directory,test_dir_name,filesep,'filter_status_for_pc.txt'];
    SaveFilterStatus(handles.mainObject,mainHandles,filter_status_filename)

    %save ROI
    ROI_filename='IncludedPoints.csv';
    dlmwrite([mainHandles.directory,test_dir_name,filesep,ROI_filename],handles.included_points,',')
   
    %save image of ROI
    
    figure('Visible','Off')
    plot(mainHandles.fXpos,mainHandles.fYpos,'.','Markersize',2,'Color',[0;0;0]/255)
    xlabel('nm')
    ylabel('nm')
    title('Data Points used for pair correlation function')
    hold on
    plot(mainHandles.fXpos(handles.included_points),mainHandles.fYpos(handles.included_points),'.','Markersize',6,'Color',[213;94;0]/255)
    plot_file_name=[mainHandles.directory,test_dir_name,filesep,'IncludedPoints.jpg'];
    saveas(gcf,plot_file_name,'jpg')
    close(gcf)
    
    %save parameters
    pc_bin_size = str2num(get(handles.BinSize,'String'));
    pc_max_length = str2num(get(handles.MaxLength,'String'));
    parameter_filename='parameters.txt';
    fhandle=fopen([mainHandles.directory,test_dir_name,filesep,parameter_filename],'w');
    fprintf(fhandle,['Bin Size = ',num2str(pc_bin_size),' nm \n','Max Length = ',num2str(pc_max_length),' nm']);
    fclose(fhandle);
    
    %save g(r)
    
    fhandle=fopen([mainHandles.directory,test_dir_name,filesep,'pair_correlation.csv'],'w');
    fprintf(fhandle,'r(nm),g');
    fprintf(fhandle,'\n');
    for i = 1:length(handles.r)
        fprintf(fhandle,[num2str(handles.r(i)),',',num2str(handles.g(i)),'\n']);
    end
    fclose(fhandle);
    
end



function BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BinSize as text
%        str2double(get(hObject,'String')) returns contents of BinSize as a double


% --- Executes during object creation, after setting all properties.
function BinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxLength_Callback(hObject, eventdata, handles)
% hObject    handle to MaxLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxLength as text
%        str2double(get(hObject,'String')) returns contents of MaxLength as a double


% --- Executes during object creation, after setting all properties.
function MaxLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
