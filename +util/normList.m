function dists = normList( nodes, scale )
%NORMLIST Returns the 2-norms (relative to origin) of all row vectors of a 
%N x 3 matrix
%   INPUT:  nodes: [N x 3] double
%               List of nodes in 3D
%           scale (optional): [1 x 3] double
%               Scale vector to be applied to the nodes
%   OUTPUT: dists: [N x 1] double
%               List of 2-norms
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if exist('scale','var')
    nodes = (diag(scale) * nodes')';
end

dists = sqrt(sum(nodes.^2,2));

end

