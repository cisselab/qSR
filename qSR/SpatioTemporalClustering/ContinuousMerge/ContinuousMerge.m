function agg_points=ContinuousMerge(Times,Xpos,Ypos,sigma)
%precluster_pc_data   
%   precluster_pc_data takes in data in the form of vectors of times in
%   frame numbers (Times), positions (Xpos and Ypos), and localization
%   uncertainty (sigma), and merges localizations in subsequent frames that
%   are within 2.5*sigma of each other. The localizations of merged points
%   are replaced with a single point located at the centroid of the merged
%   points. 

%   Sparsity violations. output vector. 

    unique_times=unique(Times);
    first_X=Xpos(Times==unique_times(1));
    first_Y=Ypos(Times==unique_times(1));
    
    % previous_points and current_points list x positions in row 1, y
    % positions in row 2, and the number of points contributing to the
    % position in row 3. Single localizations have a 1 in row three, and 
    % groups of N points will have an N in row 3.  
    previous_points = [first_X;first_Y;ones(1,length(first_X))]; %The third row will record how many points contributed to the current centroid
    agg_points=[]; % agg_points aggregates 
    sparsity_violations=0;
    for t = 2:length(unique_times)
        current_points=[Xpos(Times==unique_times(t));Ypos(Times==unique_times(t));ones(1,sum(Times==unique_times(t)))]; %The third row is "weights".
       
        mean_points=current_points; 
        
        if ((unique_times(t)-unique_times(t-1))==1) %Only check where there are localizations in subsequent frames.
            cross_dist=cross_pdist(current_points(1:2,:)',previous_points(1:2,:)');
            to_merge = cross_dist<2.5*sigma; % to_merge is an N_current x N_previous matrix whose r,c element correspond to whether current point r is within range of previous point c.
        
            weighted_current_points = [current_points(1,:).*current_points(3,:);current_points(2,:).*current_points(3,:);current_points(3,:)];
            weighted_previous_points = [previous_points(1,:).*previous_points(3,:);previous_points(2,:).*previous_points(3,:);previous_points(3,:)];
            
            [num_curr,num_prev]=size(to_merge);
            for i = 1:num_prev %Loop through each of the previous points.
                in_range=to_merge(:,i);
                if sum(in_range)>1
                    [~,closest_point] = min(cross_dist(:,i));
                    weighted_current_points(:,closest_point)=weighted_current_points(:,closest_point)+weighted_previous_points(:,i);
                    sparsity_violations = sparsity_violations+sum(in_range)-1;
                elseif sum(in_range)==1
                    weighted_current_points(:,in_range)=weighted_current_points(:,in_range)+weighted_previous_points(:,i); 
                end
            end
            mean_points= [weighted_current_points(1,:)./weighted_current_points(3,:);weighted_current_points(2,:)./weighted_current_points(3,:);weighted_current_points(3,:)];
            not_to_merge=(sum(to_merge,1)==0);
            agg_points=[agg_points,previous_points(:,not_to_merge)];     
        else
            agg_points=[agg_points,previous_points];
        end
        
        previous_points=mean_points; 
    end
    
    agg_points=[agg_points,previous_points];
    
%     figure
%     pointillist([Xpos;Ypos])
%     figure
%     pointillist(agg_points)
%     
%     display('Sparsity was violated ')
%     display(sparsity_violations)
%     display('times')