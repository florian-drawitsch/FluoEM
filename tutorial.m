%% FluoEM Tutorial
%
% The FluoEM package contains all tools necessary to directly correlate
% graph representations of axons contained in 3D light- and electron 
% microscopic datasets
% The code snippets below exemplify typical use cases of the package.
%
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>


%% Set path
% The FluoEM needs to be added to the matlab path before it can be used.
% Exectue this cell to perform that action.
pkgpath = fileparts(which('tutorial.m'));
addpath(genpath(pkgpath));


%% Construct skelReg object
fpathEM = fullfile(pkgpath, 'examples', 'all_em.nml');
fpathLM = fullfile(pkgpath, 'examples', 'all_lm.nml');
skelReg = SkelReg(fpathEM, fpathLM);


%% Register skeletons
% Affine
skelReg = skelReg.registerAffine;
% Free Form
skelReg = skelReg.registerFreeForm;


%% Plot Overlay
% Include em and affine transformed lm with control points highlighted 
skelReg.plot('include',{'em','lm_at'},'cps',true,'labels',false);
% Include em and free-form transformed lm with control points and labels 
skelReg.plot('include',{'em','lm_at_ft'},'cps',true,'labels',true);


%% Write registered .nml files
outputpath = fullfile(pkgpath,'examples','registered')
skelReg.write(outputpath)







