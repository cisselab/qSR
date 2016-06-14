function SaveFilterStatus(hObject,handles,save_filename_full_path)
    fhandle=fopen(save_filename_full_path,'w');
    switch handles.which_filter
        case 'raw'
            fprintf(fhandle,'Filter: Raw \n')
            if get(handles.RestrictToNuclear,'Value')
                fprintf(fhandle,'Restricted to Nucleus: Yes \n');
            else
                fprintf(fhandle,'Restricted to Nucleus: No \n');
            end
            
        case 'iso'
            fprintf(fhandle,'Filter: Isolation \n');
            if get(handles.RestrictToNuclear,'Value')
                fprintf(fhandle,'Restricted to Nucleus: Yes \n');
            else
                fprintf(fhandle,'Restricted to Nucleus: No \n');
            end
            radius = get(handles.IsoLengthScale,'String');
            fprintf(fhandle,['Radius: ',radius,' (nm)']);
        case 'quick'
            fprintf(fhandle,'Filter: SpatioTemporalMerge \n');
            if get(handles.RestrictToNuclear,'Value')
                fprintf(fhandle,'Restricted to Nucleus: Yes \n');
            else
                fprintf(fhandle,'Restricted to Nucleus: No \n');
            end
            sigma = get(handles.QuickMergeLengthScale,'String');
            dark_time = get(handles.DarkTimeTolerance,'String'); 
            min_points = get(handles.QuickMergeMinPoints,'String');
            fprintf(fhandle,['Radius: ',sigma,' (nm) \n']);
            fprintf(fhandle,['Dark Time Tolerance: ',dark_time,' (frames) \n']);
            fprintf(fhandle,['Minimum Points: ',min_points]);
    end
    fclose(fhandle);