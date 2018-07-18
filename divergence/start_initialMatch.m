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


% Start
measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname)
