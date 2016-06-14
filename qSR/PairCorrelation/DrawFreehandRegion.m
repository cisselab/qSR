function FreehandROICoordinateList = DrawFreehandRegion
    FreehandROIhandle = imfreehand; %Allows the user to draw a boundary for the nucleus
    FreehandROICoordinateList = getPosition(FreehandROIhandle); %Returns an ordered list of the x and y coordinates that defines the boundary.
    