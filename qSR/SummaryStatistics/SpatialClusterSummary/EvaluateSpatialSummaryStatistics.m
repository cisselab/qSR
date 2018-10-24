function statistics=EvaluateSpatialSummaryStatistics(Xpos,Ypos,sp_clusters)

    largest_cluster_id = max(sp_clusters);
    unique_ids=unique(sp_clusters);
    unique_ids=unique_ids(unique_ids>0);
    statistics = struct;
    
    %for i = 1:largest_cluster_id
    for i = 1:length(unique_ids)
       %select points in current cluster 
       Xpos_current=Xpos(sp_clusters==unique_ids(i));
       Ypos_current=Ypos(sp_clusters==unique_ids(i));
       % Determine number of points in cluster
       statistics(i).cluster_id=unique_ids(i);
       statistics(i).cluster_size=sum(sp_clusters==unique_ids(i));
       
       if statistics(i).cluster_size>0
           %find their centroid
           statistics(i).X_cent = mean(Xpos_current);
           statistics(i).Y_cent = mean(Ypos_current);

           %construct the smallest convex polygon that contains every point in
           %the current cluster (i.e., the convex hull).
           if length(Xpos_current)>2
                convex_hull = convhull(Xpos_current,Ypos_current);
                %evaluate metrics of cluster size: convex hull area and radius standard
                %deviation
                statistics(i).c_hull_area = polyarea(Xpos_current(convex_hull),Ypos_current(convex_hull));
           else
               statistics(i).c_hull_area=0;
           end


           centered_pts=[reshape(Xpos_current-statistics(i).X_cent,[statistics(i).cluster_size,1]),reshape(Ypos_current-statistics(i).Y_cent,[statistics(i).cluster_size,1])];
           statistics(i).cov_mat=centered_pts'*centered_pts/statistics(i).cluster_size;

           statistics(i).rms_radius=sqrt(trace(statistics(i).cov_mat));

           [eig_vec_mat,eig_val_mat]=eig(statistics(i).cov_mat);
           [large_eig_val,large_eig_vec_idx]=max(diag(eig_val_mat));
           small_eig_val=min(diag(eig_val_mat));
           statistics(i).stretch_factor=large_eig_val/small_eig_val;
           statistics(i).principle_axis_slope=eig_vec_mat(large_eig_vec_idx,2)/eig_vec_mat(large_eig_vec_idx,1);
       end
    end
    
    if isfield(statistics,'cluster_size')
        statistics=statistics([statistics.cluster_size]>0);
 
    end
    