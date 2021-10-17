classdef NDPI < handle
    %NDPI Represents an .ndpi image object
    %   The NDPI format is just an extension of TIFF with extra tags.
    %   See e.g. https://openslide.org/formats/hamamatsu/

    % Constructor
    methods
        function obj = NDPI(filename, max_lens)
            %NDPI Construct an instance of an .ndpi file wrapper
            %   Provide the filename and maximum lens magnification
            obj.finfo = get_ndpi_imfinfo(filename);
            obj.max_lens = max_lens;
        end
    end
    properties(GetAccess='private', SetAccess='immutable')
        finfo
        max_lens(1, 1) {mustBeFinite, mustBeNonnegative, mustBeNumeric};
    end

    % Image names = Magnification levels
    properties(Dependent)
        NumberOfImages
        ImageNames
    end
    methods
        function [N] = get.NumberOfImages(obj)
            N = numel(obj.finfo);
        end
        function [names] = get.ImageNames(obj)
            names = cell(obj.NumberOfImages);
            names{end} = 'map';
            names{end-1} = 'macro';
            for i = 1:numel(names)-2
                magnification = obj.max_lens * obj.finfo(i).Width/obj.finfo(1).Width;
                names{i} = ['x', num2str(magnification)]; % e.g. x1.25
            end
        end
    end

    % Images (by name)
    properties(Dependent)
        map % autofocus map
        macro % macro lens (same aspect ratio as map)
        % the other images, named x###, are obtained dynamically
    end
    methods
        function [im] = get.map(obj)
            im = obj.get_image(obj.NumberOfImages);
        end
        function [im] = get.macro(obj)
            im = obj.get_image(obj.NumberOfImages - 1);
        end
    end

    % Images (by index)
    methods
        function [im] = get_image(obj, ID)
            if ~isnumeric(ID)
                validatestring(ID, obj.ImageNames);
                idx = find(strcmp(obj.ImageNames, ID));
                im = obj.get_image(idx); % call routine with numeric index
                return
            end
            validateattributes(ID, 'numeric', {'scalar', 'integer', 'nonnegative', 'finite'});
            im = imread(obj.finfo(ID).Filename, ID);
        end
    end

end

function [info] = get_ndpi_imfinfo(filename)
% get imfinfo from ndpi file

% ensure correct extension
[~, ~, ext] = fileparts(filename);
if isempty(ext) || ~strcmpi(ext, '.ndpi')
    filename = [filename, '.ndpi']; % append correct extension
end

% temporarily disable warnings regarding TIFF tags
oldwarn = warning('query', 'imageio:tifftagsread:expectedTagDataFormat');
warning('off', oldwarn.identifier);

% read image file info
info = imfinfo(filename);

% process result
... %TODO: validate file format?

% restore warnings regarding TIFF tags
warning(oldwarn.state, oldwarn.identifier);

end
