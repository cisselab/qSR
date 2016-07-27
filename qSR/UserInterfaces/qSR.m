function varargout = qSR(varargin)
% QSR MATLAB code for qSR.fig
%      QSR, by itself, creates a new QSR or raises the existing
%      singleton*.
%
%      H = QSR returns the handle to a new QSR or the handle to
%      the existing singleton*.
%
%      QSR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QSR.M with the given input arguments.
%
%      QSR('Property','Value',...) creates a new QSR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before qSR_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to qSR_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help qSR

% Last Modified by GUIDE v2.5 26-Jul-2016 15:05:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @qSR_OpeningFcn, ...
                   'gui_OutputFcn',  @qSR_OutputFcn, ...
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

% --- Executes just before qSR is made visible.
function qSR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qSR (see VARARGIN)

% Choose default command line output for qSR
handles.output = hObject;
handles.ROIs={};
handles.which_filter='raw';
handles.filetype='SRL';
handles.valid_sp_clusters=false;
handles.valid_st_clusters=false;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = qSR_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --------- Box 1: Getting Started --------------------- %

% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Load Data
[filename,dirName]=uigetfile('*.*','Select the Cell Data');
handles.filename = filename;
handles.directory = dirName;

[Frames,XposRaw,YposRaw,Intensity]=ReadDataFile([dirName,filename],handles.filetype,hObject,handles);

%% Initialize Variables and Update Handles
% handles.filter = true(1,length(Frames)); %Initialize for later use.
% handles.fitParams = [0,0,0]; %Initialize Variables
% handles.NuclearArea = 1;
% handles.FreehandROI = [];
% handles.InNucleus=true(1,length(Frames));
% handles.MinClusterSize=2;
% handles.ClusterIDs = zeros(1,length(Frames),'uint16');
% handles.HaveLoadedAnnotation = false;

handles.XposRaw=XposRaw;
handles.YposRaw=YposRaw;
handles.Frames=Frames;
handles.Intensity=Intensity;
guidata(hObject, handles);

AdjustPixelSize(hObject,eventdata,handles)

% --- Executes on button press in filetype_SRL.
function filetype_SRL_Callback(hObject, eventdata, handles)
% hObject    handle to filetype_SRL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filetype_SRL

handles.filetype='SRL';
guidata(hObject,handles)

% --- Executes on button press in filetype_Quick.
function filetype_Quick_Callback(hObject, eventdata, handles)
% hObject    handle to filetype_Quick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filetype_Quick

handles.filetype='QuickPALM';
guidata(hObject,handles)

% --- Executes on button press in filetype_Thunder.
function filetype_Thunder_Callback(hObject, eventdata, handles)
% hObject    handle to filetype_Thunder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filetype_Thunder

handles.filetype='ThunderSTORM';
guidata(hObject,handles)

function pixel_size_Callback(hObject, eventdata, handles)
% hObject    handle to pixel_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixel_size as text
%        str2double(get(hObject,'String')) returns contents of pixel_size as a double

pixel_size = str2num(get(handles.pixel_size,'String'));
if isempty(pixel_size)
    set(handles.pixel_size,'String',160)
    guidata(hObject,handles)
end
AdjustPixelSize(hObject,eventdata,handles)

% --- Executes on button press in LoadWorkSpace.
function LoadWorkSpace_Callback(hObject, eventdata, handles)
% hObject    handle to LoadWorkSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'directory')
    current_directory=cd;
    cd(handles.directory)
    filename=uigetfile;
    if ischar(filename)
        handles=load(filename);
        guidata(hObject,handles)
    end
    cd(current_directory)
else
    
end

% --- Executes on button press in SaveWorkSpace.
function SaveWorkSpace_Callback(hObject, eventdata, handles)
% hObject    handle to SaveWorkSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'directory')
    current_directory=cd;
    cd(handles.directory)
    filename=uiputfile;
    if ischar(filename)
        save(filename,'handles')
    end
    cd(current_directory)
else
end






% --------- Box 2: PreProcess / Filter Data  ----------- %

% --- Executes on button press in SelectNucleus.
function SelectNucleus_Callback(hObject, eventdata, handles)
% hObject    handle to SelectNucleus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XposRaw')
    figure
    PlotPointillist(hObject,handles)

    FreehandROIhandle = imfreehand; %Allows the user to draw a boundary for the nucleus
    handles.FreehandROI = getPosition(FreehandROIhandle); %Returns an ordered list of the x and y coordinates that defines the boundary.
    px_size=str2num(get(handles.pixel_size,'String'));
    handles.FreehandROIpx=handles.FreehandROI/px_size;

    handles.NuclearArea = polyarea(handles.FreehandROI(:,1),handles.FreehandROI(:,2));

    InNucleus = inpolygon(handles.Xposnm,handles.Yposnm,handles.FreehandROI(:,1),handles.FreehandROI(:,2));

    Times=1:max(handles.Frames);
    Counts = zeros(1,length(Times));
    for i = Times
        Counts(i)=sum(handles.Frames(InNucleus)==i);
    end
    CumulativeCounts = cumsum(Counts);

    modelfnhandle = @(params,x)(params(1)*(1-exp(-x/params(2)))+params(3)*x); %Assumes an exonential decay of detection rate, and a constant false positive rate
    fitParams = nlinfit(Times,CumulativeCounts,modelfnhandle,[length(handles.Frames),0.5,0]);

    figure
    plot(Times,modelfnhandle(fitParams,Times),'c')
    hold on
    plot(Times,CumulativeCounts,'r')
    xlabel('Time (Frames)')
    ylabel('Cumulative Localizations')
    legend('Fit Data','Raw Data')
    drawnow

    handles.fitParams = fitParams;
    guidata(hObject, handles);

    SetfPosVectors(hObject,eventdata,handles)
else
    msgbox('You must first load data!')
end

% --- Executes on button press in RestrictToNuclear.
function RestrictToNuclear_Callback(hObject, eventdata, handles)
% hObject    handle to RestrictToNuclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RestrictToNuclear

if isfield(handles,'RestrictToNuclear')
    if get(handles.RestrictToNuclear,'Value')
        if isfield(handles,'FreehandROI')
            SetfPosVectors(hObject,eventdata,handles)
        else
            msgbox('You must first select the Nucleus!')
        end
    end
end

% --- Executes on button press in RawData.
function RawData_Callback(hObject, eventdata, handles)
% hObject    handle to RawData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RawData

handles.which_filter = 'raw';
guidata(hObject,handles)
SetfPosVectors(hObject,eventdata,handles)

% --- Executes on button press in IsolationFilter.
function IsolationFilter_Callback(hObject, eventdata, handles)
% hObject    handle to IsolationFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IsolationFilter

handles.which_filter = 'iso';
guidata(hObject,handles)
SetfPosVectors(hObject,eventdata,handles)
    
function IsoLengthScale_Callback(hObject, eventdata, handles)
% hObject    handle to IsoLengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IsoLengthScale as text
%        str2double(get(hObject,'String')) returns contents of IsoLengthScale as a double

switch handles.which_filter
    case 'iso'
        SetfPosVectors(hObject,eventdata,handles)
    otherwise
end

% --- Executes on button press in QuickMerge.
function QuickMerge_Callback(hObject, eventdata, handles)
% hObject    handle to QuickMerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of QuickMerge

handles.which_filter = 'quick';
guidata(hObject,handles)
SetfPosVectors(hObject,eventdata,handles)

function QuickMergeLengthScale_Callback(hObject, eventdata, handles)
% hObject    handle to QuickMergeLengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QuickMergeLengthScale as text
%        str2double(get(hObject,'String')) returns contents of QuickMergeLengthScale as a double

switch handles.which_filter
    case 'quick'
        SetfPosVectors(hObject,eventdata,handles)
    otherwise
end

function DarkTimeTolerance_Callback(hObject, eventdata, handles)
% hObject    handle to DarkTimeTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DarkTimeTolerance as text
%        str2double(get(hObject,'String')) returns contents of DarkTimeTolerance as a double

switch handles.which_filter
    case 'quick'
        SetfPosVectors(hObject,eventdata,handles)
    otherwise
end

function QuickMergeMinPoints_Callback(hObject, eventdata, handles)
% hObject    handle to QuickMergeMinPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QuickMergeMinPoints as text
%        str2double(get(hObject,'String')) returns contents of QuickMergeMinPoints as a double

switch handles.which_filter
    case 'quick'
        SetfPosVectors(hObject,eventdata,handles)
    otherwise
end






% --------- Box 3: Visualize Data ---------------------- %

% --- Executes on button press in PlotPointillist.
function PlotPointillist_Callback(hObject, eventdata, handles)
% hObject    handle to PlotPointillist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'pointillist_handle')
    if ishandle(handles.pointillist_handle)
        figure(handles.pointillist_handle)
    else
        handles.pointillist_handle = figure;
        guidata(hObject, handles);
    end
    
else
    handles.pointillist_handle = figure;
    guidata(hObject, handles);
end

PlotPointillist(hObject,handles)
%pointillist([handles.fXpos;handles.fYpos])

% --- Executes on button press in time_color.
function time_color_Callback(hObject, eventdata, handles)
% hObject    handle to time_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of time_color

% --- Executes on button press in plot_clusters.
function plot_clusters_Callback(hObject, eventdata, handles)
% hObject    handle to plot_clusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_clusters

% --- Executes on button press in PlotROIS.
function PlotROIS_Callback(hObject, eventdata, handles)
% hObject    handle to PlotROIS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotROIS

% --- Executes on button press in Render.
function Render_Callback(hObject, eventdata, handles)
% hObject    handle to Render (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if isfield(handles,'XposRaw')
        Xmin = min(handles.fXpos);Xmax=max(handles.fXpos);Ymin=min(handles.fYpos);Ymax=max(handles.fYpos);
        NumPixels = str2num(get(handles.NumPixels,'String'));
        sigma_render = str2num(get(handles.RenderingPrecision,'String'));

        dx=(Xmax-Xmin)/(NumPixels-1);
        dy=(Ymax-Ymin)/(NumPixels-1);
        Edges{1}=Xmin:dx:Xmax;
        Edges{2}=Ymin:dy:Ymax;

        Im = hist3([handles.fXpos',handles.fYpos'],'Edges',Edges);

        TempX=-round(3*sigma_render/dx)*dx:dx:round(3*sigma_render/dx)*dx;
        TempY=-round(3*sigma_render/dy)*dy:dy:round(3*sigma_render/dy)*dy;

        ConVecX = exp(-0.5*(TempX/sigma_render).^2); 
        ConVecY = exp(-0.5*(TempY/sigma_render).^2);
        Im2 = conv2(ConVecX,ConVecY,Im);
        Im2=Im2/max(max(Im2));
        Im2=Im2(:,end:-1:1)';


        extra_pixels=(size(Im2)-size(Im))/2;

        Im2=Im2((extra_pixels(1)+1):(end-extra_pixels(1)),(extra_pixels(2)+1):(end-extra_pixels(2)));

        figure
        imshow(Im2);
        colormap(hot)
        imcontrast(gca)
    else
        msgbox('You must first load data!')
    end

function NumPixels_Callback(hObject, eventdata, handles)
% hObject    handle to NumPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumPixels as text
%        str2double(get(hObject,'String')) returns contents of NumPixels as a double

function RenderingPrecision_Callback(hObject, eventdata, handles)
% hObject    handle to RenderingPrecision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RenderingPrecision as text
%        str2double(get(hObject,'String')) returns contents of RenderingPrecision as a double






% --------- Box 4: Spatial Clustering Tools ------------ %

% --- Executes on button press in PairCorrelation.
function PairCorrelation_Callback(hObject, eventdata, handles)
% hObject    handle to PairCorrelation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XposRaw')
    PairCorrelation(hObject)
else
    msgbox('You must first load data!')
end

% --- Executes on button press in DBSCAN.
function DBSCAN_Callback(hObject, eventdata, handles)
% hObject    handle to DBSCAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XposRaw')
    DBSCANgui(hObject,handles)
else
    msgbox('You must first load data!')
end

% --- Executes on button press in BioJets.
function BioJets_Callback(hObject, eventdata, handles)
% hObject    handle to BioJets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XposRaw')
    HierarchicalClustering(hObject)
else
    msgbox('You must first load data!')
end

% --- Executes on button press in ManualROI.
function ManualROI_Callback(hObject, eventdata, handles)
% hObject    handle to ManualROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XposRaw')
    set(handles.PlotROIS,'Value',1)
    guidata(hObject,handles)
    PlotPointillist_Callback(hObject, eventdata, handles)
    rectangle = imrect;
    rectangleCorners = getPosition(rectangle);
    handles.ROIs{end+1}=rectangleCorners;
    guidata(hObject,handles)
else
    msgbox('You must first load data!')
end

% --- Executes on button press in ImmediateROITimeTrace.
function ImmediateROITimeTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ImmediateROITimeTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ImmediateROITimeTrace

% --- Executes on button press in ClearROIs.
function ClearROIs_Callback(hObject, eventdata, handles)
% hObject    handle to ClearROIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XPosRaw')
    if isfield(handles,'ROIs')
        if isempty(handles.ROIs)
            msgbox('No ROIs Selected!')
        else
            set(handles.PlotROIS,'Value',1)
            guidata(hObject,handles)
            PlotPointillist_Callback(hObject, eventdata, handles)
            rectangle = imrect;
            rectangleCorners = getPosition(rectangle);
            delete_indices = ROIsInBox(handles.ROIs,rectangleCorners);
            handles.ROIs(delete_indices)=[];
            guidata(hObject,handles)
            hold off
            PlotPointillist_Callback(hObject, eventdata, handles)
        end
    else
        msgbox('No ROIs Selected!')
    end
else
    msgbox('You must first load data!')
end

% --------- Box 5: Post Processing Tools --------------- %

% --- Executes on button press in SpatialSumStat.
function SpatialSumStat_Callback(hObject, eventdata, handles)
% hObject    handle to SpatialSumStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.valid_sp_clusters
    statistics=EvaluateSpatialSummaryStatistics(handles.fXpos,handles.fYpos,handles.sp_clusters);
    display('This will break if I change filters after finding the clusters')
    [area_counts,area_bins]=hist([statistics(:).c_hull_area],20);
    [size_counts,size_bins]=hist([statistics(:).cluster_size],20);
    
    figure
    plot(area_bins,area_counts/sum(area_counts))
    xlabel('Cluster Area')
    ylabel('Frequency')
    figure
    plot(size_bins,size_counts/sum(size_counts))
    xlabel('Number of Localizations per Cluster')
    ylabel('Frequency')
    
    figure
    semilogy(area_bins,area_counts/sum(area_counts))
    xlabel('Cluster Area')
    ylabel('Frequency')
    figure
    semilogy(size_bins,size_counts/sum(size_counts))
    xlabel('Number of Localizations per Cluster')
    ylabel('Frequency')
    
    handles.sp_statistics=statistics;
    guidata(hObject,handles)
else
    msgbox('You must first select clusters!')
end

% --- Executes on button press in SaveSpatSumStat.
function SaveSpatSumStat_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSpatSumStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    if handles.valid_sp_clusters;
        test_name = [handles.directory,'spatialstats.csv'];
        n=1;
        while exist(test_name,'file')
            n=n+1;
            test_name = [handles.directory,'spatialstats',num2str(n),'.csv'];
        end
        ExportClusterStatistics(handles.sp_statistics,test_name)
        
        filter_status_filename = [handles.directory,'filter_status_for_spatialstats',num2str(n),'.txt'];
        SaveFilterStatus(hObject,handles,filter_status_filename)
        
        fData_filename = [handles.directory,'filtered_data_for_spatial',num2str(n),'.csv'];
        csvwrite(fData_filename,[handles.fFrames;handles.fXpos;handles.fYpos;handles.fIntensity])
        
        cluster_param_file_path=[handles.directory,'spatial_clustering_parameters',num2str(n),'.txt'];
        SaveClusteringParameters(hObject,handles,cluster_param_file_path)

        sp_cluster_filename = [handles.directory,'sp_clusters',num2str(n),'.csv'];
        csvwrite(sp_cluster_filename,handles.sp_clusters);

    else
        msgbox('No Valid Spatial Cluster Statistics')
    end

% --- Executes on button press in ManualTempCluster.
function ManualTempCluster_Callback(hObject, eventdata, handles)
% hObject    handle to ManualTempCluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XPosRaw')
    if isfield(handles,'ROIs')
        if isempty(handles.ROIs)
            msgbox('No ROIs Selected!')
        else
            ManualTemporalClustering(hObject)
        end
    else
        msgbox('No ROIs Selected!')
    end
else
    msgbox('You must first load data!')
end

% --- Executes on button press in AutoTempClust.
function AutoTempClust_Callback(hObject, eventdata, handles)
% hObject    handle to AutoTempClust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


dark_time_tolerance=inputdlg('Specify the Dark Time Tolerance (in Frames)');
if isempty(dark_time_tolerance)
else
    dark_time_tolerance=str2num(dark_time_tolerance{1});
    while isempty(dark_time_tolerance)
        dark_time_tolerance=inputdlg('Invalid Input: Specify the Dark Time Tolerance (in Frames)');
        if isempty(dark_time_tolerance)
            break
        else
            dark_time_tolerance=str2num(dark_time_tolerance{1});
        end
    end
end

if isempty(dark_time_tolerance)
else
    if isfield(handles,'sp_clusters')
        if length(handles.sp_clusters)==length(handles.fFrames);
            handles.st_clusters=NaiveTemporalClustering(handles.fFrames,handles.sp_clusters,dark_time_tolerance);
            handles.valid_st_clusters=true;
            guidata(hObject,handles)
        else
            if isfield(handles,'ROIs')
                if isempty(handles.ROIs)
                    msgbox('You must first select clusters or ROIs!!!')
                else
                    sp_clusters=ClustersFromROIs(handles.fXpos,handles.fYpos,handles.ROIs);
                    handles.st_clusters=NaiveTemporalClustering(handles.fFrames,sp_clusters,dark_time_tolerance);
                    handles.valid_st_clusters=true;
                    guidata(hObject,handles)
                end
            else
                msgbox('You must first select clusters or ROIs!!!')
            end
        end
    else
        if isfield(handles,'ROIs')
            if isempty(handles.ROIs)
                msgbox('You must first select clusters or ROIs!!!')
            else
                sp_clusters=ClustersFromROIs(handles.fXpos,handles.fYpos,handles.ROIs);
                handles.st_clusters=NaiveTemporalClustering(handles.fFrames,sp_clusters,dark_time_tolerance);
                handles.valid_st_clusters=true;
                guidata(hObject,handles)
            end
        else
            msgbox('You must first select clusters or ROIs!!!')
        end
    end
end

% --- Executes on button press in TempSumStat.
function TempSumStat_Callback(hObject, eventdata, handles)
% hObject    handle to TempSumStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.valid_st_clusters
    statistics=EvaluateTemporalSummaryStatistics(handles.fFrames,handles.fXpos,handles.fYpos,handles.st_clusters);
    display('This will break if I change filters after finding the clusters')
    [area_counts,area_bins]=hist([statistics(:).c_hull_area],20);
    [size_counts,size_bins]=hist([statistics(:).cluster_size],20);
    [duration_counts,duration_bins]=hist([statistics(:).duration],20);
    
    figure
    plot(duration_bins,duration_counts/sum(duration_counts))
    xlabel('Cluster Duration')
    ylabel('Frequency')
    figure
    semilogy(duration_bins,duration_counts/sum(duration_counts))
    xlabel('Cluster Duration')
    ylabel('Frequency')
    
    figure
    plot(area_bins,area_counts/sum(area_counts))
    xlabel('Cluster Area')
    ylabel('Frequency')
    figure
    plot(size_bins,size_counts/sum(size_counts))
    xlabel('Number of Localizations per Cluster')
    ylabel('Frequency')
    
    figure
    semilogy(area_bins,area_counts/sum(area_counts))
    xlabel('Cluster Area')
    ylabel('Frequency')
    figure
    semilogy(size_bins,size_counts/sum(size_counts))
    xlabel('Number of Localizations per Cluster')
    ylabel('Frequency')
    
    handles.st_statistics=statistics;
    guidata(hObject,handles)
else
    msgbox('You must first select clusters!')
end

% --- Executes on button press in SaveTempSumStat.
function SaveTempSumStat_Callback(hObject, eventdata, handles)
% hObject    handle to SaveTempSumStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    msgbox('Save st_clusters')

    if handles.valid_st_clusters;
        test_name = [handles.directory,'temporalstats.csv'];
        n=1;
        while exist(test_name,'file')
            n=n+1;
            test_name = [handles.directory,'temporalstats',num2str(n),'.csv'];
        end
        ExportClusterStatistics(handles.st_statistics,test_name)
        
        filter_status_filename = [handles.directory,'filter_status_for_temporalstats',num2str(n),'.txt'];
        SaveFilterStatus(hObject,handles,filter_status_filename)
        
        fData_filename = [handles.directory,'filtered_data_for_temporal',num2str(n),'.csv'];
        csvwrite(fData_filename,[handles.fFrames;handles.fXpos;handles.fYpos;handles.fIntensity])
        
        st_cluster_filename = [handles.directory,'st_clusters',num2str(n),'.csv'];
        csvwrite(st_cluster_filename,handles.st_clusters);
    else
        msgbox('No Valid Temporal Cluster Statistics')
    end





    
% --------- Auxiliary Functions ------------------------ %

function [Times,Xpos,Ypos,Intensity]=ReadDataFile(filename,filetype,hObject,handles)
    %Opens a .csv file containing a list of localizations and creates Matlab
    %variables labeling the Time, Xposition and Yposition of each
    %localization. The .csv file is assumed to contain one row per
    %localization with the first column representing the time, the second
    %column representing the X position, and the third column representing
    %the Y position. The first row of the file is assumed to be labels for
    %the columns. 
    
    if ~isempty(strfind(filename((end-31):end),'MTT_without_tracking_results.mat')) %Output from MTT Software
        load(filename)
        Times = matrice_results(1,:);
        Xpos = matrice_results(2,:);
        Ypos = matrice_results(3,:);
        Intensity=matrice_results(4,:);
    elseif ~isempty(strfind(filename((end-6):end),'SRL.csv'))
        FileContents=csvread(filename,1,0); 
        Times = FileContents(:,1)';
        Xpos=FileContents(:,2)';
        Ypos=FileContents(:,3)';
        Intensity=FileContents(:,4)';
    else
        switch filetype
            case 'SRL'
                FileContents=csvread(filename,1,0); 
                Times = FileContents(:,1)';
                Xpos=FileContents(:,2)';
                Ypos=FileContents(:,3)';
                Intensity=FileContents(:,4)';
            case 'QuickPALM'
                FileContents=dlmread(filename,'\t',1,0); 
                Times = FileContents(:,15)';
                Xpos=FileContents(:,3)';
                Ypos=FileContents(:,4)';
                Intensity=FileContents(:,2)';
            case 'ThunderSTORM'
                FileContents=csvread(filename,1,0); 
                Times = FileContents(:,1)';
                Xpos=FileContents(:,2)';
                Ypos=FileContents(:,3)';
                Intensity=FileContents(:,5)';
                msgbox('ThunderSTORM output is in units of nanometers, not pixels. "Pixel Size" set to 1.')
                set(handles.pixel_size,'String',1)
                guidata(hObject,handles)
        end
    end

function AdjustPixelSize(hObject,eventdata,handles)
    % Adjusts the vectors containing the raw x and y positions in units of
    % nanometers (Xposnm and Yposnm) using the raw x and y positions in
    % units of pixels (XposRaw and YposRaw) and the pixel size stated in
    % the Getting Started box.
    
    if isfield(handles,'XposRaw')
        pixel_size = str2num(get(handles.pixel_size,'String'));
        handles.Xposnm = handles.XposRaw*pixel_size;
        handles.Yposnm = handles.YposRaw*pixel_size;

        if isfield(handles,'FreehandROI')
            handles.FreehandROI=handles.FreehandROIpx*pixel_size;
        end

        guidata(hObject, handles);

        SetfPosVectors(hObject,eventdata,handles)
    else
        msgbox('You must first load data!')
    end
        
function SetfPosVectors(hObject,eventdata,handles)
    % Checks for what type of filter should be applied from the
    % pre-process / filter data box and adjusts the filtered positions
    % (fXpos and fYpos) accordingly.
    
    if isfield(handles,'XposRaw')
        handles.valid_sp_clusters=false;
        handles.valid_st_clusters=false;

        if isfield(handles,'RestrictToNuclear')
            if get(handles.RestrictToNuclear,'Value')
                InNucleus = inpolygon(handles.Xposnm,handles.Yposnm,handles.FreehandROI(:,1),handles.FreehandROI(:,2));
            else
                InNucleus=true(size(handles.Frames));
            end
        else
            InNucleus=true(size(handles.Frames));
        end

        if isfield(handles,'which_filter')
            switch handles.which_filter
                case 'raw'

                    handles.fXpos = handles.Xposnm(InNucleus);
                    handles.fYpos = handles.Yposnm(InNucleus);
                    handles.fFrames = handles.Frames(InNucleus);
                    handles.fIntensity = handles.Intensity(InNucleus);
                    guidata(hObject, handles);
                case 'iso'
                    %Add progress bar
                    display('Add Progress Bar')

                    threshold = str2num(get(handles.IsoLengthScale,'String'));
                    handles.isolated = IsolatedDetectionFilter(handles.Frames,handles.Xposnm,handles.Yposnm,threshold);
                    relevent_pts=and(InNucleus,~handles.isolated);
                    handles.fXpos = handles.Xposnm(relevent_pts);
                    handles.fYpos = handles.Yposnm(relevent_pts);
                    handles.fFrames = handles.Frames(relevent_pts);
                    handles.fIntensity=handles.Intensity(relevent_pts);
                    guidata(hObject,handles)
    %             case 'continuous'
    %                 
    %                 display('Continuous Merge not installed')
    %                 handles.fXpos = handles.Xposnm;
    %                 handles.fYpos = handles.Yposnm;
    %                 handles.fFrames = handles.Frames;
    %                 guidata(hObject, handles);
                case 'quick'
                    sigma = str2num(get(handles.QuickMergeLengthScale,'String'));
                    dark_time = str2num(get(handles.DarkTimeTolerance,'String')); 
                    min_points = str2num(get(handles.QuickMergeMinPoints,'String'));
                    handles.st_ids=QuickMerge(handles.Frames(InNucleus),handles.Xposnm(InNucleus),handles.Yposnm(InNucleus),sigma,dark_time);
                    [frameCentroid,xCentroid,yCentroid,totalIntensity]=QuickMergeCentroids(handles.Frames(InNucleus),handles.Xposnm(InNucleus),handles.Yposnm(InNucleus),handles.Intensity(InNucleus),handles.st_ids,min_points);
                    handles.fXpos = xCentroid;
                    handles.fYpos = yCentroid;
                    handles.fFrames = frameCentroid;
                    handles.fIntensity=totalIntensity;
                    guidata(hObject,handles);
            end
        else
            handles.which_filter='raw';
            guidata(hObject,handles)
            handles.fXpos = handles.Xposnm(InNucleus);
            handles.fYpos = handles.Yposnm(InNucleus);
            handles.fFrames = handles.Frames(InNucleus);
            handles.fIntensity = handles.Intensity(InNucleus);
            guidata(hObject, handles);
        end
    else
        msgbox('You must first load data!')
    end
   
function PlotPointillist(hObject,handles)
    
    if isfield(handles,'XposRaw')
        time_color=get(handles.time_color,'Value');
        show_clusters = get(handles.plot_clusters,'Value');
        show_ROIs = get(handles.PlotROIS,'Value');

        hold off
        plot(handles.fXpos,handles.fYpos,'.k','markersize',4)
        hold on

        if time_color
            if show_clusters
                if isfield(handles,'sp_clusters')
                    if length(handles.sp_clusters)==length(handles.fXpos)
                        plot_indices=handles.sp_clusters>0;
                    else
                        plot_indices=true(size(handles.fFrames));
                    end
                else
                    plot_indices=true(size(handles.fFrames));
                end

            else
                plot_indices=true(size(handles.fFrames));
            end
            colormat = [1-handles.fFrames(plot_indices)'/max(handles.fFrames(plot_indices)),zeros(sum(plot_indices),1),handles.fFrames(plot_indices)'/max(handles.fFrames(plot_indices))];
            scatter(handles.fXpos(plot_indices),handles.fYpos(plot_indices),4,colormat)
        else
            if show_clusters
                if isfield(handles,'sp_clusters')
                    if length(handles.sp_clusters)==length(handles.fXpos)
                        K=max(handles.sp_clusters);
                        for k = 1:K
                            Color = [k/K,rand,1-k/K];
                            plot(handles.fXpos(handles.sp_clusters==k),handles.fYpos(handles.sp_clusters==k),'.','MarkerFaceColor',Color,...
                                'Color',Color)
                        end
                    end
                end
            else
            end
        end

        if show_ROIs
            if isfield(handles,'ROIs')
                if ~isempty(handles.ROIs)
                    for i = 1:length(handles.ROIs)
                        x=[handles.ROIs{i}(1),handles.ROIs{i}(1)+handles.ROIs{i}(3),handles.ROIs{i}(1)+handles.ROIs{i}(3),handles.ROIs{i}(1),handles.ROIs{i}(1)];
                        y=[handles.ROIs{i}(2),handles.ROIs{i}(2),handles.ROIs{i}(2)+handles.ROIs{i}(4),handles.ROIs{i}(2)+handles.ROIs{i}(4),handles.ROIs{i}(2)];
                        plot(x,y,'-r')
                    end
                end
            end
        end
    else
        msgbox('You must first load data!')
    end
     
function sp_clusters=ClustersFromROIs(Xpos,Ypos,ROIs)
    sp_clusters=zeros(size(Xpos));
    for i = 1:length(ROIs)
        rectangleCorners=ROIs{i};
        AlreadyAnalyzed = sp_clusters~=0;
        inROI = and(~AlreadyAnalyzed,((Xpos>rectangleCorners(1))&(Xpos<(rectangleCorners(1)+rectangleCorners(3))))&((Ypos>rectangleCorners(2))&(Ypos<(rectangleCorners(2)+rectangleCorners(4)))));
        sp_clusters(inROI)=i;
    end
     
    
    
    
    
    
% --------- Create Functions --------------------------- %    
    
% --- Executes during object creation, after setting all properties.
function pixel_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixel_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function IsoLengthScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IsoLengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ContinuousMergeLengthScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ContinuousMergeLengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function QuickMergeLengthScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QuickMergeLengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function DarkTimeTolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DarkTimeTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function QuickMergeMinPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QuickMergeMinPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NumPixels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function RenderingPrecision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RenderingPrecision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


