%% FluoEM Tutorial Part 2: Iterative matching

% Set paths
paths = tutorial_setup();
paths.tutorial02_data = fullfile(paths.tutorial, 'tutorial02_data');

% Set format
format long


%% Step 2.1: Reconstruct LM axon in vicinity of the first matched axon
% After successfully matching the first axon in tutorial01, choose another
% axon matching candidate in the LM data, ideally in close vicinity of the
% first match. Let's assume we saved the reconstruction of this axon as
% ax2_lm.nml
paths.nml_ax2_lm =  fullfile(paths.data, 'ax2_lm.nml');


%% Step 2.2: Load the previous axon match(es) into a SkelReg object
% Initialize skelReg object with skeleton reconstructions of previously
% matched axon
paths.nml_ax1_lm = fullfile(paths.data, 'ax1_lm.nml');
paths.nml_ax1_em = fullfile(paths.data, 'ax1_em.nml');
skelReg = SkelReg(paths.nml_ax1_lm, paths.nml_ax1_em);

% OPTIONAL NOTE FOR MULTIPLE MATCHES:
% In order to load more than one skeleton pair to compute a registration
% you can make use of the merge utilitis found in FluoEM/+util/+nml. Let's
% assume you want to compute a registration based on multiple matches saved
% in a common data directory with LM reconstructions indicated with 
% suffix "_lm.nml" and EM reconstruction indicated with suffix "_em.nml". Then you 
% could merge these reconstructions into one file like so:
util.nml.nmlMerge(paths.data, '^ax\d*_lm.nml$', fullfile(paths.tutorial02_data,'ax_merged_lm.nml') )
util.nml.nmlMerge(paths.data, '^ax\d*_em.nml$', fullfile(paths.tutorial02_data,'ax_merged_em.nml') )
% In this case, the skeleton paths provided to construct the SkelReg object
% (see above) should be changed accordingly


%% Step 2.3: Compute registration based on previous match(es) and save it
% Compute a registration based on the previously matched axon
paths.affine_model_ax1 = fullfile(paths.tutorial02_data, 'affine_model_ax1.mat');
paths.freeform_model_ax1 = fullfile(paths.tutorial02_data, 'freeform_model_ax1.mat');

skelReg = skelReg.skelRegister;
skelReg.affine.save(paths.affine_model_ax1)
skelReg.freeform.save(paths.freeform_model_ax1)


%% Step 2.4: Load the LM-reconstructed axon from Step 2.1 into Skeleton object
skel_ax2_lm = Skeleton(paths.nml_ax2_lm);


%% Step 2.5: Initialize affine object and load the registration defined in Step 2.3
affine = trafo.Affine();
affine = affine.load(paths.affine_model_ax1);


%% Step 2.6 Apply affine transformation to ax2_lm to obtain a new EM search template
skel_ax2_lm_at = affine.applyToSkel(skel_ax2_lm);


%% Step 2.7 Save the transformed skeleton to disk
paths.nml_ax1_lm_at = fullfile(paths.tutorial02_data, 'ax1_lm_at.nml');
skel_ax2_lm_at.write(paths.nml_ax1_lm_at)


%% Step 2.8 Use the transformed skeleton as a search template to find it's correspondence



