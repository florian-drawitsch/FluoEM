function obj = readFromSkel(obj, skel, type, commentPattern, idGenerator)
%READFROMSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('type', 'var') || isempty(type)
    type = 'undefined';
end

if ~exist('commentPattern','var') || isempty(commentPattern)
    commentPattern = '^b\d+$';
end

if ~exist('idGenerator','var') || isempty(idGenerator)
    idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
end

obj.points.(type) = parseSkel(skel, commentPattern, idGenerator);

end


