function handles = PlotPointillist(hObject,handles)
    
    maintain_axes=false;
    if isfield(handles,'pointillist_handle')
        if ishandle(handles.pointillist_handle)
            figure(handles.pointillist_handle)
            maintain_axes=true;
            current_axis=axis;
        else
            handles.pointillist_handle = figure;
            guidata(hObject, handles);
        end

    else
        handles.pointillist_handle = figure;
        guidata(hObject, handles);
    end


    if isfield(handles,'XposRaw')
        time_color=get(handles.time_color,'Value');
        show_clusters = get(handles.plot_clusters,'Value');
        show_ROIs = get(handles.PlotROIS,'Value');

        hold off
        plot(handles.fXpos,handles.fYpos,'.k','markersize',4)
        hold on

        if time_color
            if show_clusters
                if isfield(handles,'sp_clusters')
                    if length(handles.sp_clusters)==length(handles.fXpos)
                        plot_indices=handles.sp_clusters>0;
                    else
                        plot_indices=true(size(handles.fFrames));
                    end
                else
                    plot_indices=true(size(handles.fFrames));
                end

            else
                plot_indices=true(size(handles.fFrames));
            end
            colormat = [1-handles.fFrames(plot_indices)'/max(handles.fFrames(plot_indices)),zeros(sum(plot_indices),1),handles.fFrames(plot_indices)'/max(handles.fFrames(plot_indices))];
            scatter(handles.fXpos(plot_indices),handles.fYpos(plot_indices),4,colormat)
        else
            if show_clusters
                if isfield(handles,'sp_clusters')
                    if length(handles.sp_clusters)==length(handles.fXpos)
                        K=max(handles.sp_clusters);
                        for k = 1:K
                            Color = [k/K,rand,1-k/K];
                            plot(handles.fXpos(handles.sp_clusters==k),handles.fYpos(handles.sp_clusters==k),'.','MarkerFaceColor',Color,...
                                'Color',Color)
                        end
                    end
                end
            else
            end
        end

        if show_ROIs
            if isfield(handles,'ROIs')
                if ~isempty(handles.ROIs)
                    for i = 1:length(handles.ROIs)
                        x=[handles.ROIs{i}(1),handles.ROIs{i}(1)+handles.ROIs{i}(3),handles.ROIs{i}(1)+handles.ROIs{i}(3),handles.ROIs{i}(1),handles.ROIs{i}(1)];
                        y=[handles.ROIs{i}(2),handles.ROIs{i}(2),handles.ROIs{i}(2)+handles.ROIs{i}(4),handles.ROIs{i}(2)+handles.ROIs{i}(4),handles.ROIs{i}(2)];
                        plot(x,y,'-r')
                    end
                end
            end
        end
        
        axis equal square
        
        if maintain_axes
            
            zoom reset
            axis(current_axis)
            
        end
    else
        msgbox('You must first load data!')
    end
     