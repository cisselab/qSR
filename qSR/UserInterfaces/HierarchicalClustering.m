function varargout = HierarchicalClustering(varargin)
% HIERARCHICALCLUSTERING MATLAB code for HierarchicalClustering.fig
%      HIERARCHICALCLUSTERING, by itself, creates a new HIERARCHICALCLUSTERING or raises the existing
%      singleton*.
%
%      H = HIERARCHICALCLUSTERING returns the handle to a new HIERARCHICALCLUSTERING or the handle to
%      the existing singleton*.
%
%      HIERARCHICALCLUSTERING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HIERARCHICALCLUSTERING.M with the given input arguments.
%
%      HIERARCHICALCLUSTERING('Property','Value',...) creates a new HIERARCHICALCLUSTERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HierarchicalClustering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HierarchicalClustering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HierarchicalClustering

% Last Modified by GUIDE v2.5 28-Jul-2016 15:58:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HierarchicalClustering_OpeningFcn, ...
                   'gui_OutputFcn',  @HierarchicalClustering_OutputFcn, ...
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


% --- Executes just before HierarchicalClustering is made visible.
function HierarchicalClustering_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HierarchicalClustering (see VARARGIN)

handles.mainObject=varargin{1};

% Choose default command line output for HierarchicalClustering
handles.output = hObject;

mainHandles = guidata(handles.mainObject);

if isdir([mainHandles.directory,'qSR_Analysis_Output'])
else
    mkdir([mainHandles.directory,'qSR_Analysis_Output'])
end

if isdir([mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles'])
    testnameIn= [mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles',filesep,'FastJetInput.txt'];
    testnameOut= [mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles',filesep,'FastJetOutput.txt'];
    count=1;
    while exist(testnameIn,'file') == 2
        count = count+1;
        testnameIn= [mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles',filesep,'FastJetInput_',num2str(count),'.txt'];
        testnameOut= [mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles',filesep,'FastJetOutput_',num2str(count),'.txt'];
    end

    writefilename= testnameIn;
    fastjetoutfilename=testnameOut;
else
    mkdir([mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles'])
    writefilename= [mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles',filesep,'FastJetInput.txt'];
    fastjetoutfilename=[mainHandles.directory,'qSR_Analysis_Output',filesep,'FastJetFiles',filesep,'FastJetOutput.txt'];
end

SplashScreen()

handles.tree=BioJetTree(mainHandles.fFrames,mainHandles.fXpos,mainHandles.fYpos,mainHandles.fIntensity,writefilename,fastjetoutfilename);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HierarchicalClustering wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HierarchicalClustering_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in PlotClusters.
function PlotClusters_Callback(hObject, eventdata, handles)
% hObject    handle to PlotClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'tree')
    mainHandles=guidata(handles.mainObject);

    cut_height=str2num(get(handles.LengthScale,'String'));
    thresh_parameter=str2num(get(handles.ThresholdParameter,'String'));


    contents = cellstr(get(handles.ClusterDeterminant,'String'));
    cluster_determinant=contents{get(handles.ClusterDeterminant,'Value')};

    switch cluster_determinant
        case 'Minimum Size'
            threshold_scheme = 'min_points';
        case 'Fixed Number'
            threshold_scheme = 'top_clusters';
    end



    if get(handles.TimeColor,'Value')==1
        color_scheme='time_colored';
    else
        color_scheme='single_color';
    end

    Data=[mainHandles.fFrames;mainHandles.fXpos;mainHandles.fYpos]';
    sp_clusters=PlotFastJetClusters(Data,handles.tree,cut_height,threshold_scheme,thresh_parameter,color_scheme);
    handles.sp_clusters=sp_clusters;
    handles=RawClustersFromFiltered(mainHandles,handles);
    guidata(hObject,handles)
    
    
    %%%%%%%%
    mainHandles.sp_clusters=handles.sp_clusters;
    
    mainHandles.raw_sp_clusters=handles.raw_sp_clusters;
    
    mainHandles.valid_sp_clusters=true;

    mainHandles.sp_clust_algorithm = 'BioJets';

    mainHandles.BioJets_lengthscale = str2num(get(handles.LengthScale,'String'));
    mainHandles.BioJets_thresh_parameter=str2num(get(handles.ThresholdParameter,'String'));

    contents = cellstr(get(handles.ClusterDeterminant,'String'));
    cluster_determinant=contents{get(handles.ClusterDeterminant,'Value')};

    switch cluster_determinant
        case 'Minimum Size'
            mainHandles.BioJets_threshold_scheme = 'min_points';
        case 'Fixed Number'
            mainHandles.BioJets_threshold_scheme = 'top_clusters';
    end

    guidata(handles.mainObject,mainHandles)
    %%%%%%%%%
else
    msgbox('You must first Create the Tree!')
end

% --- Executes on button press in SaveClusters.
function SaveClusters_Callback(hObject, eventdata, handles)
% hObject    handle to SaveClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if isfield(handles,'sp_clusters')
%     mainHandles=guidata(handles.mainObject);
%     mainHandles.sp_clusters=handles.sp_clusters;
%     
%     mainHandles.raw_sp_clusters=handles.raw_sp_clusters;
%     
%     mainHandles.valid_sp_clusters=true;
% 
%     mainHandles.sp_clust_algorithm = 'BioJets';
% 
%     mainHandles.BioJets_lengthscale = str2num(get(handles.LengthScale,'String'));
%     mainHandles.BioJets_thresh_parameter=str2num(get(handles.ThresholdParameter,'String'));
% 
%     contents = cellstr(get(handles.ClusterDeterminant,'String'));
%     cluster_determinant=contents{get(handles.ClusterDeterminant,'Value')};
% 
%     switch cluster_determinant
%         case 'Minimum Size'
%             mainHandles.BioJets_threshold_scheme = 'min_points';
%         case 'Fixed Number'
%             mainHandles.BioJets_threshold_scheme = 'top_clusters';
%     end
% 
%     guidata(handles.mainObject,mainHandles)
%     
%     msgbox('Clusters saved!')
% else
%     msgbox('You must first Find Clusters!')
% end
mainHandles=guidata(handles.mainObject);

if mainHandles.valid_sp_clusters
    statistics=EvaluateSpatialSummaryStatistics(mainHandles.fXpos,mainHandles.fYpos,mainHandles.sp_clusters);
    %display('This will break if I change filters after finding the clusters')
    [area_counts,area_bins]=hist([statistics(:).c_hull_area],20);
    [size_counts,size_bins]=hist([statistics(:).cluster_size],20);

    figure
    plot(size_bins,size_counts/sum(size_counts))
    xlabel('Number of Localizations per Cluster')
    ylabel('Frequency')
    title('Cluster Size Distribution')
    
    mainHandles.sp_statistics=statistics;
    guidata(handles.mainObject,mainHandles)
    
    if exist([mainHandles.directory,'qSR_Analysis_Output'],'dir')
    else
        mkdir([mainHandles.directory,'qSR_Analysis_Output'])
    end
    
    test_name = [mainHandles.directory,'qSR_Analysis_Output',filesep,'Spatial_Cluster_Statistics',filesep];
    n=1;
    while exist(test_name,'dir')
        n=n+1;
        test_name = [mainHandles.directory,'qSR_Analysis_Output',filesep,'Spatial_Cluster_Statistics',num2str(n),filesep];
    end
    mkdir(test_name);
    
    ExportClusterStatistics(mainHandles.sp_statistics,[test_name,'spatialstats.csv'])

    filter_status_filename = [test_name,'filter_status_for_spatialstats.txt'];
    SaveFilterStatus(handles.mainObject,mainHandles,filter_status_filename)

    fData_filename = [test_name,'filtered_data_for_spatial.csv'];
    csvwrite(fData_filename,[mainHandles.fFrames;mainHandles.fXpos;mainHandles.fYpos;mainHandles.fIntensity])

    cluster_param_file_path=[test_name,'spatial_clustering_parameters.txt'];
    SaveClusteringParameters(handles.mainObject,mainHandles,cluster_param_file_path)

    sp_cluster_filename = [test_name,'sp_clusters.csv'];
    csvwrite(sp_cluster_filename,mainHandles.sp_clusters);
    
    msgbox(['Data saved in ', test_name,' !'])
    
else
    msgbox('You must first select clusters!')
end

% --- Executes on button press in SaveROIs.
function SaveROIs_Callback(hObject, eventdata, handles)
% hObject    handle to SaveROIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'sp_clusters')
    
    mainHandles=guidata(handles.mainObject);
    if isfield(mainHandles,'st_clusters')
        msgbox('Old temporal clusters deleted with selection of new ROIs!')
        mainHandles.st_clusters=zeros(size(mainHandles.st_clusters));
    end
    
    old_ROIs = clusters2ROIs(mainHandles.fXpos,mainHandles.fYpos,handles.sp_clusters);
    new_ROIs=mergeROIs(old_ROIs);
    ratio=length(old_ROIs)/length(new_ROIs);
    if ratio > 5
        msgbox('Warning: ROIs strongly overlap. Consolidation may result in excessively large ROIs.')
    end
    
    mainHandles.ROIs=new_ROIs;
    
    mainHandles.time_cluster_parameters.min_size=nan(1,length(mainHandles.ROIs));
    mainHandles.time_cluster_parameters.tolerance=nan(1,length(mainHandles.ROIs));
    
    set(mainHandles.PlotROIS,'Value',1)
    guidata(handles.mainObject,mainHandles)
    
    msgbox('ROIs saved!')
else
    msgbox('You must first Find Clusters!')
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
    set(handles.LengthScale,'String',160)
    guidata(hObject,handles)
elseif length_scale <=0
    msgbox('Length scale must be a positive number!')
    set(handles.LengthScale,'String',160)
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

% --- Executes on selection change in ClusterDeterminant.
function ClusterDeterminant_Callback(hObject, eventdata, handles)
% hObject    handle to ClusterDeterminant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ClusterDeterminant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ClusterDeterminant

DeterminantCell = get(handles.ClusterDeterminant,'String');
CurrentState = get(handles.ClusterDeterminant,'Value');

switch DeterminantCell{CurrentState}
    case 'Minimum Size'
        set(handles.DeterminantText,'String','Minimum Size (Detections)')
    case 'Fixed Number'
        set(handles.DeterminantText,'String','Number of Clusters')
end

% --- Executes during object creation, after setting all properties.
function ClusterDeterminant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClusterDeterminant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ThresholdParameter_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdParameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThresholdParameter as text
%        str2double(get(hObject,'String')) returns contents of ThresholdParameter as a double

thresh_param = str2num(get(handles.ThresholdParameter,'String'));
if isempty(thresh_param)
    msgbox('Parameter must be a positive integer!')
    set(handles.ThresholdParameter,'String',20)
    guidata(hObject,handles)
elseif thresh_param <=0
    msgbox('Parameter must be a positive integer!')
    set(handles.ThresholdParameter,'String',20)
    guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function ThresholdParameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThresholdParameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in TimeColor.
function TimeColor_Callback(hObject, eventdata, handles)
% hObject    handle to TimeColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TimeColor

function ROIs = clusters2ROIs(Xpos,Ypos,sp_clusters)

largest_cluster_number=max(sp_clusters);
ROIs={};
cluster_size=[];
for i = 1:largest_cluster_number
    if sum(sp_clusters==i)>1
        dX=max(Xpos(sp_clusters==i))-min(Xpos(sp_clusters==i));
        dY=max(Ypos(sp_clusters==i))-min(Ypos(sp_clusters==i));
        ROI_width = 2*max([dX,dY]);
        
        Xcent = mean(Xpos(sp_clusters==i));
        Ycent = mean(Ypos(sp_clusters==i));
        
        ROIs{end+1}=[Xcent-ROI_width/2,Ycent-ROI_width/2,ROI_width,ROI_width];
        cluster_size(end+1)=sum(sp_clusters==i);
    end
end

[~,sort_idx]=sort(cluster_size,'descend');
ROIs=ROIs(sort_idx);

function SplashScreen()
    msgbox({'#-------------------------------------------------------------------------- ', ...
'#                     FastJet release 3.2.0 [fjcore] ', ...
'#                 M. Cacciari, G.P. Salam and G. Soyez      ', ...             
'#     A software package for jet finding and analysis at colliders       ', ...
'#                           http://fastjet.fr                            ', ...
'#	                                                                       ', ...
'# Please cite EPJC72(2012)1896 [arXiv:1111.6097] if you use this package ', ...
'# for scientific work and optionally PLB641(2006)57 [hep-ph/0512210].    ', ...
'#                                                                        ', ...
'# FastJet is provided without warranty under the terms of the GNU GPLv2. ', ...
'# It uses T. Chan"s closest pair algorithm, S. Fortune"s Voronoi code ', ...
'# and 3rd party plugin jet algorithms. See COPYING file for details.', ...
'#--------------------------------------------------------------------------'})
