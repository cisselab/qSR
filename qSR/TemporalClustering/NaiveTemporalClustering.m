function st_clusters=NaiveTemporalClustering(Frames,sp_clusters,dark_tolerance)
    st_clusters=zeros(size(sp_clusters));
    largest_cluster_id=max(sp_clusters);
    previous_cluster_number=0;
    for i = 1:largest_cluster_id;
        current_frames=Frames(sp_clusters==i);
        [s_frames,s_index]=sort(current_frames);
        [~,inverse_sort]=sort(s_index);
        gaps=(s_frames(2:end)-s_frames(1:(end-1))>dark_tolerance);
        gaps(end+1)=false;
        end_pts = find(gaps);
        end_pts(end+1)=length(gaps);
        start_pts=[1,end_pts(1:(end-1))+1];
        s_ids=zeros(size(gaps));
        for j = 1:length(start_pts)
            s_ids(start_pts(j):end_pts(j))=j+previous_cluster_number;
        end
        us_ids=s_ids(inverse_sort);
        st_clusters(sp_clusters==i)=us_ids;
        previous_cluster_number=previous_cluster_number+length(start_pts);
    end

end