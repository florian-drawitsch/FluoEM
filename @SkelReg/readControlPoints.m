function obj = readControlPoints(obj, commentPattern, idGenerator)
%READCONTROLPOINTS Reads control points from skeleton comments matching the 
% provided commentPattern by calling the static comments2table method
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

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