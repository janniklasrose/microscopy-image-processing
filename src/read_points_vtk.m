function [points] = read_points_vtk(filename, onlyReadMetaData)
    % read points from binary VTK file

    if nargin == 1
        onlyReadMetaData = false;
    end

    fid = fopen(filename,'r');
    assert(fid ~= -1, 'Cannot open the file');

    % file version and identifier
    str0 = fgets(fid); %# vtk DataFile Version <VERSION>
    assert(strcmp(str0(3:5), 'vtk'), 'File is not VTK format compliant');
    % header
    str1 = fgets(fid); %<COMMENT>
    % file format
    str2 = fgets(fid); %BINARY
    assert(strcmpi(str2(1:6), 'binary'), 'Can only read BINARY vtk files');
    % dataset structure and other related tags
    str3 = fgets(fid); %DATASET STRUCTURED_POINTS
    str4 = fgets(fid); %DIMENSIONS <Nx> <Ny> <Nz>
    str5 = fgets(fid); %SPACING <dx> <dy> <dz>
    str6 = fgets(fid); %ORIGIN <x0> <y0> <z0>
    % dataset attributes
    str7 = fgets(fid); %POINT_DATA <npoints>
    npoints = sscanf(str7, '%*s %d', 1);
    str8 = fgets(fid); %SCALAR scalars unsigned_char 1
    str9 = fgets(fid); %LOOKUP_TABLE default

    if onlyReadMetaData
        fprintf('HEADER:\n');
        fprintf(repmat('%s', [1, 10]), ... % str# already have \n
            str0, str1, str2, str3, str4, str5, str6, str7, str8, str9);
        points = {};
        return;
    end

    % read vertices
    [vertex, count] = fread(fid, npoints, 'uchar');
    assert(count == npoints, 'Problem in reading points.');
    maxval = max(vertex, 'all');
    % save storage but make sure we are not losing information
    for uint_size = [64, 32, 16, 8]
        type = sprintf('uint%d', uint_size);
        if maxval <= intmax(type)
            casttype = type;
        end
    end % this loop is not guaranteed to return a casttype, but uint64 is HUGE
    points = cast(vertex, casttype);

    % read polygons
    eof = fgets(fid);
    assert(eof == -1, 'Not at the end of file.');
    fclose(fid);

end
