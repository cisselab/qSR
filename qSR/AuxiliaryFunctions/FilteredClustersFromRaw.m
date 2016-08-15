function clusterHandles = FilteredClustersFromRaw(filterHandles,clusterHandles)
    if isfield(filterHandles,'RestrictToNuclear')
        if get(filterHandles.RestrictToNuclear,'Value')
            InNucleus = inpolygon(filterHandles.Xposnm,filterHandles.Yposnm,filterHandles.FreehandROI(:,1),filterHandles.FreehandROI(:,2));
        else
            InNucleus=true(size(filterHandles.Frames));
        end
    else
        InNucleus=true(size(filterHandles.Frames));
    end
    
    clusterHandles.have_changed_filter_since_sp=true;
    clusterHandles.have_changed_filter_since_st=true;
    
    switch filterHandles.which_filter
        case 'raw'
            if isfield(clusterHandles,'raw_sp_clusters')
                clusterHandles.sp_clusters=clusterHandles.raw_sp_clusters(InNucleus);
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Consider rerunning clustering analyses.')
                clusterHandles.have_changed_filter_since_sp=true;
            end
            
            if isfield(clusterHandles,'raw_st_clusters')
                clusterHandles.st_clusters=clusterHandles.raw_st_clusters(InNucleus);
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Consider rerunning clustering analyses.')
                clusterHandles.have_changed_filter_since_st=true;
            end
        case 'iso'
            relevant_points=and(InNucleus,~filterHandles.isolated);
            
            if isfield(clusterHandles,'raw_sp_clusters')
                clusterHandles.sp_clusters=clusterHandles.raw_sp_clusters(relevant_points);
                clusterHandles.have_changed_filter_since_sp=true;
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Consider rerunning clustering analyses.')
            end
            
            if isfield(clusterHandles,'raw_st_clusters')
                clusterHandles.st_clusters=clusterHandles.raw_st_clusters(relevant_points);
                clusterHandles.have_changed_filter_since_st=true;
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Consider rerunning clustering analyses.')
            end
            
        case 'quick'
            unique_ids=unique(filterHandles.st_ids(filterHandles.st_ids>0));
            if isfield(clusterHandles,'raw_sp_clusters')
                clusterHandles.have_changed_filter_since_sp=true;
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Consider rerunning clustering analyses.')
                clusterHandles.sp_clusters=zeros(size(filterHandles.fFrames));
                
                assignment_discrepancies=false;
                nuclear_sp_clusters=clusterHandles.raw_sp_clusters(InNucleus);
                for i = 1:length(unique_ids)
                    
                    this_cluster_ids = nuclear_sp_clusters(filterHandles.st_ids==unique_ids(i));
                    clusterHandles.sp_clusters(i)=mode(this_cluster_ids); % Majority rule to determine cluster in case of assignment discrepancy.

                    these_unique_ids=unique(this_cluster_ids);
                    if length(these_unique_ids)>1
                        assignment_discrepancies=true;
                    end
                end
                if assignment_discrepancies
                    msgbox('WARNING: Selected spatial clusters do not overlap with the filtered groups. Group cluster identification was determine by majority rule. Consider rerunning clustering analyses.')
                end
            end
            
            if isfield(clusterHandles,'raw_st_clusters')
                clusterHandles.have_changed_filter_since_st=true;
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Consider rerunning clustering analyses.')
                clusterHandles.st_clusters=zeros(size(filterHandles.fFrames));
                
                assignment_discrepancies=false;
                nuclear_st_clusters=clusterHandles.raw_st_clusters(InNucleus);
                for i = 1:length(unique_ids)
                    
                    this_cluster_ids = nuclear_st_clusters(filterHandles.st_ids==unique_ids(i));
                    clusterHandles.st_clusters(i)=mode(this_cluster_ids); % Majority rule to determine cluster in case of assignment discrepancy.

                    these_unique_ids=unique(this_cluster_ids);
                    if length(these_unique_ids)>1
                        assignment_discrepancies=true;
                    end
                end
                if assignment_discrepancies
                    msgbox('WARNING: Selected spatial clusters do not overlap with the filtered groups. Group cluster identification was determine by majority rule. Consider rerunning clustering analyses.')
                end
            end
    end
    
    