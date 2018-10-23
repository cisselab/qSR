function [frameCentroid,xCentroid,yCentroid,totalIntensity]=QuickMergeCentroids(Frames,Xpos,Ypos,Intensity,st_ids,min_points)

    frameCentroid=[];
    xCentroid=[];
    yCentroid=[];
    totalIntensity=[];
    
    unique_ids = unique(st_ids);
    unique_ids = unique_ids(unique_ids>0);
    
    try
        progress_bar_handle=waitbar(0,'Merging Clusters');
    catch
        progress_bar_handle=[];
    end
    
    for i = 1:length(unique_ids)

%        if sum(st_ids==unique_ids(i))>=min_points
%            frameCentroid=[frameCentroid,mean(Frames(st_ids==unique_ids(i)))];
%            xCentroid=[xCentroid,mean(Xpos(st_ids==unique_ids(i)))];
%            yCentroid=[yCentroid,mean(Ypos(st_ids==unique_ids(i)))];
%            totalIntensity=[totalIntensity,sum(Intensity(st_ids==unique_ids(i)))];
%        end
       current_ids = find(st_ids==unique_ids(i));
       if length(current_ids)>=min_points
           frameCentroid=[frameCentroid,mean(Frames(current_ids))];
           xCentroid=[xCentroid,mean(Xpos(current_ids))];
           yCentroid=[yCentroid,mean(Ypos(current_ids))];
           totalIntensity=[totalIntensity,sum(Intensity(current_ids))];
       end
       
        %Display Progress
        if mod(i,round(length(unique_ids)/100)) ==0
            if ishandle(progress_bar_handle)
                waitbar(i/length(unique_ids),progress_bar_handle,'Merging Clusters')
            end
        end
       
    end
    
    if ishandle(progress_bar_handle)
        close(progress_bar_handle)
    end
    