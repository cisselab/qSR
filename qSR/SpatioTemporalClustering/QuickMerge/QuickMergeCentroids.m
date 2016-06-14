function [frameCentroid,xCentroid,yCentroid,totalIntensity]=QuickMergeCentroids(Frames,Xpos,Ypos,Intensity,st_ids,min_points)

    frameCentroid=[];
    xCentroid=[];
    yCentroid=[];
    totalIntensity=[];
    for i = 1:max(st_ids)
       if sum(st_ids==i)>=min_points
           frameCentroid=[frameCentroid,mean(Frames(st_ids==i))];
           xCentroid=[xCentroid,mean(Xpos(st_ids==i))];
           yCentroid=[yCentroid,mean(Ypos(st_ids==i))];
           totalIntensity=[totalIntensity,sum(Intensity(st_ids==i))];
       end
    end