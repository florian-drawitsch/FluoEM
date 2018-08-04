% Set parameters
parDir = fileparts(which('start_L4.m'));
nmlDir = fullfile(parDir,'..','data','skeletonDivergence');
nmlDirRef = nmlDir;
nmlFnameRef = 'L4_bboxDense_em.nml';
nmlDirTar = nmlDir;
nmlFnameTar = 'L4_bboxDense_em.nml';
bboxOrigin = [2549, 3896, 1647, 444, 444, 178];
outputDir = fullfile(nmlDir, 'output', 'L4');
outputFname = 'L4';
plotAddY = 1;


% Start
measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname, [], [], [], [], [], plotAddY)
