function [flipped_data] = flip_data(unflipped_data)
    if size(unflipped_data,1) > 1
        flipped_data = unflipped_data;
    else
        flipped_data = unflipped_data';
    end
end