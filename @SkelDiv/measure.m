function obj = measure(obj)
%MEASURE Performs the divergence measurements
% For each tree contained in the reference skeleton object skelDiv measures
% the number of neighboring trees contained in the target skeleton
% object in dependence of the euclidean distance to a defined common
% origin bounding box. The neighbor criterion is implemented via a
% moving ellipsoid which is shifted outward from the origin along the
% skeleton trees. A given target skeleton tree is counted as a neighbor
% at a given location when at least one of it's nodes is encompassed by
% the ellipsoid. Such trees having violated the neighbouring criterion
% only once, permanently loose their status as potential neighbors.

% Restrict to bbox
bboxOld = util.bbox.convertBbox(obj.options.bboxOrigin);
bboxCenter = mean(reshape(bboxOld,[3 2]),2)';
rd = floor(obj.options.bboxRestrictExtent ./ obj.skelRef.scale ./2);
bboxRestrict = round([bboxCenter - rd; bboxCenter + rd]');
if obj.options.bboxRestrictActive
    obj.skelRef = obj.skelRef.restrictToBBox(bboxRestrict);
    obj.skelTar = obj.skelTar.restrictToBBox(bboxRestrict);
end

% Measure Divergence all
origin = round(obj.options.bboxOrigin(1:3) + obj.options.bboxOrigin(4:6)./2);
neighborIDsAll = cell(obj.skelRef.numTrees,1);
neighborCountsAllMax = zeros(obj.skelRef.numTrees,1);
neighborCountsAll = cell(obj.skelRef.numTrees,1);
distToOriginAll = cell(obj.skelRef.numTrees,1);
for skelRefIdx = 1:obj.skelRef.numTrees
    if obj.options.verbose
        disp(['Measuring Divergence ... ',num2str(skelRefIdx),' of ',num2str(obj.skelRef.numTrees)])
    end
    % Create indices
    skelTarInds = 1:obj.skelTar.numTrees;
    if obj.options.refTarIdent
        skelTarInds(skelRefIdx) = [];
    end
    % Compute nhood
    nodesRefNeighbors = SkelDiv.ellipsoidNhood( obj.skelRef, skelRefIdx, obj.skelTar, skelTarInds, obj.options.ellipsoidRadii );
    [neighborCounts, neighborIDs, distToOrigin] = SkelDiv.axonPersistence( obj.skelRef, skelRefIdx, nodesRefNeighbors, origin );
    neighborIDsAll{skelRefIdx} = neighborIDs;
    neighborCountsAllMax(skelRefIdx) = max(neighborCounts);
    neighborCountsAll{skelRefIdx} = neighborCounts;
    distToOriginAll{skelRefIdx} = distToOrigin;
end

% Assign divergence results
obj.results.origin = origin;
obj.results.neighborIDsAll = neighborIDsAll;
obj.results.neighborCountsAllMax = neighborCountsAllMax;
obj.results.neighborCountsAll = neighborCountsAll;
obj.results.distToOriginAll = distToOriginAll;

% Get unique Fraction
[uniqueFraction, uniqueFractionBins] = SkelDiv.uniqueFraction( neighborCountsAll, distToOriginAll, obj.options.binSize );
padn = floor((obj.options.plotRangeX(2)*1E3-uniqueFractionBins(end))/obj.options.binSize);
uniqueFraction = [uniqueFraction, repmat(uniqueFraction(end),1,padn)];
uniqueFractionBinsP = 0:obj.options.binSize:obj.options.plotRangeX(2)*1E3;

% Make dropToZero vector
dropToZero = Inf(1,obj.skelRef.numTrees);
nonUnique.treeInds = [];
nonUnique.treeNames = {};
nonUnique.numRemaining = [];
for treeIdx = 1:obj.skelRef.numTrees
    dropIdx = find(~logical(neighborCountsAll{treeIdx}),1,'first');
    if ~isempty(dropIdx)
        dropDist = distToOriginAll{treeIdx}(dropIdx);
        dropToZero(treeIdx) = dropDist;
    else
        nonUnique.treeInds = [nonUnique.treeInds; treeIdx];
        nonUnique.treeNames = [nonUnique.treeNames; obj.skelRef.names{treeIdx}];
        nonUnique.numRemaining = [nonUnique.numRemaining; min(neighborCountsAll{treeIdx})];
    end
end

% Make drop Table
drop.skelRefNumTrees = obj.skelRef.numTrees;
drop.skelTarNumTrees = obj.skelTar.numTrees;
drop.mean = mean(dropToZero(dropToZero~=Inf))/1000;
drop.median = median(dropToZero(dropToZero~=Inf))/1000;
drop.std = std(dropToZero(dropToZero~=Inf))/1000;
drop.dunique85 = SkelDiv.dUnique(dropToZero, 85)/1000;
drop.dunique90 = SkelDiv.dUnique(dropToZero, 90)/1000;
drop.dunique95 = SkelDiv.dUnique(dropToZero, 95)/1000;
obj.results.dropTable = struct2table(drop);

% Make nonUniqe table
obj.results.nonUniqueTable = struct2table(nonUnique);

% Make uniqueFrac table
uniqueFrac.binDists = uniqueFractionBinsP';
uniqueFrac.binFracs = uniqueFraction';
for treeIdx = 1:obj.skelRef.numTrees
    uniqueFrac.([obj.skelRef.names{treeIdx},'_dist']) = distToOriginAll{treeIdx};
    uniqueFrac.([obj.skelRef.names{treeIdx},'_counts']) = neighborCountsAll{treeIdx} + 1;
end
TSsizes = structfun(@(x) size(x,1),uniqueFrac);
TSpadvals = max(TSsizes) - TSsizes;
fnames = fieldnames(uniqueFrac);
for i = 1:numel(fnames)
    uniqueFrac.(fnames{i}) = [uniqueFrac.(fnames{i}); nan(TSpadvals(i),1)];
end
obj.results.uniqueFracTable = struct2table(uniqueFrac);

% Make last remaining table
for treeIdx = 1:obj.skelRef.numTrees
    treeName = obj.skelRef.names{treeIdx};
    dropToMinCountIdx = find(~(obj.results.neighborCountsAll{treeIdx} - min(obj.results.neighborCountsAll{treeIdx})), 1, 'first');
    closestNeighbors.refTreeIdx{treeIdx} = treeIdx;
    closestNeighbors.tarTreeIdx{treeIdx} = obj.results.neighborIDsAll{treeIdx}{dropToMinCountIdx};
    closestNeighbors.tarTreeName{treeIdx} = obj.skelTar.names{closestNeighbors.tarTreeIdx{treeIdx}};
    closestNeighbors.tarDropDist{treeIdx} = round(obj.results.distToOriginAll{treeIdx}(dropToMinCountIdx));
end
obj.results.closestNeighbors = closestNeighbors;

end

