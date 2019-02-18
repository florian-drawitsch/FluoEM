function [points] = getPointsWithName(obj,name,searchMode)
%GETPOINTSWITHNAME Get the points with a specific search criteria
% INPUT:
%       name: the string used for searching (either exact or regexp)
%       searchMode: the type of search used (default: 'exact')
% OUTPUT:
%       points: structure containing the tables of points
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ischar(name)
    name = {name};
end

if ~exist('searchMode','var') || isempty(searchMode)
    searchMode = 'exact';
end

tabs_available = fieldnames(obj.points);

for i = 1:numel(tabs_available)
    for j = 1:numel(name)
        curName = name{j};
        switch searchMode
            case 'exact'
                rowIdx = strcmp(obj.points.(tabs_available{i}).id, curName);
            case 'regexp'
                rowIdx = cellfun(@(x) ~isempty(regexpi(x, curName)), ...
                    obj.points.(tabs_available{i}).id);
        end
        if ~isempty(rowIdx)
            points.(tabs_available{i})=...
                obj.points.(tabs_available{i})(rowIdx, :);
        end
    end
end
end

