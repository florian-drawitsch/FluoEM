function [uniqueFraction, uniqueFractionBins] = computeUniqueFraction( neighborCountsAll, distToOriginAll, binSize )
%COMPUTEUNIQUEFRACTION Summary of this function goes here
%   Detailed explanation goes here

% Get Drop List
dropList = nan(numel(neighborCountsAll),1);
for skelIdx = 1:numel(neighborCountsAll)
    neighborCounts = neighborCountsAll{skelIdx};
    distToOrigin = distToOriginAll{skelIdx};
    dropIdx = find(~neighborCounts,1,'first');
    dropDist = distToOrigin(dropIdx);
    if ~isempty(dropDist)
        dropList(skelIdx) = dropDist;
    end
end

% Bin
if isempty(dropList) || sum(isnan(dropList)) == length(dropList)
    uniqueFraction = zeros(1,ceil(max(distToOrigin)/binSize));
    uniqueFractionBins = 0:binSize:max(distToOrigin);
else
    [N, edges] = histcounts(dropList,0:binSize:max(dropList)+binSize);
    uniqueFraction = cumsum(N);
    uniqueFractionBins = edges(1:end-1);
end

