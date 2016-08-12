function SaveRegionsOfInterest(hObject,handles,ROI_list_file_path)

ROI_cell=handles.ROIs;

fhandle=fopen(ROI_list_file_path,'w');
fprintf(fhandle,'Left Boundary(nm),Right Boundary(nm),Bottom Boundary(nm),Top Boundary(nm)');
for i = 1:length(ROI_cell)
    fprintf(fhandle,'\n');
    fprintf(fhandle,[num2str(ROI_cell{i}(1)),',',num2str(ROI_cell{i}(1)+ROI_cell{i}(3)),',',...
        num2str(ROI_cell{i}(2)),',',num2str(ROI_cell{i}(2)+ROI_cell{i}(4))]);
end
fclose(fhandle);
    