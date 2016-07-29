function PlotClusterBackground(data,ids,min_size)
    centroids=ClusterCentroids(data,ids,min_size);
    
    centroids=centroids(centroids(:,1)>0,:);
    
    unique_ids=unique(ids);
    if unique_ids(1)==0
        unique_ids(1)=[];
    end
    
    cmap=jet(length(unique_ids));
    
    hold on
    for i = 1:length(unique_ids)
        if sum(ids==unique_ids(i))>=min_size
            plot(data(ids==unique_ids(i),2),data(ids==unique_ids(i),3),'.','MarkerSize',16,'color',cmap(randi(length(unique_ids)),:))
        end
    end
    
    plot(data(:,2),data(:,3),'.','markersize',4,'color',[0.6,0.6,0.6])
    plot(centroids(:,2),centroids(:,3),'+','markersize',9,'color',[0,0,0],'linewidth',1)