function clusters=DarkTimeClustering(Frames,ROI_ids,dark_tolerance,min_size)

    clusters=zeros(size(Frames));
    previous_cluster_number=0;
    
    unique_ROIs=unique(ROI_ids);
    num_ROIs=length(unique_ROIs);
    
    if unique_ROIs(1)~=0
        start_index=1;
    else
        start_index=2;
    end
    
    for i = start_index:num_ROIs
        current_frames=Frames(ROI_ids==unique_ROIs(i));
        [s_frames,s_index]=sort(current_frames);
        [~,inverse_sort]=sort(s_index);
        
        gaps=(s_frames(2:end)-s_frames(1:(end-1))>dark_tolerance);
        gaps(end+1)=false;
        end_pts = find(gaps);
        end_pts(end+1)=length(s_frames);
        
        
        start_pts=[1,end_pts(1:(end-1))+1];
        s_ids=zeros(size(gaps));
        cl_sizes=end_pts-start_pts+1;
        
        start_pts(cl_sizes<min_size)=[];
        end_pts(cl_sizes<min_size)=[];
        
        for j = 1:length(start_pts)
            s_ids(start_pts(j):end_pts(j))=j+previous_cluster_number;
        end
        
        us_ids=s_ids(inverse_sort);
        clusters(ROI_ids==unique_ROIs(i))=us_ids;
        previous_cluster_number=previous_cluster_number+length(start_pts);
           
    end
    
end