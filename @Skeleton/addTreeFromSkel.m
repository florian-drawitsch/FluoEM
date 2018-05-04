function obj = addTreeFromSkel(obj, skel, treeIndices, treeNames)
%Add trees from another Skeleton.
% INPUT skel: A Skeleton object different from the one calling
%             this function.
%       treeIndices: (Optional) Linear indices of the trees in
%             skel to add to obj.
%             (Default: all trees in skel).
%       treeNames: (Optional) Cell array of same length as
%           treeIndices containing the names for the trees in
%           skel which are added to obj.
%           (Default: Tree names in skel).
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeIndices)
    treeIndices = 1:skel.numTrees();
elseif ~isrow(treeIndices)
    treeIndices = treeIndices';
end

if exist('treeNames','var') && length(treeNames) ~= length(treeIndices)
    error('A name must be specified for each tree which is added to the Skeleton');
end

%add trees to obj
for tr = treeIndices
    if exist('treeNames','var')  && ~isempty(treeNames)
        obj = obj.addTree(treeNames{tr}, skel.nodes{tr}, skel.edges{tr});
    else
        obj = obj.addTree(skel.names{tr}, skel.nodes{tr}(:,1:3), skel.edges{tr});
    end
    [obj.nodesAsStruct{end}.comment] = skel.nodesAsStruct{tr}.comment;
end
end
