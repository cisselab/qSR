function interior_indices=ROIsInBox(ROIs,box)
    interior_indices=false(1,length(ROIs));
    for i = 1:length(ROIs)
        if ROIs{i}(1)>box(1)
            if ROIs{i}(2)>box(2)
                if (ROIs{i}(1)+ROIs{i}(3))<(box(1)+box(3))
                    if (ROIs{i}(2)+ROIs{i}(4))<(box(2)+box(4))
                        interior_indices(i)=true;
                    end
                end
            end
        end
    end
end