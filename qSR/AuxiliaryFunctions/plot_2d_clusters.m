function plot_2d_clusters(data,cluster_ids)

    K=max(cluster_ids);
    Markers = '^osd';
    figure
    plot(data(:,1),data(:,2),'.k')
    hold on
    for k = 1:K
        Color = [k/K,rand,1-k/K];
        current_marker = Markers(mod(k,4)+1);
        plot(data(cluster_ids==k,1),data(cluster_ids==k,2),...
            current_marker,...
            'MarkerFaceColor',Color,...
            'Color',Color)
    end
    
end