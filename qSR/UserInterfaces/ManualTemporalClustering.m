function varargout = ManualTemporalClustering(varargin)
% MANUALTEMPORALCLUSTERING MATLAB code for ManualTemporalClustering.fig
%      MANUALTEMPORALCLUSTERING, by itself, creates a new MANUALTEMPORALCLUSTERING or raises the existing
%      singleton*.
%
%      H = MANUALTEMPORALCLUSTERING returns the handle to a new MANUALTEMPORALCLUSTERING or the handle to
%      the existing singleton*.
%
%      MANUALTEMPORALCLUSTERING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALTEMPORALCLUSTERING.M with the given input arguments.
%
%      MANUALTEMPORALCLUSTERING('Property','Value',...) creates a new MANUALTEMPORALCLUSTERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualTemporalClustering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualTemporalClustering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualTemporalClustering

% Last Modified by GUIDE v2.5 29-Jul-2016 14:42:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualTemporalClustering_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualTemporalClustering_OutputFcn, ...
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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);

% --- Executes just before ManualTemporalClustering is made visible.
function ManualTemporalClustering_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualTemporalClustering (see VARARGIN)

% Choose default command line output for ManualTemporalClustering
handles.mainObject=varargin{1};
mainHandles=guidata(handles.mainObject);


if ~isempty(mainHandles.ROIs)
    handles.current_ROI = 1;
    
    DisplayText = [num2str(handles.current_ROI),'/',num2str(length(mainHandles.ROIs))];
    set(handles.CurrentROIID,'string',DisplayText)
    
    handles.in_ROI = ((mainHandles.fXpos>mainHandles.ROIs{handles.current_ROI}(1))&(mainHandles.fXpos<(mainHandles.ROIs{handles.current_ROI}(1)+mainHandles.ROIs{handles.current_ROI}(3))))&((mainHandles.fYpos>mainHandles.ROIs{handles.current_ROI}(2))&(mainHandles.fYpos<(mainHandles.ROIs{handles.current_ROI}(2)+mainHandles.ROIs{handles.current_ROI}(4))));

    handles.WinArea=mainHandles.ROIs{1}(3)*mainHandles.ROIs{1}(4);

    axes(handles.Spatial_Axes);

    plot(mainHandles.fXpos(handles.in_ROI),mainHandles.fYpos(handles.in_ROI),'ok','MarkerSize',2)

    X = 1:max(mainHandles.fFrames);
    Y = zeros(1,length(X));
    for i = 1:length(X)
        NumberOfDetections = sum(mainHandles.fFrames(handles.in_ROI)==i);
        Y(i) = NumberOfDetections;
    end

    axes(handles.Detection_Axes);
    plot(X,Y,'k')
    axes(handles.Cumulative_Axes);
    plot(X,cumsum(Y),'k')

    handles.X = X;
    handles.Y = Y;
    
else
    msgbox('You must first select ROIs!')
end



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ManualTemporalClustering wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ManualTemporalClustering_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1}=handles.output;

% --- Executes during object creation, after setting all properties.
function Cluster_Number_Selector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cluster_Number_Selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function Cluster_Cutoff_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cluster_Cutoff_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in DisplayCumDetTrace.
function DisplayCumDetTrace_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayCumDetTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DisplayCumDetTrace

GraphUpdateCode(hObject,eventdata,handles)

function Cluster_Cutoff_Input_Callback(hObject, eventdata, handles)
% hObject    handle to Cluster_Cutoff_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cluster_Cutoff_Input as text
%        str2double(get(hObject,'String')) returns contents of Cluster_Cutoff_Input as a double

GraphUpdateCode(hObject,eventdata,handles)

% --- Executes on button press in FitTrace.
function FitTrace_Callback(hObject, eventdata, handles)
% hObject    handle to FitTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FitTrace

GraphUpdateCode(hObject,eventdata,handles)

% --- Executes on button press in Save_Data.
function Save_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainHandles=guidata(handles.mainObject);
mainHandles.st_clusters=RenumberClusters(handles.st_clusters);
mainHandles.valid_st_clusters=true;
guidata(handles.mainObject, mainHandles);


% --- Executes on button press in Subsection_Selector.
function Subsection_Selector_Callback(hObject, eventdata, handles)
% hObject    handle to Subsection_Selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% axes(handles.Spatial_Axes);
% rectangle = imrect;
% rectangleCorners = getPosition(rectangle);
% 
% ROIindices = and(handles.ROIindices,((handles.Xpos>rectangleCorners(1))&(handles.Xpos<(rectangleCorners(1)+rectangleCorners(3))))&((handles.Ypos>rectangleCorners(2))&(handles.Ypos<(rectangleCorners(2)+rectangleCorners(4)))));
% 
% handles.ROIindices = ROIindices;
% 
% handles.WinArea=(max(handles.Xpos(ROIindices))-min(handles.Xpos(ROIindices)))*(max(handles.Ypos(ROIindices))-min(handles.Ypos(ROIindices)));
% 
% guidata(hObject, handles);
% 
% GraphUpdateCode(hObject,eventdata,handles)
% 
% uiwait(handles.figure1);

msgbox('Add this functionality')

% --- Executes on slider movement.
function Cluster_Number_Selector_Callback(hObject, eventdata, handles)
% hObject    handle to Cluster_Number_Selector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Number_Slider_Value = get(handles.Cluster_Number_Selector,'Value'); %Reads the value of Number slider, which was just adjusted.  
set(handles.Cluster_Number_Display,'string',['Detection Sensitivity:',num2str(Number_Slider_Value)])
GraphUpdateCode(hObject,eventdata,handles)

function GraphUpdateCode(hObject,eventdata,handles)

mainHandles=guidata(handles.mainObject);
displayFit = get(handles.FitTrace,'Value');
displayBackground = get(handles.DisplayCumDetTrace,'Value');

ClusterSizeCutoff = str2num(get(handles.Cluster_Cutoff_Input,'String'));
Number_Slider_Value = get(handles.Cluster_Number_Selector,'Value'); %Reads the value of Number slider, which was just adjusted.  
[Start_Times,End_Times] = HierarchicalClusterIdentification(mainHandles.fFrames,handles.in_ROI,Number_Slider_Value,ClusterSizeCutoff);

%%% Graph Update Code %%%
NumberOfClusters = length(Start_Times);
if NumberOfClusters>0
    Clusters = false(NumberOfClusters,length(mainHandles.fFrames));
    for i = 1:length(Start_Times)
        Clusters(i,:)=(((mainHandles.fFrames>=Start_Times(i))&(mainHandles.fFrames<=End_Times(i)))&handles.in_ROI);
    end
else
    Clusters = false(1,length(mainHandles.fFrames));
end

handles.Clusters = Clusters;
guidata(hObject, handles);

axes(handles.Spatial_Axes);
hold off
plot(mainHandles.fXpos(handles.in_ROI),mainHandles.fYpos(handles.in_ROI),'ok','MarkerSize',2)

X = 1:max(mainHandles.fFrames);
Y = zeros(1,length(X));
for i = 1:length(X)
    NumberOfDetections = sum(mainHandles.fFrames(handles.in_ROI)==i);
    Y(i) = NumberOfDetections;
end
Z = cumsum(Y);

axes(handles.Detection_Axes);
hold off
plot(X,Y,'k')
axes(handles.Cumulative_Axes);
hold off
plot(X,Z,'k')

% Color Code Graphs %

ColorScheme = [213,94,0;... Vermillion
    86,180,233;... Sky Blue
    240,228,66;... Yellow
    204,121,167;... Reddish Purple
    0,158,115;... Bluish Green
    230,159,0;... Orange
    0,114,178;... Blue
    0,0,0]; %Black

Markers = '^osd';

% Spatial
axes(handles.Spatial_Axes)
if NumberOfClusters <= 1000
    hold on
    for i = 1:NumberOfClusters
        plot(mainHandles.fXpos(Clusters(i,:)),mainHandles.fYpos(Clusters(i,:)),Markers(mod(ceil(i/4),4)+1),'MarkerFaceColor',ColorScheme(mod(i,7)+1,:)/255,'Color',ColorScheme(mod(i,7)+1,:)/255,'MarkerSize',4)
    end
else
    display('Need a Larger Color Scheme!!!!!!')
end 

axes(handles.Cumulative_Axes)
if NumberOfClusters <= 1000
    hold on
    for i = 1:NumberOfClusters
        plotIndices = and(X>=Start_Times(i),X<=End_Times(i));
        plot(X(plotIndices),Z(plotIndices),'LineWidth',3,'Color',ColorScheme(mod(i,7)+1,:)/255)
    end
end 

[a,~] = size(Clusters);
if ~isfield(handles,'st_clusters')
    handles.st_clusters=zeros(1,length(mainHandles.fFrames));
end
for i = 1:a
    LargestClusterID = max(handles.st_clusters);
    handles.st_clusters = (LargestClusterID+1)*double(Clusters(i,:))+handles.st_clusters; %Each ROI will be indexed by a unique integer
end

% if displayFit
%     functionHandle = @(params,x)(params*(1-exp(-x{1}/x{2}))+x{1}*x{3});
%     handles.A=nlinfit({X,handles.TimeConstant,handles.WinArea/handles.NucArea*handles.FalseDetRate},Z,functionHandle,10);
%     AreaFraction = handles.WinArea/handles.NucArea;
%     ExponentialTerm = (1-exp(-X/handles.TimeConstant));
%     Zfit = handles.A*ExponentialTerm+AreaFraction*(handles.FalseDetRate*X);
%     %Zfit = A*ExponentialTerm;
%     hold on
%     plot(X,Zfit,'g')
% else
%     handles.A=0;
% end

% if displayBackground
%     AreaFraction = handles.WinArea/handles.NucArea;
%     ExponentialTerm = (1-exp(-X/handles.TimeConstant));
%     AverageCumTrace = AreaFraction*(handles.LimitValue*ExponentialTerm+handles.FalseDetRate*X);
%     plot(X,AverageCumTrace,'r')
% end

guidata(hObject,handles)

function clusters_out=RenumberClusters(clusters_in)

clusters_out=zeros(size(clusters_in));
unique_ids=unique(clusters_in(clusters_in~=0));
for i = 1:length(unique_ids)
    clusters_out(clusters_in==unique_ids(i))=i;
end

% --- Executes on button press in LoadPrevious.
function LoadPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to LoadPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainHandles=guidata(handles.mainObject);

handles.current_ROI = mod(handles.current_ROI-2,length(mainHandles.ROIs))+1;
handles.in_ROI = ((mainHandles.fXpos>mainHandles.ROIs{handles.current_ROI}(1))&(mainHandles.fXpos<(mainHandles.ROIs{handles.current_ROI}(1)+mainHandles.ROIs{handles.current_ROI}(3))))&((mainHandles.fYpos>mainHandles.ROIs{handles.current_ROI}(2))&(mainHandles.fYpos<(mainHandles.ROIs{handles.current_ROI}(2)+mainHandles.ROIs{handles.current_ROI}(4))));

DisplayText = [num2str(handles.current_ROI),'/',num2str(length(mainHandles.ROIs))];
set(handles.CurrentROIID,'string',DisplayText)

handles.WinArea=mainHandles.ROIs{handles.current_ROI}(3)*mainHandles.ROIs{handles.current_ROI}(4);
guidata(hObject,handles)
GraphUpdateCode(hObject,eventdata,handles)

% --- Executes on button press in LoadNext.
function LoadNext_Callback(hObject, eventdata, handles)
% hObject    handle to LoadNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
mainHandles=guidata(handles.mainObject);

handles.current_ROI = mod(handles.current_ROI,length(mainHandles.ROIs))+1;
handles.in_ROI = ((mainHandles.fXpos>mainHandles.ROIs{handles.current_ROI}(1))&(mainHandles.fXpos<(mainHandles.ROIs{handles.current_ROI}(1)+mainHandles.ROIs{handles.current_ROI}(3))))&((mainHandles.fYpos>mainHandles.ROIs{handles.current_ROI}(2))&(mainHandles.fYpos<(mainHandles.ROIs{handles.current_ROI}(2)+mainHandles.ROIs{handles.current_ROI}(4))));

DisplayText = [num2str(handles.current_ROI),'/',num2str(length(mainHandles.ROIs))];
set(handles.CurrentROIID,'string',DisplayText)

handles.WinArea=mainHandles.ROIs{handles.current_ROI}(3)*mainHandles.ROIs{handles.current_ROI}(4);
guidata(hObject,handles)
GraphUpdateCode(hObject,eventdata,handles)
