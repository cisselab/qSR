function st_clusters=SpatioTemporalDBSCAN(data,lengthscale,temp_tolerance,nmin)
%%% An O(N^2) time and O(N^2) space implementation of DBSCAN.
%%% data is and NxD matrix. 
%%% Buggy: I see some overlaping clusters. 
%%% Assumes data is a NxD matrix with N data points, a time coordinate in
%%% the first column, and D-1 spatial coordinates

    [N,D]=size(data);
    
    num_clusters=0;
    
    noise = false(1,N);
    visited = false(1,N);
    st_clusters = zeros(1,N);
    [neighborhood,num_neighbors]=find_neighbors(data,lengthscale,temp_tolerance);
    for i = 1:N
        if mod(i,1000)==0
            display(['Cluster Building Progress: ',num2str(i/N*100),'%'])
        end
            
        if visited(i)
            continue
        end
        visited(i)=true;

        if length(neighborhood{i})<nmin
            noise(i)=true;
            continue
        end

        num_clusters = num_clusters+1;
        [in_cluster,newly_visited]=build_cluster(data,i,nmin,neighborhood,N);
        st_clusters(in_cluster)=num_clusters;
        visited=or(visited,newly_visited);
    end
    sum(noise)
end

function [in_cluster,newly_visited]=build_cluster(data,i,nmin,neighborhood,N)
    sequence=1:N;
    cluster_points = neighborhood{i};
    newly_visited=false(1,N);
    newly_visited(cluster_points)=true;
    num_analyzed=0;
    while num_analyzed<length(cluster_points)
        neighbors=neighborhood{cluster_points(num_analyzed+1)};
        in_reach=false(1,N);
        in_reach(neighbors)=true;
        if length(neighbors)>=nmin
            new_points_idx = and(in_reach,~newly_visited);
            new_points=sequence(new_points_idx);
            cluster_points=[cluster_points,new_points];
        end
        newly_visited(in_reach)=true;
        num_analyzed=num_analyzed+1;
    end
    
    in_cluster=false(1,N);
    in_cluster(cluster_points)=true;
    
end

function [neighborhood,num_neighbors]=find_neighbors(data,lengthscale,temp_tolerance)
    [N,D]=size(data);
    sequence=1:N;
    neighborhood=cell(1,N);
    num_neighbors=zeros(1,N);
    for n =1:N
        if mod(n,1000)==0
            display(['Neighbor Finding Progress: ',num2str(n/N*100),'%'])
        end
        one_reachable = in_region(data,n,lengthscale,temp_tolerance);
        neighborhood{n}=sequence(one_reachable);
        num_neighbors(n)=length(neighborhood{n});
    end
    
end

function one_reachable = in_region(data,n,lengthscale,temp_tolerance)
[N,D]=size(data);
vector_displacements=zeros(N,D);
for d = 1:D
    vector_displacements(:,d)=data(:,d)-data(n,d);
end
vector_displacements(:,1)=(vector_displacements(:,1)>temp_tolerance)*(lengthscale+1); %Distance metric in time is a step function at the temp_tolerance. Any distance longer than temp_tolerance in time will fail the one_reachable test. 
distances=sqrt(sum(vector_displacements.^2,2));
one_reachable=distances<lengthscale;
end
