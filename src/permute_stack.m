function [stack] = permute_stack(stack, dim)
    % permute a stack so that DIM is the 4th dimension

    if ~ischar(dim)
        dim = dimension_char(dim);
    end

    switch dim
        case 'x'
            permute_dims = [2, 3, 4, 1];
        case 'y'
            permute_dims = [1, 3, 4, 2];
        case 'z'
            permute_dims = [1, 2, 4, 3];
        case {'c', 't'} % colour or time
            permute_dims = 1:4; % do nothing
        otherwise
            error('invalid dim');
    end

    stack = permute(stack, permute_dims);

end
