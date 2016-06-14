function ids=QuickMerge(times,xpos,ypos,sigma,dark_time)

    N=length(times);
    
    [s_times,sort_idxs]=sort(times);
    s_xpos=xpos(sort_idxs);
    s_ypos=ypos(sort_idxs);
    
    ids=zeros(1,N);
    cluster_number=0;
    cluster_end_times=[];
    for i = 1:N
        if mod(i,round(N/100)) ==0
            display(i/N*100)
        end
        if ids(i) == 0
            cluster_number=cluster_number+1;
            ids(i)=cluster_number;
            cluster_end_times(cluster_number)=s_times(i);
        end
        for j = (i+1):N
            if (s_times(j)-cluster_end_times(ids(i)))<=dark_time 
                dist=sqrt((s_xpos(i)-s_xpos(j))^2+(s_ypos(i)-s_ypos(j))^2);
                if dist < 2.5*sigma
                    if ids(j) == 0;
                        ids(j)=ids(i);
                        cluster_end_times(ids(i))=max(cluster_end_times(ids(i)),s_times(j));
                    else
                        ids(ids==ids(j))=ids(i);
                        cluster_end_times(ids(i))=max(cluster_end_times(ids(i)),cluster_end_times(ids(j)));
                    end
                    
                end
            else 
                break
            end
            
        end
    end
    
end