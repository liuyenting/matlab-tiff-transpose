function convert_stack(in_dir,out_dir,prefix)
%CONVERT_STACK Converts volume based TIFF to time sequence based TIFF.
%   CONVERT_STACK(IN_DIR,OUT_DIR,PREFIX) reads all the TIFF stacks from
%   IN_DIR, and generate the transposed TIFF stacks with PREFIX and layer
%   number as the filename in the OUT_DIR.

file_list = retrieve_tiff_list(in_dir);
if exist(out_dir,'dir')
    error('Output folder already exits.');
else
    mkdir(out_dir);
end

% Acquire stack info from the 1st file.
total_layer = length(imfinfo(file_list{1}));
layer_cnt = 1;
while (layer_cnt <= total_layer)
    fprintf('Processing %d of %d\n', layer_cnt,total_layer);
    filename = sprintf('%s%s%s%d.tif', out_dir,filesep,prefix,layer_cnt);

    imwrite(imread(file_list{1}, layer_cnt), filename);
    for i = 2:length(file_list)
        imwrite(imread(file_list{i}, layer_cnt), filename, ...
                'WriteMode', 'Append');
    end
    
    layer_cnt = layer_cnt+1;
end

end


%-------------------------------------------------------------------------
function L = retrieve_tiff_list(folder)

total_list = dir(folder);
selection = arrayfun(@isValidFile, total_list, 'UniformOutput', true);
tiff_list = extractfield(total_list(selection), 'name');

L = arrayfun(@(fn)(strcat(folder,filesep,fn)), tiff_list);

end


%-------------------------------------------------------------------------
function result = isValidFile(file_struct)

[~, ~, ext] = fileparts(file_struct.name);
if ~(strcmp(ext,'.tif') || strcmp(ext,'.tiff'))
    result = false;
else
    if file_struct.isdir
        result = false;
    else
        result = true;
    end
end

end
