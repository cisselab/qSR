function SaveTimeClusteringParameters(hObject,handles,file_path)
    tolerance=handles.time_cluster_parameters.tolerance;
    min_size=handles.time_cluster_parameters.min_size;
    
    fhandle=fopen(file_path,'w');
    fprintf(fhandle,'Dark Time Tolerance (Frames), Minimum Size')
    for i = 1:length(tolerance)
        fprintf(fhandle, '\n')
        fprintf(fhandle,[num2str(tolerance(i)),',', num2str(min_size(i))])
    end