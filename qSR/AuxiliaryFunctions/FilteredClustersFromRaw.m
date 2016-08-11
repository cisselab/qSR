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
    
    switch filterHandles.which_filter
        case 'raw'
            if isfield(clusterHandles,'raw_sp_clusters')
                clusterHandles.sp_clusters=clusterHandles.raw_sp_clusters(InNucleus);
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Final results may be unpredictble.')
            end
            
            if isfield(clusterHandles,'raw_st_clusters')
                clusterHandles.st_clusters=clusterHandles.raw_st_clusters(InNucleus);
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Final results may be unpredictble.')
            end
        case 'iso'
            relevant_points=and(InNucleus,~filterHandles.isolated);
            
            if isfield(clusterHandles,'raw_sp_clusters')
                clusterHandles.sp_clusters=clusterHandles.raw_sp_clusters(relevant_points);
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Final results may be unpredictble.')
            end
            
            if isfield(clusterHandles,'raw_st_clusters')
                clusterHandles.st_clusters=clusterHandles.raw_st_clusters(relevant_points);
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Final results may be unpredictble.')
            end
            
        case 'quick'
            unique_ids=unique(filterHandles.st_ids(filterHandles.st_ids>0));
            if isfield(clusterHandles,'raw_sp_clusters')
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Final results may be unpredictble.')
                clusterHandles.sp_clusters=zeros(size(filterHandles.fFrames));
                
                assignment_discrepancies=false;
                for i = 1:length(unique_ids)
                    this_cluster_ids = clusterHandles.raw_sp_clusters(filterHandles.st_ids==unique_ids(i));
                    clusterHandles.sp_clusters(unique_ids(i))=mode(this_cluster_ids); % Majority rule to determine cluster in case of assignment discrepancy.

                    these_unique_ids=unique(this_cluster_ids);
                    if length(these_unique_ids)>1
                        assignment_discrepancies=true;
                    end
                end
                if assignment_discrepancies
                    msgbox('WARNING: Selected spatial clusters do not overlap with the filtered groups. Group cluster identification was determine by majority rule. Behavior may be unpredicatble.')
                end
            end
            
            if isfield(clusterHandles,'raw_st_clusters')
                msgbox('Warning: Spatial and Temporal Clustering Assignments have been altered by a change in the filter status. Final results may be unpredictble.')
                assignment_discrepancies=false;
                for i = 1:length(unique_ids)
                    this_cluster_ids = clusterHandles.raw_st_clusters(filterHandles.st_ids==unique_ids(i));
                    clusterHandles.st_clusters(unique_ids(i))=mode(this_cluster_ids);

                    these_unique_ids=unique(this_cluster_ids);
                    if length(these_unique_ids)>1
                        assignment_discrepancies=true;
                    end
                end
                if assignment_discrepancies
                    msgbox('WARNING: Selected temporal clusters do not overlap with the filtered groups. Group cluster identification was determine by majority rule. Behavior may be unpredicatble.')
                end
            end
    end
    
    