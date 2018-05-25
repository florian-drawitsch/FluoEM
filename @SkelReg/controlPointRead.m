function obj = controlPointRead(obj, commentPattern, idGenerator)
%UPDATECONTROLPOINTS Summary of this function goes here
%   Detailed explanation goes here

if ~exist('commentPattern','var') || isempty(commentPattern)
    commentPattern = '^b\d+$';
end

if ~exist('idGenerator','var') || isempty(idGenerator)
    idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
end

skeletons_available = fieldnames(obj.skeletons);

for i = 1:numel(skeletons_available)
    obj.controlPoints.(skeletons_available{i}) = SkelReg.comments2table(obj.skeletons.(skeletons_available{i}), commentPattern, idGenerator);
end


end