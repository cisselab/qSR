function SaveClusteringParameters(hObject,handles,file_path)

    switch handles.sp_clust_algorithm
        case 'BioJets'
            fhandle=fopen(file_path,'w');
            fprintf(fhandle,'Algorithm: BioJets \n');
            fprintf(fhandle,['Length Scale: ',num2str(handles.BioJets_lengthscale),' (nm) \n']);
            fprintf(fhandle,['Thresholding Scheme: ',handles.BioJets_threshold_scheme,' \n']);
            switch handles.BioJets_threshold_scheme
                case 'min_points'
                    fprintf(fhandle,['Minimum Cluster Size: ',num2str(handles.BioJets_thresh_parameter)]);
                case 'top_clusters'
                    fprintf(fhandle,['Number of Clusters: ',num2str(handles.BioJets_thresh_parameter)]);
            end

            fclose(fhandle);
        case 'DBSCAN'
            fhandle=fopen(file_path,'w');
            fprintf(fhandle,'Algorithm: DBSCAN \n');
            fprintf(fhandle,['Length Scale: ',num2str(handles.dbscan_length),' (nm) \n']);
            fprintf(fhandle,['Minimum Points: ',num2str(handles.dbscan_nmin)]);
            fclose(fhandle);
    end
end