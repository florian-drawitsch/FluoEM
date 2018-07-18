function obj = removeControlPoint(obj, treeName, comment)
%REMOVECONTROLPOINT Removes a specified control point 
%   Removes a specified control point from all available control point 
%   tables stored in the object
%   INPUT:  treeName: str
%               Tree name specifying the skeleton tree on which the
%               respective comment is located
%           comment: str
%               Comment specifying the control point to be deleted on the 
%               respective tree.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

skeletons_available = fieldnames(obj.skeletons);

for i = 1:numel(skeletons_available)
    tn_inds = cellfun(@(x) ~isempty(regexpi(x, ['^',treeName,'.*$'])), obj.controlPoints.(skeletons_available{i}).treeName);
    cm_inds = cellfun(@(x) ~isempty(regexpi(x, ['^',comment,'$'])), obj.controlPoints.(skeletons_available{i}).comment);
    cp_keep_inds = ~(tn_inds & cm_inds);
    obj.controlPoints.(skeletons_available{i}) = obj.controlPoints.(skeletons_available{i})(cp_keep_inds,:);
end

obj = cpMatch(obj);

end

