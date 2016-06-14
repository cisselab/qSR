function SavePairCorrelationOutputs(r,g,Xpos,Ypos,px_size,included_points,save_directory)

%% Save PC Output

% I should also save an image of which points were selected, and a list of
% which points were selected.

pc_data_array=cell(length(r)+1,2);
pc_data_array{1,1} = 'Radius (nm)';
pc_data_array{1,2} = 'g(r)';
for i = 1:length(r)
    pc_data_array{i+1,1}=r(i)*px_size;
    pc_data_array{i+1,2}=g(i);
end

included_data_array=cell(length(included_points)+1,1);
included_data_array{1} = 'True/False This Data point was used in the evaluation of the pair correlation function';
for i = 1:length(included_points)
    included_data_array{i+1}=included_points(i);
end

current_directory=cd;
cd(save_directory)

test_name = 'pair_correlation.csv';
included_data_filename = 'pc_included_points.csv';
count=1;
while exist(test_name,'file')==2
    count = count+1;
    test_name = ['pair_correlation_',num2str(count),'.csv'];
    included_data_filename = ['pc_included_points_',num2str(count),'.csv'];
end

filehandle = fopen([sav_directory,test_name],'w');
[a,b] = size(pc_data_array);
for i = 1:a
    for j =1:b
        if isnumeric(pc_data_array{i,j})
            fprintf(filehandle,num2str(pc_data_array{i,j}));
        else
            fprintf(filehandle,pc_data_array{i,j});
        end
        if j~=b
            fprintf(filehandle,',');
        end
    end
    fprintf(filehandle,'\n');
end

filehandle = fopen([save_directory,included_data_filename],'w');
[a,b] = size(included_data_array);
for i = 1:a
    for j =1:b
        if islogical(included_data_array{i,j})
            fprintf(filehandle,num2str(double(included_data_array{i,j})));
        else
            fprintf(filehandle,included_data_array{i,j});
        end
        if j~=b
            fprintf(filehandle,',');
        end
    end
    fprintf(filehandle,'\n');
end

%% Save Image of PC Region

figure('Visible','Off')
plot(Xpos*px_size/1000,Ypos*px_size/1000,'.','Markersize',2,'Color',[0;0;0]/255)
xlabel('um')
ylabel('um')
title('Data Points used for pair correlation function')
hold on
plot(Xpos(included_points)*px_size/1000,Ypos(included_points)*px_size/1000,'.','Markersize',6,'Color',[213;94;0]/255)
plot_file_name=[included_data_filename(1:end-4),'.jpg'];
saveas(gcf,plot_file_name,'jpg')
close(gcf)

cd(current_directory)