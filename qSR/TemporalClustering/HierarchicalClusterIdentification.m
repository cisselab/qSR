 function [Cluster_Start_Times,Cluster_End_Times] = HierarchicalClusterIdentification(Frames,ROIindices,SliderValue,ClusterSizeCutoff)

 % This function takes in the list of localization times (Frames), 
 % a variable identifying which of the localizations lie within the Region of interest (ROIindices)
 % and specified parameters for
 % cluster identification, and groups the detections into clusters and returns 
 % the start and end time of each cluster identified.
 
TotalCountNumber=sum(ROIindices);
SpecifiedClusterNumber = ceil(TotalCountNumber*SliderValue);

if SpecifiedClusterNumber ~= 0
    %% Find the Detections
    FramesInROI = Frames(ROIindices);

    %% Group into Clusters
    D = pdist(FramesInROI');

    M=linkage(D);

    ClusterIdentity = cluster(M,'maxclust',SpecifiedClusterNumber);
    
    for i = 1:SpecifiedClusterNumber
        IndicesOfClusterElements = (ClusterIdentity == i);
        if sum(IndicesOfClusterElements)<ClusterSizeCutoff
            ClusterIdentity(IndicesOfClusterElements)=0;
        end
    end

    %% Determine the Start and End Times of Every Cluster
    Cluster_Start_Times = zeros(1,SpecifiedClusterNumber);
    Cluster_End_Times = zeros(1,SpecifiedClusterNumber);
    Cluster_Size = zeros(1,SpecifiedClusterNumber);
    for j =1:SpecifiedClusterNumber
        CurrentClusterIndices = (ClusterIdentity==j);
        XValues = FramesInROI(CurrentClusterIndices');
        if ~isempty(XValues)
            Cluster_Start_Times(j) = XValues(1);
            Cluster_End_Times(j) = XValues(end);
            Cluster_Size(j) = sum(CurrentClusterIndices);
        end
    end
    ClusterIndices = Cluster_Size~=0;
    Cluster_Start_Times = Cluster_Start_Times(ClusterIndices);
    Cluster_End_Times = Cluster_End_Times(ClusterIndices);
    
else
    Cluster_Start_Times = [];
    Cluster_End_Times = [];
end

end