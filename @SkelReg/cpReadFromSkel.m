function obj = cpReadFromSkel(obj, commentPattern, idGenerator)
%READCONTROLPOINTS Reads control points from skeleton comments 
%   Reads control points from skeleton comments  matching the provided
%   commentPattern by calling the static comments2table method for each
%   available skeleton
%   INPUT:  commentPattern (optional): str
%               Regular expression pattern specifying which webKnossos
%               skeleton comments should be read as control points
%           idGenerator (optional): function handle or anonymous function
%               Defines the rule creating table ids from webKnossos tree
%               names. These table ids are used for the table join
%               operations matching the control point tables of the
%               modalities to be registered.
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