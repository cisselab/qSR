function clusterHandles=RawClustersFromFiltered(filterHandles,clusterHandles)

    %%% I need to reformulate this function so that it can work if called
    %%% from TemporalAnalysis. Should be able to act on TemporalAnalysis
    %%% gui clusters, based on the filter status of qSR gui. 

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
            if isfield(clusterHandles,'sp_clusters')
                clusterHandles.have_changed_filter_since_sp=false;
                clusterHandles.raw_sp_clusters=zeros(size(filterHandles.Frames));
                clusterHandles.raw_sp_clusters(InNucleus)=clusterHandles.sp_clusters;
            end
            
            if isfield(clusterHandles,'st_clusters')
                clusterHandles.have_changed_filter_since_st=false;
                clusterHandles.raw_st_clusters=zeros(size(filterHandles.Frames));
                clusterHandles.raw_st_clusters(InNucleus)=clusterHandles.st_clusters;
            end
            
        case 'iso'
            relevant_points=and(InNucleus,~filterHandles.isolated);
            
            if isfield(clusterHandles,'sp_clusters')
                clusterHandles.have_changed_filter_since_sp=false;
                clusterHandles.raw_sp_clusters=zeros(size(filterHandles.Frames));
                clusterHandles.raw_sp_clusters(relevant_points)=clusterHandles.sp_clusters;
            end
            
            if isfield(clusterHandles,'st_clusters')
                clusterHandles.have_changed_filter_since_st=false;
                clusterHandles.raw_st_clusters=zeros(size(filterHandles.Frames));
                clusterHandles.raw_st_clusters(relevant_points)=clusterHandles.st_clusters;
            end
            
        case 'quick'
            nuclear_point_ids=zeros(1,sum(InNucleus));
            unique_ids=unique(filterHandles.st_ids(filterHandles.st_ids>0));
            
            if isfield(clusterHandles,'sp_clusters')
                clusterHandles.have_changed_filter_since_sp=false;
                for i = 1:length(unique_ids)
                    nuclear_point_ids(filterHandles.st_ids==unique_ids(i))=clusterHandles.sp_clusters(i);
                end
                clusterHandles.raw_sp_clusters=zeros(size(filterHandles.Frames));
                clusterHandles.raw_sp_clusters(InNucleus)=nuclear_point_ids;
            end
            if isfield(clusterHandles,'st_clusters')
                clusterHandles.have_changed_filter_since_st=false;
                for i = 1:length(unique_ids)
                    nuclear_point_ids(filterHandles.st_ids==unique_ids(i))=clusterHandles.st_clusters(unique_ids(i));
                end
                clusterHandles.raw_st_clusters=zeros(size(filterHandles.Frames));
                clusterHandles.raw_st_clusters(InNucleus)=nuclear_point_ids;
            end         
    end