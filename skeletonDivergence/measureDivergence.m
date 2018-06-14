function measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname, bboxRestrictActive, bboxRestrictExtent, ellipsoidRadii, binSize, plotRangeX)
%MEASUREDIVERGENCE measures the divergence of a set of axon skeletons 
%originating from the same bounding box
%   To compute the axon divergence, a marching ellipsoid is placed around
%   each node of a given axon and at each position the neighboring axons
%   encompassed in the ellipsoid are logged. The number of persistently
%   neighboring axons are then sorted according to the euclidean distance
%   to the bbox origin and plotted. 
%   INPUT:  nmlDirRef: str
%               Directory of reference skeleton nml
%           nmlFnameRef: str
%               Filename of reference skeleton nml
%           nmlDirTar: str
%               Directory of target skeleton nml
%           nmlFnameTar: str
%               Filename of target skeleton nml
%           bboxOrigin: [1 x 6] double
%               Common skeleton reconstruction bounding box of format 
%               [xmin, ymin, zmin, xwidth, ywidth, zwidth]
%           outputDir: str
%               Output directory to which plots, tables and mat files are
%               written
%           outputFname: str
%               Output filename stump
%           bboxRestrictActive: (optional) boolean
%               When true, all skeletons are truncated beyond a distance of
%               bboxRestrictExtent from the bounding box center
%               (Default: false)
%           bboxRestrictExtent: (optional) double
%               Euclidean distance from bounding boxer center after which
%               skeletons should be truncated
%               (Default: 40000 [nm])
%           ellipsoidRadii: (optional) [1 x 3] double
%               Dimensions of the marching ellipsoid used to compute the
%               neighborhood criterion
%               (Default: [5000, 5000, 5000] [nm])
%           binSize: (optional) double
%               Width of bins in which divergence results are lumped
%               (Default: 2500 [nm])
%           plotRangeX: (optional) [1 x 2] double
%               Euclidean distance from bbox center over which divergence 
%               measurement results are plotted
%               (Default: [0 100] [nm])
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>


% Set optional variables
if ~exist('bboxRestrictActive','var') || isempty(bboxRestrictActive)
    bboxRestrictActive = 0;
end
if ~exist('bboxRestrictExtent','var') || isempty(bboxRestrictExtent)
    bboxRestrictExtent = 40000;
end
if ~exist('ellipsoidRadii','var') || isempty(ellipsoidRadii)
    ellipsoidRadii = [5000 5000 5000];
end
if ~exist('binSize','var') || isempty(binSize)
    binSize = 2500;
end
if ~exist('plotRangeX','var') || isempty(plotRangeX)
    plotRangeX = [0 100];
end


% Load Data
skelRef = Skeleton(fullfile(nmlDirRef,nmlFnameRef));
skelTar = Skeleton(fullfile(nmlDirTar,nmlFnameTar));


% Check whether skelRef and skelTar are the same
if skelRef.numTrees == skelTar.numTrees && prod(strcmp(skelRef.names,skelTar.names))
    refTarIdent = 1;
else
    refTarIdent = 0;
end


% Restrict to bbox
bboxOld = convertBbox(bboxOrigin);
bboxCenter = mean(reshape(bboxOld,[3 2])',1);
rd = floor(bboxRestrictExtent ./ [11.24 11.24 30] ./2);
bboxRestrict = round([bboxCenter - rd; bboxCenter + rd]');
if bboxRestrictActive
    skelRef = skelRef.restrictToBBox(bboxRestrict);
    skelTar = skelTar.restrictToBBox(bboxRestrict);
end


% Measure Divergence all
origin = round(bboxOrigin(1:3) + bboxOrigin(4:6)./2);
neighborIDsAll = cell(skelRef.numTrees,1);
neighborCountsAllMax = zeros(skelRef.numTrees,1);
neighborCountsAll = cell(skelRef.numTrees,1);
distToOriginAll = cell(skelRef.numTrees,1);
for skelRefIdx = 1:skelRef.numTrees
    disp(['Measuring Divergence ... ',num2str(skelRefIdx),' of ',num2str(skelRef.numTrees)])
    % Create indices
    skelTarInds = 1:skelTar.numTrees;
    if refTarIdent
        skelTarInds(skelRefIdx) = [];
    end
    % Compute nhood
    nodesRefNeighbors = computeEllipsoidNhood( skelRef, skelRefIdx, skelTar, skelTarInds, ellipsoidRadii );
    [neighborCounts, neighborIDs, distToOrigin] = computeAxonPersistence( skelRef, skelRefIdx, nodesRefNeighbors, origin );
    neighborIDsAll{skelRefIdx} = neighborIDs;
    neighborCountsAllMax(skelRefIdx) = max(neighborCounts);
    neighborCountsAll{skelRefIdx} = neighborCounts;
    distToOriginAll{skelRefIdx} = distToOrigin;
end

% Get unique Fraction
[uniqueFraction, uniqueFractionBins] = computeUniqueFraction( neighborCountsAll, distToOriginAll, binSize );
padn = floor((plotRangeX(2)*1E3-uniqueFractionBins(end))/binSize);
uniqueFraction = padarray(uniqueFraction,[0 padn],'replicate','post');
uniqueFractionBinsP = 0:binSize:plotRangeX(2)*1E3;

% Make dropToZero vector
dropToZero = Inf(1,skelRef.numTrees);
nonUniqueTreeInds = [];
nonUniqueRemaining = [];
nonUniqueClass = {};
for treeIdx = 1:skelRef.numTrees
    dropIdx = find(~logical(neighborCountsAll{treeIdx}),1,'first');
    if ~isempty(dropIdx)
        dropDist = distToOriginAll{treeIdx}(dropIdx);
        dropToZero(treeIdx) = dropDist;
    else
        nonUniqueTreeInds = [nonUniqueTreeInds, treeIdx];
        nonUniqueRemaining = [nonUniqueRemaining, min(neighborCountsAll{treeIdx})];
        if ~isempty(regexpi(skelRef.names{treeIdx},'unclear'))
            nonUniqueClass = [nonUniqueClass, 'unclear'];
        else
            nonUniqueClass = [nonUniqueClass, 'checked'];
        end
    end
end


% Compute Summary Statistics
drop.skelRefNumTrees = skelRef.numTrees;
drop.skelTarNumTrees = skelTar.numTrees;
drop.mean = mean(dropToZero(dropToZero~=Inf))/1000;
drop.median = median(dropToZero(dropToZero~=Inf))/1000;
drop.std = std(dropToZero(dropToZero~=Inf))/1000;
drop.dunique85 = dUnique(dropToZero, 85)/1000;
drop.dunique90 = dUnique(dropToZero, 90)/1000;
drop.dunique95 = dUnique(dropToZero, 95)/1000;
T = struct2table(drop);


% Make Plot
figure
fig = gcf;
set(fig,'defaultAxesColorOrder',[[0 0 0];[.25 .25 .75]])
ax = gca;
% Left Axis
yyaxis left
highlight = [];
hi = 0;
for treeIdx = 1:skelRef.numTrees
    neighborCounts = neighborCountsAll{treeIdx};
    if neighborCounts(end) > 0
        hi = hi + 1;
        highlight(hi,:) = [distToOriginAll{treeIdx}(end) neighborCounts(end)];
        scatter(highlight(hi,1),highlight(hi,2)+1,5,'v','MarkerEdgeColor',[1 0 0]);
    end
    plot(distToOriginAll{treeIdx},neighborCounts,'-','Color',get(gca,'YColor'),'LineWidth',0.2);
    hold on
end
ylim([0.9 skelTar.numTrees+10]);
set(gca,'YScale','log');
yrTicks = [10^0,10^1,10^2];
yrTickLabels = {'10^0','10^1','10^2'};
set(gca,'YTick',yrTicks,'YTickLabel',yrTickLabels);
title(outputFname);
ylabel({'Axons in neighborhood'});
xlabel('d_{unique}(µm)');
xTicks = [0, 50, 100] .* 1E3;
xTickLabels = {'0','50','100'};
set(gca,'XTick',xTicks,'XTickLabel',xTickLabels);
xlim([0 plotRangeX(2)*1E3]);
% Right Axis
yyaxis right;
plot([uniqueFractionBinsP(2:end) uniqueFractionBinsP(end)+binSize] ,uniqueFraction./skelRef.numTrees,'-','Color',get(gca,'YColor'),'LineWidth',0.5);
hold on;
line([-10 plotRangeX(2)*1E3],[0.9 0.9],'LineStyle','--','LineWidth',0.5);
hold on;
line([drop.dunique90 drop.dunique90].*1E3,[0 1],'LineStyle','--','LineWidth',0.5);
yrTicks = [0,1];
yrTickLabels = cellfun(@(x) num2str(x),num2cell(yrTicks),'UniformOutput',0);
set(gca,'YTick',yrTicks,'YTickLabel',yrTickLabels);
ylabel('Unique axon fraction');
ylim([0 1.01]);


% General Formatting
title(outputFname);
xlabel('Dist to origin (µm)');


% Save Workspace
mkdir(outputDir);
matFname = [outputFname,'.mat'];
save(fullfile(outputDir,matFname));
tableFname = [outputFname,'.xls'];
writetable(T,fullfile(outputDir,tableFname));


% Export xls
TS.uniqueFraction_binDists = uniqueFractionBinsP';
TS.uniqueFraction_binFracs = uniqueFraction';
for treeIdx = 1:skelRef.numTrees
    TS.([skelRef.names{treeIdx},'_dist']) = distToOriginAll{treeIdx};
    TS.([skelRef.names{treeIdx},'_counts']) = neighborCountsAll{treeIdx} + 1;
end
% Pad with NaNs
TSsizes = structfun(@(x) size(x,1),TS);
TSpadvals = max(TSsizes) - TSsizes;
fnames = fieldnames(TS);
for i = 1:numel(fnames)
    TS.(fnames{i}) = [TS.(fnames{i}); nan(TSpadvals(i),1)];
end
TST = struct2table(TS);
writetable(TST,fullfile(outputDir,[outputFname,'plotData.xlsx']))


% Save Plots
fig = setFigureHandle(fig,'Width',4.5,'Height',3.5);
setAxisHandle(ax,0);
print(fullfile(outputDir,[outputFname,'_log_new.tif']),'-dtiff');
print(fullfile(outputDir,[outputFname,'_log_new']),'-dsvg');
print(fullfile(outputDir,[outputFname,'_log_new']),'-depsc');
print(fullfile(outputDir,[outputFname,'_log_new']),'-dpdf');
close(fig);


