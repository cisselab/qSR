function SaveQuickMergeMetadata(o_filename,source_filename,lengthscale,dark_time_tolerance,merge_min_points)

    filehandle = fopen(o_filename,'w');
    
    fprintf(filehandle,['Source file: ',source_filename]);
    fprintf(filehandle,'\n');
    fprintf(filehandle,['Neighborhood size: ',num2str(lengthscale)]);
    fprintf(filehandle,'\n');
    fprintf(filehandle,['Maximum number of intervening dark frames: ',num2str(dark_time_tolerance)]);
    fprintf(filehandle,'\n');
    fprintf(filehandle,['Minimum number of localizations in cluster: ',num2str(merge_min_points)]);
    
    fclose(filehandle);