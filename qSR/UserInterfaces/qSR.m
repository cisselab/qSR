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

% Last Modified by GUIDE v2.5 03-Aug-2016 13:06:00

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

handles.InitialHandles=handles;

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

if filename ~= 0
    
    handles=handles.InitialHandles;
    handles.InitialHandles=handles;
    set(handles.RestrictToNuclear,'value',0)
    set(handles.RawData,'value',1)
    
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

    handles=AdjustPixelSize(hObject,eventdata,handles);
    
    set(handles.FileDisplay,'String',['Data File: ',handles.directory,handles.filename])
    guidata(hObject,handles)
end

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
    msgbox('Invalid pixel size')
    set(handles.pixel_size,'String',160)
    guidata(hObject,handles)
elseif pixel_size <=0
    msgbox('Pixel size must be a positive number!')
    set(handles.pixel_size,'String',160)
    guidata(hObject,handles)
end
handles=AdjustPixelSize(hObject,eventdata,handles);
guidata(hObject,handles)

% --- Executes on button press in LoadWorkSpace.
function LoadWorkSpace_Callback(hObject, eventdata, handles)
% hObject    handle to LoadWorkSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_handle=gcf;

filename=uigetfile;
if ischar(filename)
    handles=load(filename);
    guidata(hObject,handles)
    close(gui_handle)
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
    
    handles=PlotPointillist(hObject,handles);
    guidata(hObject,handles)

    try 
        FreehandROIhandle = imfreehand; %Allows the user to draw a boundary for the nucleus
        FreehandROI = getPosition(FreehandROIhandle); %Returns an ordered list of the x and y coordinates that defines the boundary.
    end
    
    if exist('FreehandROI','var')
        handles.FreehandROI=FreehandROI;
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
        
        set(handles.RestrictToNuclear,'value',1)
        
        guidata(hObject, handles);

        handles = SetfPosVectors(hObject,eventdata,handles);
        guidata(hObject,handles)
        
        handles=PlotPointillist(hObject,handles);
        guidata(hObject,handles)
        
    else
        msgbox('Window closed before the user selected a nucleus!')
    end
  
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
            handles = SetfPosVectors(hObject,eventdata,handles);
            guidata(hObject,handles)
        else
            set(handles.RestrictToNuclear,'value',0)
            guidata(hObject,handles)
            msgbox('You must first select the Nucleus!')
        end
    else
        handles = SetfPosVectors(hObject,eventdata,handles);
        guidata(hObject,handles)
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
handles=SetfPosVectors(hObject,eventdata,handles);
guidata(hObject,handles)

% --- Executes on button press in IsolationFilter.
function IsolationFilter_Callback(hObject, eventdata, handles)
% hObject    handle to IsolationFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IsolationFilter

handles.which_filter = 'iso';
guidata(hObject,handles)
handles=SetfPosVectors(hObject,eventdata,handles);
guidata(hObject,handles)
    
function IsoLengthScale_Callback(hObject, eventdata, handles)
% hObject    handle to IsoLengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IsoLengthScale as text
%        str2double(get(hObject,'String')) returns contents of IsoLengthScale as a double

length_scale = str2num(get(handles.IsoLengthScale,'String'));
if isempty(length_scale)
    msgbox('Invalid length scale!')
    set(handles.IsoLengthScale,'String',160)
    guidata(hObject,handles)
elseif length_scale <=0
    msgbox('Length scale must be a positive number!')
    set(handles.IsoLengthScale,'String',160)
    guidata(hObject,handles)
else
    switch handles.which_filter
        case 'iso'
            handles=SetfPosVectors(hObject,eventdata,handles);
            guidata(hObject,handles)
        otherwise
    end
end

% --- Executes on button press in QuickMerge.
function QuickMerge_Callback(hObject, eventdata, handles)
% hObject    handle to QuickMerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of QuickMerge

handles.which_filter = 'quick';
guidata(hObject,handles)
handles = SetfPosVectors(hObject,eventdata,handles);
guidata(hObject,handles)

function QuickMergeLengthScale_Callback(hObject, eventdata, handles)
% hObject    handle to QuickMergeLengthScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QuickMergeLengthScale as text
%        str2double(get(hObject,'String')) returns contents of QuickMergeLengthScale as a double

length_scale = str2num(get(handles.QuickMergeLengthScale,'String'));
if isempty(length_scale)
    msgbox('Invalid length scale!')
    set(handles.QuickMergeLengthScale,'String',40)
    guidata(hObject,handles)
elseif length_scale <=0
    msgbox('Length scale must be a positive number!')
    set(handles.QuickMergeLengthScale,'String',40)
    guidata(hObject,handles)
else
    switch handles.which_filter
        case 'quick'
            handles=SetfPosVectors(hObject,eventdata,handles);
            guidata(hObject,handles)
        otherwise
    end
end

function DarkTimeTolerance_Callback(hObject, eventdata, handles)
% hObject    handle to DarkTimeTolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DarkTimeTolerance as text
%        str2double(get(hObject,'String')) returns contents of DarkTimeTolerance as a double

dark_tolerance = str2num(get(handles.DarkTimeTolerance,'String'));
if isempty(dark_tolerance)
    msgbox('Invalid Input!')
    set(handles.DarkTimeTolerance,'String',1)
    guidata(hObject,handles)
elseif dark_tolerance <=0
    msgbox('Tolerance should be a positive integer!')
    set(handles.DarkTimeTolerance,'String',1)
    guidata(hObject,handles)
else
    switch handles.which_filter
        case 'quick'
            handles=SetfPosVectors(hObject,eventdata,handles);
            guidata(hObject,handles)
        otherwise
    end
end

function QuickMergeMinPoints_Callback(hObject, eventdata, handles)
% hObject    handle to QuickMergeMinPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QuickMergeMinPoints as text
%        str2double(get(hObject,'String')) returns contents of QuickMergeMinPoints as a double

min_pts = str2num(get(handles.QuickMergeMinPoints,'String'));
if isempty(min_pts)
    msgbox('Invalid Input!')
    set(handles.QuickMergeMinPoints,'String',1)
    guidata(hObject,handles)
elseif min_pts <=0
    msgbox('The minimum points should be a positive integer!')
    set(handles.QuickMergeMinPoints,'String',1)
    guidata(hObject,handles)
else
    switch handles.which_filter
        case 'quick'
            handles=SetfPosVectors(hObject,eventdata,handles);
            guidata(hObject,handles)
        otherwise
    end
end








% --------- Box 3: Visualize Data ---------------------- %

% --- Executes on button press in PlotPointillist.
function PlotPointillist_Callback(hObject, eventdata, handles)
% hObject    handle to PlotPointillist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = PlotPointillist(hObject,handles);
guidata(hObject,handles)
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

num_pixels = str2num(get(handles.NumPixels,'String'));
if isempty(num_pixels)
    msgbox('Invalid Input!')
    set(handles.NumPixels,'String',1080)
    guidata(hObject,handles)
elseif num_pixels <=0
    msgbox('The number of pixels should be a positive integer!')
    set(handles.NumPixels,'String',1080)
    guidata(hObject,handles)
end

function RenderingPrecision_Callback(hObject, eventdata, handles)
% hObject    handle to RenderingPrecision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RenderingPrecision as text
%        str2double(get(hObject,'String')) returns contents of RenderingPrecision as a double

precision = str2num(get(handles.RenderingPrecision,'String'));
if isempty(precision)
    msgbox('Invalid Input!')
    set(handles.RenderingPrecision,'String',50)
    guidata(hObject,handles)
elseif precision <=0
    msgbox('The precision should be a positive number!')
    set(handles.RenderingPrecision,'String',50)
    guidata(hObject,handles)
end




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

% --- Executes on button press in ManualTempCluster.
function ManualTempCluster_Callback(hObject, eventdata, handles)
% hObject    handle to ManualTempCluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'XposRaw')
    if strcmp(handles.which_filter,'raw')
        TemporalClustering(hObject)
    else
        prompt='Temporal Analysis of ROIs is typically performed on Raw, Unfiltered Data. Change the filter status to raw? [Y/N]';
        str = inputdlg(prompt,'s');
        if isempty(str)
            msgbox('Invalid input')
        else
            switch lower(str{1})
                case {'y','yes'}
                    set(handles.RawData,'value',1)
                    handles.which_filter = 'raw';
                    guidata(hObject,handles)
                    handles=SetfPosVectors(hObject,eventdata,handles);
                    guidata(hObject,handles)
                    TemporalClustering(hObject)
                case {'n','no'}
                    TemporalClustering(hObject)
                otherwise
                    msgbox('Invalid input')
            end
        end
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

function handles = AdjustPixelSize(hObject,eventdata,handles)
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

        handles = SetfPosVectors(hObject,eventdata,handles); 
        guidata(hObject,handles)
        
    else
        msgbox('You must first load data!')
    end
        
function handles = SetfPosVectors(hObject,eventdata,handles)
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
                    handles=FilteredClustersFromRaw(hObject,handles);
                    guidata(hObject,handles)
                    
                case 'iso'

                    threshold = str2num(get(handles.IsoLengthScale,'String'));
                    handles.isolated = IsolatedDetectionFilter(handles.Frames,handles.Xposnm,handles.Yposnm,threshold);
                    relevant_pts=and(InNucleus,~handles.isolated);
                    handles.fXpos = handles.Xposnm(relevant_pts);
                    handles.fYpos = handles.Yposnm(relevant_pts);
                    handles.fFrames = handles.Frames(relevant_pts);
                    handles.fIntensity=handles.Intensity(relevant_pts);
                    guidata(hObject,handles)
                    
                    handles=FilteredClustersFromRaw(hObject,handles);
                    guidata(hObject,handles)
                    
                    
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
                    
                    handles=FilteredClustersFromRaw(hObject,handles);
                    guidata(hObject,handles)
                    
            end
        else
            handles.which_filter='raw';
            guidata(hObject,handles)
            handles.fXpos = handles.Xposnm(InNucleus);
            handles.fYpos = handles.Yposnm(InNucleus);
            handles.fFrames = handles.Frames(InNucleus);
            handles.fIntensity = handles.Intensity(InNucleus);
            guidata(hObject, handles);
            
            handles=FilteredClustersFromRaw(handles,handles);
            guidata(hObject,handles)

        end
        
        handles = PlotPointillist(hObject,handles);
        guidata(hObject,handles)
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
