function nodes = getNodes(obj, treeIndices, nodeIndices, toNM)
%GETNODES Return all nodes of the specified trees.
% INPUT treeIndices: (optional) [Nx1] int or logical
%           Linear or logical indices of the trees for which the nodes are
%           returned. If several trees are specified the nodes will be
%           concatenated. Only the coordinates of nodes are returned.
%           (Default: 1:obj.numTrees())
%       nodeIndices: (Optional) [Nx1] cell of [Nx1] int or logical
%           Linear or logical indices for the nodes of the respective input
%           tree. length(nodeIndices) should correspond to the requested
%           number of input trees. If only one input tree is requested then
%           nodeIndices can be be passed directly as the node index array.
%           (Default: all nodes of the tree)
%       toNM: logical
%           Convert node coordinates to nm using obj.scale
%           (Default: false)
% OUTPUT nodes: [Nx3] int or double
%           The requested nodes. If toNM is true then the output will be
%           double otherwise as in skel.nodes.
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

if ~exist('treeIndices', 'var') || isempty(treeIndices)
    treeIndices = true(obj.numTrees(),1);
end

nodes = obj.nodes(treeIndices);

if exist('nodeIndices', 'var') && ~isempty(nodeIndices)
    if iscell(nodeIndices) && length(nodeIndices) == length(nodes)
        nodes = cellfun(@(x, y) x(y,:), nodes, nodeIndices, ...
            'UniformOutput', false);
        nodes = cell2mat(nodes);
    elseif islogical(nodeIndices) || isnumeric(nodeIndices)
        nodes = nodes{1}(nodeIndices,:);
    else
        error('Specify the node indices for each input tree.');
    end
else
    nodes = cell2mat(nodes);
end
nodes = nodes(:, 1:3);
if exist('toNM', 'var') && toNM
    nodes = bsxfun(@times, double(nodes), obj.scale);
end
end