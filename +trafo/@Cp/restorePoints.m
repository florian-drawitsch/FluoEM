function obj = restorePoints(obj, restoreIds, searchMode)
%RESTOREPOINTS Summary of this function goes here
%   Detailed explanation goes here

if ischar(restoreIds)
    restoreIds = {restoreIds};
end

if ~exist('searchMode','var') || isempty(searchMode)
    searchMode = 'exact';
end

tabs_available = fieldnames(obj.pointsDeleted);

for i = 1:numel(tabs_available)
    for j = 1:numel(restoreIds)
        restoreId = restoreIds{j};
        switch searchMode
            case 'exact'
                rowIdx = strcmp(obj.pointsDeleted.(tabs_available{i}).id, restoreId);
            case 'regexp'
                rowIdx = cellfun(@(x) ~isempty(regexpi(x, restoreId)), obj.pointsDeleted.(tabs_available{i}).id);
        end
        if ~isempty(rowIdx)
            if ~any(strcmp(fieldnames(obj.pointsDeleted),tabs_available{i}))
                obj.points.(tabs_available{i}) = obj.pointsDeleted.(tabs_available{i})(rowIdx, :);
            else
                obj.points.(tabs_available{i}) = [obj.points.(tabs_available{i}); obj.pointsDeleted.(tabs_available{i})(rowIdx, :)];
            end
            obj.pointsDeleted.(tabs_available{i})(rowIdx, :) = [];
        end
    end
end

obj = obj.match;

end

