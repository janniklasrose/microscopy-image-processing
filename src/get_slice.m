function [slice] = get_slice(stack, dim, num)
    % get slice NUM along dimension DIM from stack

    switch dim
        case 'x'
            slice = stack(num, :, :, :);
        case 'y'
            slice = stack(:, num, :, :);
        case 'z'
            slice = stack(:, :, num, :);
    end

end
