% Set parameters
parDir = fileparts(which('start_initialMatch.m'));
nmlDir = fullfile(parDir,'..','data','skeletonDivergence');
nmlDirRef = nmlDir;
nmlFnameRef = 'initialMatch_candidate_lm_AT.nml';
nmlDirTar = nmlDir;
nmlFnameTar = 'initialMatch_bboxDense_em.nml';
bboxOrigin = [20889,24751,125,444,444,166];
outputDir = fullfile(nmlDir, 'output', 'initialMatch');
outputFname = 'initialMatch';
bboxRestrictActive = 0;
bboxRestrictExtent = 40000; %nm
ellipsoidRadii = [5000 5000 5000];
binSize = 2500;
plotRangeX = [0 100];


% Start
measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname, bboxRestrictActive, bboxRestrictExtent, ellipsoidRadii, binSize, plotRangeX)
