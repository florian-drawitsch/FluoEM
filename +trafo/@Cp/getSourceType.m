function sourceType = getSourceType(source)
%GETSOURCETYPE Summary of this function goes here
%   Detailed explanation goes here

msg = 'Not a valid source type. Please provide either a skeleton object, a .nml filepath or a .csv filepath';

if ischar(source) && isfile(source)
    [~, ~, ext] = fileparts(source);
    if strcmp(ext,'.nml')
        sourceType = 'nml';
    elseif strcmp(ext, '.csv')
        sourceType = 'csv';
    else
        error(msg);
    end
elseif isa(source, 'Skeleton')
    sourceType = 'skel';
else
    error(msg);
end



