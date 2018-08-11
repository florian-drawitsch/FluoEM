function obj = deletePoints(obj, delIds, searchMode)
%DELETEPOINT Summary of this function goes here
%   Detailed explanation goes here

if ischar(delIds)
    delIds = {delIds};
end

if ~exist('searchMode','var') || isempty(searchMode)
    searchMode = 'exact';
end

tabs_available = fieldnames(obj.points);
tabs_available(strcmp(tabs_available, 'matched')) = [];

for i = 1:numel(tabs_available)
    for j = 1:numel(delIds)
        delId = delIds{j};
        switch searchMode
            case 'exact'
                rowIdx = strcmp(obj.points.(tabs_available{i}).id, delId);
            case 'regexp'
                rowIdx = cellfun(@(x) ~isempty(regexpi(x, delId)), obj.points.(tabs_available{i}).id);
        end
        if ~isempty(rowIdx)
            if ~any(strcmp(fieldnames(obj.pointsDeleted),tabs_available{i}))
                obj.pointsDeleted.(tabs_available{i}) = obj.points.(tabs_available{i})(rowIdx, :);
            else
                obj.pointsDeleted.(tabs_available{i}) = [obj.pointsDeleted.(tabs_available{i}); obj.points.(tabs_available{i})(rowIdx, :)];
            end
            obj.points.(tabs_available{i})(rowIdx, :) = [];
        end
    end
end

obj = obj.match;

end

