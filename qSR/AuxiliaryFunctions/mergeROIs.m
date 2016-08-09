function merged_ROIs = mergeROIs(ROIs)

    x=zeros(1,2*length(ROIs));
    y=zeros(1,2*length(ROIs));

    for i = 1:length(ROIs)
        x(2*i-1) = ROIs{i}(1);
        y(2*i-1) = ROIs{i}(2);
        x(2*i) = ROIs{i}(1) + ROIs{i}(3);
        y(2*i) = ROIs{i}(2) + ROIs{i}(4);
    end

    [~,x_idx]=sort(x);
    [~,y_idx]=sort(y);

    active_x=[];
    active_y=[];

    x_overlaps=[];
    y_overlaps=[];

    for i = 1:(2*length(ROIs))
        if mod(x_idx(i),2)==0
            test_x=x_idx(i)-1;
        else
            test_x=x_idx(i);
        end

        if mod(y_idx(i),2)==0
            test_y=y_idx(i)-1;
        else
            test_y=y_idx(i);
        end

        if sum(active_x==test_x)==0
            x_overlaps=[x_overlaps,[active_x;ones(1,length(active_x))*test_x]];
            active_x=sort([active_x,test_x]);
        else
            active_x(active_x==test_x)=[];
        end

        if sum(active_y==test_y)==0
            y_overlaps=[y_overlaps,[active_y;ones(1,length(active_y))*test_y]];
            active_y=sort([active_y,test_y]);
        else
            active_y(active_y==test_y)=[];
        end
    end

    alias = 1:length(ROIs);
    
    x_overlaps=(x_overlaps+1)/2;
    y_overlaps=(y_overlaps+1)/2;

    for i = 1:length(ROIs)
        x_candidates=[x_overlaps(2,x_overlaps(1,:)==i),x_overlaps(1,x_overlaps(2,:)==i)];
        y_candidates=[y_overlaps(2,y_overlaps(1,:)==i),y_overlaps(1,y_overlaps(2,:)==i)];
        
        to_merge=intersect(x_candidates,y_candidates);
        alias(to_merge)=alias(i);
    end
    
    unique_aliases=unique(alias);
    intermediate_ROIs=cell(1,length(unique_aliases));
    
    temp1=[ROIs{:}];
    ROImat=[temp1(1:4:end);temp1(2:4:end);temp1(1:4:end)+temp1(3:4:end);temp1(2:4:end)+temp1(4:4:end)];
    
    for i = 1:length(unique_aliases)
        intermediate_ROIs{i}(1)=min(ROImat(1,alias==unique_aliases(i)));
        intermediate_ROIs{i}(2)=min(ROImat(2,alias==unique_aliases(i)));
        intermediate_ROIs{i}(3)=max(ROImat(3,alias==unique_aliases(i)))-intermediate_ROIs{i}(1);
        intermediate_ROIs{i}(4)=max(ROImat(4,alias==unique_aliases(i)))-intermediate_ROIs{i}(2);
    end
    
    if length(intermediate_ROIs)==length(ROIs)
        merged_ROIs=intermediate_ROIs;
    else
        merged_ROIs=mergeROIs(intermediate_ROIs);
    end
    
    
