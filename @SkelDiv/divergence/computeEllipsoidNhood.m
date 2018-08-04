function nodesRefNeighbors = computeEllipsoidNhood( skelRef, skelRefTreeIdx, skelTar, skelTarTreeInds, ellipsoidRadii )
%COMPUTEELLIPSOIDNHOOD computes the skeleton neighbors contained in an   
% ellipsoid neighborhood defined sucessively around each node of a 
% reference skeleton
%   INPUT:  skelRef: skeleton object
%               Skeleton object containing the reference tree for which the 
%               neighbors should be computed
%           skelRefReeIdx: integer
%               Tree index of the reference for which the neighbors should
%               be computed
%           skelTar: skeleton object
%               Skeleton object containing the target trees representing
%               the potential neighbors
%           skelTarTreeInds: [1 x N] integer
%               Tree indices of the targets representing the potential
%               neighbors
%           ellipsoidRadii: [1 x 3] double
%               Dimensions of the marching ellipsoid used to compute the
%               neighborhood criterion
%   OUTPUT: nodesRefNeighbors: [M x 1] cell
%               Cell array containing a binary vector of neighbors for each
%               node of the reference tree
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Prepare Nodes
nodesRef = skelRef.nodes{skelRefTreeIdx};
nodesRefR = bsxfun(@times, nodesRef(:,1:3), skelRef.scale);
nodesTar = cat(1, cell2mat(skelTar.nodes(skelTarTreeInds)));
nodesTarR = bsxfun(@times, nodesTar(:,1:3), skelTar.scale);
nodesTarNums = cellfun(@(x) size(x,1), skelTar.nodes(skelTarTreeInds));
nodesTarSkelInds = cell2mat(arrayfun(@(x,y) repelem(x,y)', skelTarTreeInds', nodesTarNums, 'UniformOutput', false));

% Define Ellipsoid
insideEllipsoid = @(x,y,z) (x./ellipsoidRadii(1)).^2 + (y./ellipsoidRadii(2)).^2 + (z./ellipsoidRadii(3)).^2 < 1;

% Calculate Neigbors
nodesRefNeighbors = cell(size(nodesRefR,1), 1);
for nodeIdx = 1:size(nodesRefR, 1)
    nodeRef = nodesRefR(nodeIdx, :);
    nodeRefTarsDiff = repmat(nodeRef, size(nodesTarR, 1), 1) - nodesTarR;
    insideMask = insideEllipsoid(nodeRefTarsDiff(:,1), nodeRefTarsDiff(:,2), nodeRefTarsDiff(:,3));
    insideSkelInds = unique(nodesTarSkelInds(insideMask));
    nodesRefNeighbors{nodeIdx} = insideSkelInds;
end


