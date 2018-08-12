%% FluoEM Tutorial
% Part 1: Finding an initial Match


%% Set paths and formats
% Set paths
paths = run_setup();

% Set format
format long


%% Compute blood vessel-based affine registration
% After acquiring the correlated LM and EM datatsets, establish a coarse
% registration by using intrinsic fiducials such as somata or blood vessels
% as control points sources. Here, we reconstructed blood vessels and used
% characteristic bifurcations as control points.

% Define nml and transformation export filenames
paths.nml_bv_lm = fullfile(paths.data, 'bv_lm.nml');
paths.nml_bv_em = fullfile(paths.data, 'bv_em.nml');

% Define comment pattern used to read control points from webKnossos
% comments. The provided pattern "^b\d+$" reads comments starting with the
% letter "b" followed by a number of one or more digits  as a control point 
% id. 
commentPattern = '^b\d+$';

% No let's construct a skelReg object. The skelReg object handles two or more
% correlated skeleton objects, reads control points from their comments,
% registers and visualizes them. The skelReg constructor wants two nml
% files containing correlated skeleton annotations as inputs. They are
% referred to as a 'moving' skeleton (e.g. the skeleton to be transformed)
% and 'fixed' skeleton (e.g. the skeleton staying fixed in it's coordinate
% system'). In a typical FluoEM setting the light microscopic (LM) data
% will correspond to 'moving', while the electron microscopic (EM) data
% will correspond to 'fixed', e.g. we want to transform LM data into the EM
% coordinate system.
skelReg = SkelReg(paths.nml_bv_lm, paths.nml_bv_em, commentPattern);

% Let's visualize the skeletons still in their respective coordinate
% systems
figure('Name','Blood vessel skeletons lm (moving)');
skelReg.skelPlot('includeModality',{'moving'});

figure('Name','Blood vessel skeletons em (fixed)')
skelReg.skelPlot('includeModality',{'fixed'});

% Now let's inspect the control points our skelReg object parsed from the
% skeleton object's comments using the provided commentPattern
disp(skelReg.cp.points.moving);
disp(skelReg.cp.points.fixed);
disp(skelReg.cp.points.matched);

% Using the matched control points we can register the skeletons like so:
skelReg = skelReg.skelRegister;

% Let's visualize the the fixed and the affine registered moving 
% ('moving_at') blood vessel skeletons which are now both in the fixed
% coordinate system
figure('Name','Blood vessel skeletons lm (moving)');
skelReg.skelPlot('includeModality',{'fixed', 'moving_at'});


%%




