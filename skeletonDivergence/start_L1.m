% Set parameters
parDir = fileparts(which('start_L1.m'));
nmlDir = fullfile(parDir,'..','data','skeletonDivergence');
nmlDirRef = nmlDir;
nmlFnameRef = 'L1_bboxDense_em.nml';
nmlDirTar = nmlDir;
nmlFnameTar = 'L1_bboxDense_em.nml';
bboxOrigin = [22794,21773,1382,444,444,166];
outputDir = fullfile(nmlDir, 'output', 'L1');
outputFname = 'L1';
plotAddY = 1;


% Start
measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname, [], [], [], [], [], plotAddY)
