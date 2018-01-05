function cluster_ids = DBSCAN_kdtree(Data,minpts,eps,varargin)

    if nargin >3
        switch varargin{1}
            case 'include'
                include=true;
            case 'exclude'
                include=false;
        end
    else
        include=true;
    end

    [N,D] = size(Data);
    
    kdtree = KDTreeSearcher(Data);
    [neighbor_idxs,distances] = rangesearch(kdtree,Data,eps);

    visited = false(1,N);
    cluster_count=0;
    cluster_ids = zeros(1,N);
    
    for i = 1:N
        if ~visited(i)
            if length(distances{i}) >= minpts
                cluster_count = cluster_count+1;
                cluster_ids(i) = cluster_count;
                data_stack = neighbor_idxs{i};
                while ~isempty(data_stack)
                    if ~visited(data_stack(1))
                        visited(data_stack(1)) = true;
                        if include %Always include a point in the cluster
                            cluster_ids(data_stack(1)) = cluster_count;
                        else % Exclude a point from the cluster if it is a margin point.
                            if length(distances{data_stack(1)}) >= minpts
                                cluster_ids(data_stack(1)) = cluster_count;
                            end
                        end
                        if length(distances{data_stack(1)}) >= minpts
                            data_stack = [data_stack,neighbor_idxs{data_stack(1)}];
                        end
                    end
                    data_stack(1)=[];
                    data_stack = unique( data_stack );
                end
            end
        end
    end 
end