function ExportClusterStatistics(statistics,filename_fullpath)

    statistic_names=fieldnames(statistics);
    D=length(statistic_names);
    N=length(statistics);
    XLSArray=cell(N+1,D);
    
    for i = 1:D
        XLSArray{1,i}=statistic_names{i};
        for j = 1:N
            XLSArray{j+1,i}=statistics(j).(statistic_names{i});
        end
    end

    filehandle = fopen(filename_fullpath,'w');
    [a,b] = size(XLSArray);
    for i = 1:a
        for j =1:b
            if isnumeric(XLSArray{i,j})
                fprintf(filehandle,num2str(XLSArray{i,j}));
            else
                fprintf(filehandle,XLSArray{i,j});
            end
            if j~=b
                fprintf(filehandle,',');
            end
        end
        fprintf(filehandle,'\n');
    end
    
    fclose(filehandle)