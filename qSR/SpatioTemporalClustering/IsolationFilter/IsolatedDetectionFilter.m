function IsAnIsolatedDetection = IsolatedDetectionFilter(Frames,Xpos,Ypos,threshold)

    %%% We will keep all data points from the first, and last frames. Therefore,
    %%% the first order of business is to find where the second frame starts, 
    %%% and the second to last frame ends. 
    DetectionNumbers = 1:length(Frames);
    
    %%% I detect the StartingFrameNumber and LastFrameNumber to make sure
    %%% that the algorithm is robust to possibility of no detections in the
    %%% first or last camera frames.
    StartingFrameNumber = Frames(1);
    StartingFrameDetections = DetectionNumbers(Frames==StartingFrameNumber);
    starting_index = StartingFrameDetections(end)+1;
    
    LastFrameNumber = Frames(end);
    EndingFrameDetections = DetectionNumbers(Frames==LastFrameNumber);
    ending_index = EndingFrameDetections(1)-1;
    
    %%% Next I will step through all of the points in the middle. If the
    %%% closest points from BOTH the previous AND the following frames are
    %%% FURTHER away than the threshold (associated with the diffraction
    %%% limit, perhaps) then we call it an Isolated Detection. These can be
    %%% Deleted.
    IsAnIsolatedDetection = zeros(1,length(Frames));
    
    for i = starting_index:ending_index
        CurrentFrame = Frames(i);
        PreviousFrame = CurrentFrame-1;
        NextFrame = CurrentFrame+1;
        PreviousDetections = [Frames(Frames==PreviousFrame);Xpos(Frames==PreviousFrame);Ypos(Frames==PreviousFrame)];
        NextDetections = [Frames(Frames==NextFrame);Xpos(Frames==NextFrame);Ypos(Frames==NextFrame)];
        
        DistanceFromPreviousPoints = sqrt((Xpos(i)-PreviousDetections(2,:)).^2+...
            (Ypos(i)-PreviousDetections(3,:)).^2);
        DistanceToNextPoints = sqrt((Xpos(i)-NextDetections(2,:)).^2+...
            (Ypos(i)-NextDetections(3,:)).^2);
        if isempty(DistanceFromPreviousPoints)
            if isempty(DistanceToNextPoints)
                IsAnIsolatedDetection(i) = 1;
            elseif min(DistanceToNextPoints)>threshold
                IsAnIsolatedDetection(i) = 1;
            end
        else
            if isempty(DistanceToNextPoints)
                if min(DistanceFromPreviousPoints)>threshold
                    IsAnIsolatedDetection(i) = 1;
                end
            elseif (min(DistanceFromPreviousPoints)>threshold)&&(min(DistanceToNextPoints)>threshold)
                IsAnIsolatedDetection(i) = 1;
            end 
        end
    end
    IsAnIsolatedDetection = logical(IsAnIsolatedDetection);
end
