function ids_out=QuickMerge(times,xpos,ypos,sigma,dark_time)

    N=length(times);
    
    [s_times,sort_idxs]=sort(times);
    s_xpos=xpos(sort_idxs);
    s_ypos=ypos(sort_idxs);
    
    ids=zeros(1,N);
    cluster_number=0;
    %cluster_end_times=[];
    try
        progress_bar_handle=waitbar(0,'Running Spatiotemporal Merge');
    catch
        progress_bar_handle = [];
    end
    for i = 1:N
        
%         %Display Progress
%         if mod(i,round(N/100)) ==0
%             if ishandle(progress_bar_handle)
%                 waitbar(i/N,progress_bar_handle,'Running Spatiotemporal Merge')
%             end
%         end
        
        %Initialize new cluster?
        if ids(i) == 0
            cluster_number=cluster_number+1;
            ids(i)=cluster_number;
            %cluster_end_times(cluster_number)=s_times(i);
        end
        
        
        for j = (i+1):N
            if (s_times(j)-s_times(i))-1<=dark_time 
                dist=sqrt((s_xpos(i)-s_xpos(j))^2+(s_ypos(i)-s_ypos(j))^2);
                if dist < sigma
                    if ids(j) == 0
                        ids(j)=ids(i);
                        %cluster_end_times(ids(i))=max(cluster_end_times(ids(i)),s_times(j));
                    else
                        ids(ids==ids(j))=ids(i);
                        %cluster_end_times(ids(i))=max(cluster_end_times(ids(i)),cluster_end_times(ids(j)));
                    end
                    
                end
            else 
                break
            end
            
        end
        
        %Display Progress
        if mod(i,round(N/100)) ==0
            if ishandle(progress_bar_handle)
                waitbar(i/N,progress_bar_handle,'Running Spatiotemporal Merge')
            end
        end
    end
    
    unique_ids=unique(ids);
    ids_out=zeros(size(ids));
    for i = 1:length(unique_ids)
        ids_out(ids==unique_ids(i))=i;
        if mod(i,round(length(unique_ids)/100)) ==0
            if ishandle(progress_bar_handle)
                waitbar(i/length(unique_ids),progress_bar_handle,'Consolidating IDs')
            end
        end
    end
    
    [~,unsort_idxs]=sort(sort_idxs);
    ids_out=ids_out(unsort_idxs);
    
    if ishandle(progress_bar_handle)
        close(progress_bar_handle)
    end
    
    
end