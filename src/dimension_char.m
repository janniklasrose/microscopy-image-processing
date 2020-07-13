function [dim] = dimension_char(dim)
    % convert between [ 1 | 2 | 3 ] and [ 'x' | 'y' | 'z' ]

    if ischar(dim)
        dim = native2unicode(dim) - unicode2native('x') + 1 ;
    else % is not char
        dim = unicode2native('x') + dim - 1;
    end

end
