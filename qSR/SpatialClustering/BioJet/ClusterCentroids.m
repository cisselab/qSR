function centroids = ClusterCentroids(data,ids,min_size)

    [r,c]=size(data);

    unique_ids = unique(ids);
    if unique_ids(1) == 0
        unique_ids(1)=[];
    end

    centroids = zeros(length(unique_ids),c);
    for i = 1:length(unique_ids)
        if sum(ids==unique_ids(i))>=min_size
            centroids(i,:)=mean(data(ids==unique_ids(i),:),1);
        end
    end