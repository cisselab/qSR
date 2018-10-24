function plot_2d_clusters(data,cluster_ids,underlay)

    if nargin <3
        underlay_logical = false;
        outline_logical = false;
        
    else
        switch lower(underlay)
            case {'underlay','under','below'}
                underlay_logical = true;
                outline_logical = false;
            case {'overlay','over','above'}
                underlay_logical = false;
                outline_logical = false;
            case {'outline','hull','chull','c_hull','convex hull','convex_hull','convhull'}
                underlay_logical = false;
                outline_logical = true;
            otherwise
                underlay_logical = false;
                outline_logical = false;
        end
    end

    K=max(cluster_ids);
    Markers = '^osd';
    figure
    
    if ~underlay_logical
        plot(data(:,1),data(:,2),'.k')
    end
    
    
    if outline_logical
        
        hold on
        for k = 1:K
            x = data(cluster_ids==k,1);
            y=data(cluster_ids==k,2);
            chull_points = convhull(x,y);
            plot(x(chull_points),y(chull_points),'r','LineWidth',2)
            
        end
        
    else %No outline? Color codethe points
        
        hold on
        for k = 1:K
            Color = [k/K,rand,1-k/K];
            current_marker = Markers(mod(k,4)+1);
            plot(data(cluster_ids==k,1),data(cluster_ids==k,2),...
                current_marker,...
                'MarkerFaceColor',Color,...
                'Color',Color)
        end
        
    end
    
    if underlay_logical
        plot(data(:,1),data(:,2),'.k')
    end
end