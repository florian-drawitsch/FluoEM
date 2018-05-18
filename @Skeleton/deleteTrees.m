function obj = deleteTrees(obj, treeIndices)
% Delete specified trees.
% INPUT treeIndices: [Nx1] int or [Nx1] logical
%           Array with linear or logical indices of trees to delete.
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

if iscolumn(treeIndices)
    treeIndices = treeIndices';
end

%get ids of deleted nodes
nodeIDs = cell2mat(cellfun(@(x)x(:,1),obj.nodesNumDataAll(treeIndices), ...
    'UniformOutput',false));

%delete tree
obj.nodes(treeIndices) = [];
obj.nodesAsStruct(treeIndices) = [];
obj.nodesNumDataAll(treeIndices) = [];
obj.thingIDs(treeIndices) = [];
obj.names(treeIndices) = [];
obj.colors(treeIndices) = [];
obj.edges(treeIndices) = [];
obj.branchpoints = setdiff(obj.branchpoints,nodeIDs);

%set largest object id if it was deleted
if any(nodeIDs == obj.largestID)
    obj.largestID = max(cellfun(@(x)max(x(:,1)),obj.nodesNumDataAll));
end

end
