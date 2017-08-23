function file_paths = dir_rec(name_pattern)

    this_dir = cd;
    file_struct = dir(name_pattern);
    if length(file_struct)>0
        for i = 1:length(file_struct)
            file_paths{i}=[this_dir,filesep,file_struct(i).name];
        end
    else
        file_paths = [];
    end
    
    cd_struct = dir;
    
    is_dir_in_cd = false(1,length(cd_struct));
    is_super=false(1,length(cd_struct));
    for i = 1:length(cd_struct)
        is_dir_in_cd(i) = cd_struct(i).isdir;
        is_super(i)=strcmp(cd_struct(i).name(1),'.');
    end
    
    is_sub_dir = and(is_dir_in_cd,~is_super);
    sub_dirs = cd_struct(is_sub_dir);
    for i = 1:length(sub_dirs)
        cd(sub_dirs(i).name)
        cd
        rec_file_paths = dir_rec(name_pattern);
        if length(rec_file_paths)>0
            file_paths=[file_paths(:);rec_file_paths(:)];
        end
        cd('..')
    end
    
end
    
    