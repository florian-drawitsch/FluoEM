function obj = controlPointRemove(obj, treeName, comment)
%CONTROLPOINTREMOVE Summary of this function goes here
%   Detailed explanation goes here

skeletons_available = fieldnames(obj.skeletons);

for i = 1:numel(skeletons_available)
    tn_inds = cellfun(@(x) ~isempty(regexpi(x, ['^',treeName,'.*$'])), obj.controlPoints.(skeletons_available{i}).treeName);
    cm_inds = cellfun(@(x) ~isempty(regexpi(x, ['^',comment,'$'])), obj.controlPoints.(skeletons_available{i}).comment);
    cp_keep_inds = ~(tn_inds & cm_inds);
    obj.controlPoints.(skeletons_available{i}) = obj.controlPoints.(skeletons_available{i})(cp_keep_inds,:);
end

obj = controlPointMatch(obj);

end

