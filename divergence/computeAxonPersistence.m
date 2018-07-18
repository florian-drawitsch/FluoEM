function [neighborCounts, neighborIDs, distToOrigin] = computeAxonPersistence( skelRef, skelRefIdx, nodesRefNeighbors, origin )
%COMPUTEAXONPERSISTENCE Summary of this function goes here
%   Detailed explanation goes here

% Sort nodesRefNeighbors according to distance to origin
dto = normList(bsxfun(@times, skelRef.nodes{skelRefIdx}(:,1:3) - repmat(origin,size(skelRef.nodes{skelRefIdx},1),1),skelRef.scale));
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
