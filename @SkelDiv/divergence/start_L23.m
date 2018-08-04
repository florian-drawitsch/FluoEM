% Set parameters
parDir = fileparts(which('start_L23.m'));
nmlDir = fullfile(parDir,'..','data','skeletonDivergence');
nmlDirRef = nmlDir;
nmlFnameRef = 'L23_bboxDense_em.nml';
nmlDirTar = nmlDir;
nmlFnameTar = 'L23_bboxDense_em.nml';
bboxOrigin = [4835, 3910, 3692, 415, 415, 208];
outputDir = fullfile(nmlDir, 'output', 'L23');
outputFname = 'L23';
plotAddY = 1;

% Start
measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname, [], [], [], [], [], plotAddY)
