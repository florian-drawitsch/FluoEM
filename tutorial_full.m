%% FluoEM Tutorial
%
% The FluoEM package contains all tools necessary to directly correlate
% graph representations of axons contained in 3D light- and electron 
% microscopic datasets. The code snippets below exemplify typical use cases 
% of the package.
%
% All skeleton reconstructions were carried out using the efficient browser
% annotation tool webKnossos (Boergens, K.M., Berning, M., Bocklisch, 
% T., Bräunlein, D., Drawitsch, F., Frohnhofen, J., Herold, T., Otto, P., 
% Rzepka, N., Werkmeister, T., et al. (2017). webKnossos: efficient online 
% 3D data annotation for connectomics. Nature Methods 14, 691.).
%
% All registration control points were added as comments to the nodes of 
% the skeleton reconstructions, using webKnossos' comment function.
%
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>
%         Department of Connectomics
%         Max Planck Institute for Brain Research | Frankfurt | Germany 


%% Set path and directories
% The FluoEM needs to be added to the matlab path before it can be used.
% Exectue this cell to perform that action.

% Set path
pkgpath = fileparts(which('tutorial_full.m'));
addpath(genpath(pkgpath));

% Set data directories
skelDir = fullfile(pkgpath,'data');

% Set format
format long


%% Measure Divergence (FluoEM Fig. 2)
% Carry out divergence measurements in a given area by reconstructing all
% axons traversing a given bounding box of edge length lambda align.
% Then compute dunique using the measureDivergence function on the
% resulting nml file. The process is exemplified here with measurements
% carried out in L4 (/data/skeletonDivergence/L4_bboxDense_em.nml)

% Set parameters
nmlDirRef = skelDir;
nmlFnameRef = 'L4_bboxDense_em.nml';
nmlDirTar = nmlDirRef;
nmlFnameTar = nmlFnameRef;
bboxOrigin = [2549, 3896, 1647, 444, 444, 178];
outputDir = fullfile(skelDir, 'output', 'L4');
outputFname = 'L4';
plotAddY = 1;

% Show axons (Warning: This can take some time)
skel = Skeleton(fullfile(nmlDirRef, nmlFnameRef));
skel = skel.downSample([], 5);
figure('Name','Dense bbox reconstruction L4'), skel.plot

% Start divergence measurements
measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname, [], [], [], [], [], plotAddY)


%% Compute blood vessel-based affine registration
% After acquiring the correlated LM and EM datatsets, establish a coarse
% registration by using intrinsic fiducials such as somata or blood vessels
% as control points sources. Here, we reconstructed blood vessels and used
% characteristic bifurcations as control points.

% Define nml and transformation export filenames
fname_bv_lm_nml = fullfile(skelDir, 'bv_lm.nml');
fname_bv_em_nml = fullfile(skelDir, 'bv_em.nml');
fname_bv_trafo_at = fullfile(skelDir, 'bv_trafo_at.mat');

% Define comment pattern used to read control points from webKnossos
% comments. The provided pattern "^b\d+$" reads comments starting with the
% letter "b" followed by a number of one or more digits  as a control point 
% id. 
commentPattern = '^b\d+$';

% Construct SkelReg object
skelReg = SkelReg(fname_bv_lm_nml, fname_bv_em_nml, commentPattern);

% Show LM and EM blood vessel skeletons
figure('Name','Blood vessel skeletons lm'), skelReg.skeletons.lm.plot;
figure('Name','Blood vessel skeletons em'), skelReg.skeletons.em.plot;

% Show control points LM, EM, and matched
disp(skelReg.controlPoints.lm);
disp(skelReg.controlPoints.em);
disp(skelReg.controlPoints.matched);

% Compute affine registration and show transformation
skelReg = skelReg.registerAffine;
disp(skelReg.transformations.at.trafoMatrix3D);

% Show registered LM and EM blood vessel skeletons
figure('Name','Blood vessel skeletons registered'), skelReg.plot

% Export transformation
skelReg.exportTransformation(fname_bv_trafo_at)


%% Apply translative correction to inital transformation
% After establishing the coarse fiducial based registration reconstruct the
% first axon match candidate in LM and use the previously computed
% transformation to map it into the EM reference space. To minimize the
% search cost for the initial match, apply a local translative correction
% to the transformation based on the offset of the fiducial control points
% closest to the axon search seed.

% Define nml and transformation filenames
fname_axon1_lm_nml = fullfile(skelDir, 'axon1_lm.nml');
fname_bv_em_nml = fullfile(skelDir, 'bv_em.nml');
fname_bv_lm_nml = fullfile(skelDir, 'bv_lm.nml');
fname_bv_trafo_at = fullfile(skelDir, 'bv_trafo_at.mat');
fname_bv_trafo_at_corrected = fullfile(skelDir, 'bv_trafo_at_corrected.mat');

% Construct skelReg object with blood vessel tracings and add axon1_lm
skelReg = SkelReg(fname_bv_lm_nml, fname_bv_em_nml);
skelReg = skelReg.addTree(fname_axon1_lm_nml, 'lm');
skelReg = skelReg.importTransformation(fname_bv_trafo_at);
skelReg = skelReg.applyAffine;

% Show registered
figure('Name','BV + axon1 registered'), skelReg.plot

% Define closest blood vessel cp to adjust offset
closest_cp_id = 'bva_b3';
closest_cp_idx = find(strcmp(skelReg.controlPoints.matched.id, closest_cp_id));

% Compute offset and substract from translative transformation component
offset = skelReg.controlPoints.matched.xyz_em(closest_cp_idx,:) - skelReg.controlPoints.matched.xyz_lm_at(closest_cp_idx,:);
skelReg.transformations.at.trafoMatrix3D(1:3,4) = skelReg.transformations.at.trafoMatrix3D(1:3,4) - offset';

% Apply corrected transformation
skelReg = skelReg.applyAffine;

% Show 
figure('Name','BV + axon1 registered corrected'), skelReg.plot

% Save corrected transformation
skelReg.exportTransformation(fname_bv_trafo_at_corrected)


%% Transform axon1_lm into EM reference space 

% Define nml and transformation filenames
fname_bv_trafo_at_corrected = fullfile(skelDir, 'bv_trafo_at_corrected.mat');
fname_axon1_lm_nml = fullfile(skelDir, 'axon1_lm.nml');
fname_axon1_lm_at_nml = fullfile(skelDir, 'axon1_lm_at.nml');
fname_bv_em_nml = fullfile(skelDir, 'bv_em.nml');

% Import and apply corrected initial transformation
skelReg = SkelReg(fname_axon1_lm_nml, fname_bv_em_nml);
skelReg = skelReg.importTransformation(fname_bv_trafo_at_corrected);
skelReg = skelReg.applyAffine;
skelReg.skeletons.lm_at.write(fname_axon1_lm_at_nml)


%% Find match amongst dense bounding box candidate tracings
fname_axon1_lm_at_nml = fullfile(skelDir, 'axon1_lm_at.nml');
fname_axon1_em_candidates_nml = fullfile(skelDir, 'axon1_em_candidates.nml');

% Set parameters
nmlDirRef = skelDir;
nmlFnameRef = 'axon1_lm_AT_AT.nml';
nmlDirTar = skelDir;
nmlFnameTar = 'axon1_em_candidates.nml';
bboxOrigin = [20889,24751,125,444,444,166];
outputDir = fullfile(skelDir, 'output', 'initialMatch');
outputFname = 'initialMatch';

% Start divergence measurements
measureDivergence(nmlDirRef, nmlFnameRef, nmlDirTar, nmlFnameTar, bboxOrigin, outputDir, outputFname)


%% Use first matched axon pair to refine transformation and prepare second match
% Set parameters
fname_axon1_lm_nml = fullfile(skelDir, 'axon1_lm.nml'); 
fname_axon1_em_nml = fullfile(skelDir, 'axon1_em.nml');
fname_axon2_lm_nml = fullfile(skelDir, 'axon2_lm.nml');

% Load matched axon1 pair, add axon2 and register 
skelReg = SkelReg(fname_axon1_lm_nml, fname_axon1_em_nml);
skelReg = skelReg.addTree(fname_axon2_lm_nml, 'lm');
skelReg = skelReg.registerAffine;
skelReg.plot;


%% Show all registered axons
% set paremeters
fname_axons_all_em_nml = fullfile(skelDir, 'axons_all_em.nml');
fname_axons_all_lm_nml = fullfile(skelDir, 'axons_all_lm.nml');

% Load all matched axon pairs
skelReg = SkelReg(fname_axons_all_lm_nml, fname_axons_all_em_nml);

% Show affine
skelReg = skelReg.registerAffine;
skelReg.plot('labels',false);

% Show free-form
skelReg = skelReg.registerNonAffine;
skelReg.plot;









