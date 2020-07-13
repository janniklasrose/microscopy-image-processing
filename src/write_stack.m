function write_stack(stack, basename)
    % write a block of image data to slice files along its 4th dimension

    [folder, filename, ext] = fileparts(basename);

    % go through stack
    N = size(stack, 4);
    for i = 1:N

        % name
        prec = ceil(log10(N+1)); % how many digits
        slicename = sprintf(['%s_%0',prec,'i'], filename, i); % add slice number
        file = fullfile(folder, [slicename, '.', ext]);

        % get slice
        slice_im = stack(:, :, :, i);

        % handle extensions differently
        switch lower(ext)
            case {'dcm'}
                dicomwrite_(slice_im, file);
            case {'png', 'jpg', 'jpeg', 'tif', 'tiff'}
                imwrite(slice_im, file);
        end

    end

end

function [success] = dicomwrite_(im, file)

    [Nx, Ny] = size(im, [1, 2]);
    
    success = false;
    counter = 0; % to prevent infinite loop
    while ~success

        % attempt write
        status = dicomwrite(im, file);
        if ~all(structfun(@isempty, status))
            error('write error');
        end

        % check dicom file size
        info = dicominfo(file);
        if info.FileSize == Nx*Ny+908 % "magic number" (data size) + header size 908
            success = true; % so we know we ended because of success
            break;
        else
            counter = counter + 1;
            if counter > 10
                error('cannot write file with correct file size');
            end
        end
    end
    
end
