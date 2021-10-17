% extract the autofocus map and macro image based on an automatic mask

basename_pattern = 'Slide%03d'; % basename of file (no extension)
stack_indices = 1:312; % indices for basename_pattern
max_lens = 20; % 20x maximum magnification
input_folder = fullfile('data/', 'ndpi/');
output_folder = fullfile('data/', 'ndpi_masked/');
padding_factor = 0.05; % 5% extra

for i = stack_indices
    disp(i);
    filename_i = sprintf(basename_pattern, i);

    % Read image info
    file = fullfile(input_folder, [filename_i, '.ndpi']);
    ndpi = NDPI(file, max_lens);
    macro = ndpi.macro;
    map = imresize(ndpi.map, size(macro, [1, 2])); % scale focus map to size of macro

    % Get region mask
    binary = logical(map); % binarise (has different zones)
    [mask, boundingBox] = get_mask_biggest(binary);

    % Extract images
    map_masked = crop_to_bb(map, boundingBox, padding_factor);
    mask_padded = crop_to_bb(mask, boundingBox, padding_factor);
    macro_masked = crop_to_bb(macro, boundingBox, padding_factor);

    imwrite_safe(map_masked, fullfile(output_folder, 'map', [filename_i, '.png']));
    imwrite_safe(mask_padded, fullfile(output_folder, 'mask', [filename_i, '.png']));
    imwrite_safe(macro_masked, fullfile(output_folder, 'macro', [filename_i, '.jpg']));

end

%% Auxiliary functions

function [mask, bbox] = get_mask_biggest(bw)
% get the binary mask and bounding box of the biggest contiguous region

props = regionprops(bw, {'Area', 'BoundingBox', 'PixelIdxList'});
[~, max_idx] = max([props.Area]);
mask_prop = props(max_idx);
mask = false(size(bw));
mask(mask_prop.PixelIdxList) = true;
bbox = mask_prop.BoundingBox;

end

function [image] = crop_to_bb(image, bbox, pad)
% crop an image to the provided bounding box with optional padding

if nargin < 3
    pad = 0;
end
validateattributes(pad, 'numeric', {'scalar', 'nonnegative', 'finite'});

bbox_min = floor(bbox(1:2));
bbox_max = bbox_min + ceil(bbox(3:4));
padding = round(pad*(bbox_max-bbox_min));
imin = bbox_min(2)-padding(2);
imax = bbox_max(2)+padding(2);
jmin = bbox_min(1)-padding(1);
jmax = bbox_max(1)+padding(1);

image = image(max(1, imin):min(end, imax), max(1, jmin):min(end, jmax), :);

end

function [] = imwrite_safe(im, filepath)
% write image to path, ensures the file can be written to

% Create the file's folder if necessary
[folder, ~] = fileparts(filepath);
[~, ~] = mkdir(folder);

% Call imwrite, should be safe now
imwrite(im, filepath);

end
