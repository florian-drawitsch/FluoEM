function [neighborCounts, neighborIDs, distToOrigin] = axonPersistence( skelRef, skelRefIdx, nodesRefNeighbors, origin )
%AXONPERSISTENCE Computes persistent skelTar neighbors of skelRef trees 
%relative to the euclidean distance to the specified origin
%   INPUT: skelRef: skeleton object
%               Skeleton object containing the reference tree(s) for which the 
%               neighbors should be computed
%           skelRefTreeIdx: integer
%               Tree index of the reference skeleton object for which the 
%               neighbors should be computed
%           nodesRefNeighbors: [N x 1] cell
%               Cell array containing a binary vector of neighbors for each
%               node of the reference tree
%           origin: [1 x 3] double
%               Center point of the common origin bounding box
%   OUTPUT: neighborCounts: [N x 1] doubel
%               Number of neighbors for specified skelRef tree at given 
%               dist from origin
%           neighborIDs: [N x 1] cell array
%               Neighbor IDs for specified skelRef tree at given 
%               dist from origin
%           distToOrigin: [N x 1] double
%               Euclidean dists for specified skelRef tree 
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Sort nodesRefNeighbors according to distance to origin
dto = util.normList(bsxfun(@times, skelRef.nodes{skelRefIdx}(:,1:3) - repmat(origin,size(skelRef.nodes{skelRefIdx},1),1),skelRef.scale));
[distToOrigin, inds] = sort(dto,'ascend');
neighborIDsRaw = nodesRefNeighbors(inds);
maxTreeID = max(cat(1,cell2mat(neighborIDsRaw)));

% Create Neighbor Matrix
NM = zeros(numel(neighborIDsRaw),maxTreeID);
for nodeIdx = 1:numel(neighborIDsRaw)
    ids = neighborIDsRaw{nodeIdx};
    NM(nodeIdx,ids) = 1;
end

% Impose Persistence Zeros
for skelIdx = 1:maxTreeID
   lostIdx = find(~NM(:,skelIdx),1,'first');
   if ~isempty(lostIdx)
       NM(lostIdx:end,skelIdx) = 0;
   end
end

% Retrieve Persistent IDs
neighborIDs = cell(numel(neighborIDsRaw),1);
for nodeIdx = 1:numel(neighborIDsRaw)
    neighborIDs{nodeIdx,1} = find(NM(nodeIdx,:))';
end

neighborCounts = sum(NM,2);
