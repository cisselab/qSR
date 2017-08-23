function Randomize_qSR(directory)


       %workflow: Open qSR with specific file. Open corresponding 488
       %image. If the cell has already been analyzed, say so in a pop-up.
       %Advance to next cell upon closing qSR.

%% Find all 488 and PALM images

    PALM_files = dir_rec('*PALM*_results.mat');
    pre_files = dir_rec('*488*.ome.tif');

%% Link the 488 and PALM images


    folder_id_pre = zeros(1,length(pre_files));
    cell_id_pre = zeros(1,length(pre_files));
    
    folder_id_PALM = zeros(1,length(PALM_files));
    cell_id_PALM = zeros(1,length(PALM_files));
    
    folder_dictionary = {}; %Records the names of every experiment folder.

    current_file_struct = dir(pre_files{1});
    current_folder = current_file_struct.folder;

    filesep_locs = strfind(current_folder,filesep);
    current_folder = current_folder(1:filesep_locs(end));

    folder_dictionary{1} = current_folder;

    % Determine which experiment and which cell number within the
    % experiment the file belongs to. 
    for i = 1:length(pre_files)
        current_file_struct = dir(pre_files{i});
        current_folder = current_file_struct.folder;
        filesep_locs = strfind(current_folder,filesep);
        current_folder = current_folder(1:filesep_locs(end));
        for j = 1:length(folder_dictionary)
            if strcmp(folder_dictionary{j},current_folder)
                folder_id_pre(i) = j;
                break
            elseif j == length(folder_dictionary)
                folder_id_pre(i) = j+1;
                folder_dictionary{end+1} = current_folder;
            end
        end
        
        [cell_id_pre(i),~] = ParseMTTFileName(pre_files{i});
        
    end
    
    for i = 1:length(PALM_files)
        current_file_struct = dir(PALM_files{i});
        current_folder = current_file_struct.folder;
        filesep_locs = strfind(current_folder,filesep);
        current_folder = current_folder(1:filesep_locs(end));
        for j = 1:length(folder_dictionary)
            if strcmp(folder_dictionary{j},current_folder)
                folder_id_PALM(i) = j;
                break
            elseif j == length(folder_dictionary)
                folder_id_PALM(i) = j+1;
                folder_dictionary{end+1} = current_folder;
            end
        end
        
        [cell_id_PALM(i),~] = ParseMTTFileName(PALM_files{i});
        
    end

%% Randomize the order

    random_order = randperm(numel(PALM_files));

%% Call qSR sequentially on the PALM images while opening the corresponding 488. 
    
    for i = 1:numel(PALM_files)
        % Create a popup with a "Continue" button that lets you advance to the
        % next cell. 
        f1 = figure;
        h = uicontrol('Position',[20 20 200 40],'String','Continue',...
                      'Callback','uiresume(gcbf)');
        
        current_file_id = folder_id_PALM(random_order(i));
        current_cell_id = cell_id_PALM(random_order(i));
        
        is_corresponding = and(folder_id_pre == current_file_id     ,   cell_id_pre == current_cell_id) ; 
        
        switch sum(is_corresponding)
            case 1
                %Create an average projection 488 image.
                current_488_file = pre_files{is_corresponding};
                number_of_frames = numel(imfinfo(current_488_file));
                current_frame = imread(current_488_file,1);
                mean_image = zeros(size(current_frame));
                for j = 1:number_of_frames
                    current_frame = double(imread(current_488_file,j));
                    mean_image = mean_image + current_frame;
                end
                mean_image = uint16(round(mean_image / number_of_frames));

                f2 = figure;
                imshow(mean_image(:,end:-1:1)')
                imcontrast
            case 0
                display('No corresponding 488 could be identified')
            otherwise
                display('A corresponding 488 could not be unambiguously identified')
        end
                
        

        display('Add check for analyzed files.')
        current_PALM_file = PALM_files{random_order(i)};
        qSR(current_PALM_file)   

        % Pause here until the user presses "Continue"
        uiwait(f1);
        
        try
            close(f1);
        catch
        end
        
        try
            close(f2);
        catch
        end
    end
