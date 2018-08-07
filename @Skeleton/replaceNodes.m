function skel = replaceNodes(skel, treeIdx, nodes)
%REPLACENODES Replaces all nodes of a given tree
% INPUT treeIdx: int
%           Tree index for which the nodes should be replaced
%       nodes: [N x 3] double
%           New list of nodes replacing the previously contained nodes
%
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Transform nodes
skel.nodes{treeIdx}(:,1:3) = nodes;

% Transform nodes Num Data All
skel.nodesNumDataAll{treeIdx}(:,3:5) = nodes;

% Transform Nodes as struct
x = cellfun(@num2str,num2cell(nodes(:,1)),'UniformOutput',false);
[skel.nodesAsStruct{treeIdx}(:).x] = x{:};
y = cellfun(@num2str,num2cell(nodes(:,2)),'UniformOutput',false);
[skel.nodesAsStruct{treeIdx}(:).y] = y{:};
z = cellfun(@num2str,num2cell(nodes(:,3)),'UniformOutput',false);
[skel.nodesAsStruct{treeIdx}(:).z] = z{:};

end

