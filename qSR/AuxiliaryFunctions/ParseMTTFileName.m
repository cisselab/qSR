function [cell_num,color_out] = ParseMTTFileName(filename)
    
    cell_loc = strfind(lower(filename), 'cell');
    
    if ~isempty(cell_loc)
        test_idx = cell_loc(end)+4;
        numstr = '';

        while ismember(filename(test_idx),{'0','1','2','3','4','5','6','7','8','9'})
            numstr(end+1) = filename(test_idx);
            test_idx = test_idx +1;
        end

        try
            cell_num = str2double(numstr);
        catch
            cell_num = 0;
        end
    else
        cell_num=nan;
    end
    is646 = or(~isempty(strfind(filename, '646')),~isempty(strfind(filename, '642')));
    is488 = ~isempty(strfind(filename, '488'));
    isPALM = ~isempty(strfind(upper(filename), 'PALM'));
    isDIA = ~isempty(strfind(lower(filename), 'dia'));
    
    if all([is646,~is488,~isPALM])
        color_out = '646';
    elseif all([~is646,is488,~isPALM])
        color_out = '488';
    elseif all([~is646,~is488,isPALM])
        color_out = 'PALM';
    elseif isDIA
        color_out = 'dia';
    else
        color_out = 'uhoh';
        display(filename)
        warning([filename,' is not a valid filename'])
    end
    
end