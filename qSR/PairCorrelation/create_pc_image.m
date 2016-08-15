function [image,mask,avg_density,Npoints] = create_pc_image(Xpos,Ypos,binsize,FreehandROICoordinateList)

    progress_bar=waitbar(0,'Binning data');
    
    Npoints = length(Xpos);
    Area = polyarea(FreehandROICoordinateList(:,1),FreehandROICoordinateList(:,2));
    avg_density = Npoints/Area;
    
    waitbar(0.3,progress_bar,'Binning data');
    
    minX=min(Xpos);maxX=max(Xpos);minY=min(Ypos);maxY=max(Ypos);
    Edges{1}=minX:binsize:maxX;
    Edges{2}=minY:binsize:maxY;
    
    image = hist3([Xpos',Ypos'],'Edges',Edges);
    
    waitbar(0.7,progress_bar,'Binning data');
    
    [xx,yy]=meshgrid(Edges{1},Edges{2});
    mask_transpose = inpolygon(xx,yy,FreehandROICoordinateList(:,1),FreehandROICoordinateList(:,2));
    mask = mask_transpose';
    
    waitbar(1,progress_bar,'Binning data');
    
    if ishandle(progress_bar)
        close(progress_bar)
    end
    
end
