function [] = show_sides(X, Y, Z, V, varargin)
    % show the sides of a 3D block as surfaces

    % get current axis
    h = gca();
    washold = ishold(h);

    % plot all surfaces
    hold('on');
    surf_(X( 1 ,  : ,  : ), Y( 1 ,  : ,  : ), Z( 1 ,  : ,  : ), V( 1 ,  : ,  : ), varargin{:});
    surf_(X(end,  : ,  : ), Y(end,  : ,  : ), Z(end,  : ,  : ), V(end,  : ,  : ), varargin{:});
    surf_(X( : ,  1 ,  : ), Y( : ,  1 ,  : ), Z( : ,  1 ,  : ), V( : ,  1 ,  : ), varargin{:});
    surf_(X( : , end,  : ), Y( : , end,  : ), Z( : , end,  : ), V( : , end,  : ), varargin{:});
    surf_(X( : ,  : ,  1 ), Y( : ,  : ,  1 ), Z( : ,  : ,  1 ), V( : ,  : ,  1 ), varargin{:});
    surf_(X( : ,  : , end), Y( : ,  : , end), Z( : ,  : , end), V( : ,  : , end), varargin{:});

    % prettify
    axis('equal');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    axis('tight');
    colormap(jet(200));
    colorbar('off');

    % restore
    if ~washold
        hold('off');
    end

end

function [h] = surf_(x, y, z, v, varargin)

    h = surf(prep(x), prep(y), prep(z), prep(v), varargin{:});

    function [d] = prep(d)
        d = double(squeeze(d));
    end

end
