%% FluoEM Tutorial Part 1: Establishing an initial axon match

% Set paths
paths = tutorial_setup();
paths.tutorial01_data = fullfile(paths.tutorial, 'tutorial01_data');

% Set format
format long


%% Step 1.1: Reconstruct blood vessels as webKnossos skeletons and annotate fiducials as comments
% After acquiring the correlated LM and EM datatsets, establish a coarse
% registration by using intrinsic fiducials such as somata or blood vessels
% as control points sources. Here, we reconstructed blood vessels and used
% characteristic bifurcations as control points.


%% Step 1.2: Load the blood vessel skeletons into a skelReg object
% Define nml and transformation export filenames
paths.nml_bv_lm = fullfile(paths.data, 'bv_lm.nml');
paths.nml_bv_em = fullfile(paths.data, 'bv_em.nml');

% Define comment pattern used to read control points from webKnossos
% comments. The provided pattern "^b\d+$" reads comments starting with the
% letter "b" followed by a number of one or more digits  as a control point 
% id. 
commentPattern = '^b\d+$';

% Now let's construct a skelReg object. The skelReg object handles two or more
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

% Let's visualize the blood vessel skeletons still in their respective 
% coordinate systems
figure('Name','bv_lm');
skelReg.skelPlot('includeModality',{'moving'});

figure('Name','bv_em')
skelReg.skelPlot('includeModality',{'fixed'});

% Now let's inspect the control points our skelReg object parsed from the
% skeleton object's comments using the provided commentPattern
disp(skelReg.cp.points.moving);
disp(skelReg.cp.points.fixed);
disp(skelReg.cp.points.matched);


%% Step 1.3: Use the the parsed control points to compute a registration
% Using the matched control points we can register the skeletons like so:
skelReg = skelReg.skelRegister('at');

% Let's visualize the the fixed and the affine registered moving 
% ('moving_at') blood vessel skeletons which are now both in the fixed
% coordinate system
figure('Name','bv_em + bv_lm_at');
skelReg.skelPlot('includeModality',{'fixed', 'moving_at'});

% Finally let us compute the registration error based on control point pair
% offsets
errCP = skelReg.regErrorCP;
disp(errCP.moving_at.summary);


%% Step 1.4: Annotate the first LM axon candidate to be matched and add it to the skelReg object
% Annotate an LM axon, which is ideally close to an intrinsic fiducial (such
% as a blood vessel bifurcation) and ideally shows some prominent structural
% feature (such as a varicosity or branchpoint) in the vicinity of the 
% fiducial, potentially serving as a characteristic seed point for the 
% correspondence search. Use the comment function again to annotate this 
% seed point (and other prominent features) of the axon. After completing
% the reconstruction, add it as a tree to the LM blood vessel skeleton
% alread contained in the skelReg object
paths.nml_ax1_lm = fullfile(paths.data, 'ax1_lm.nml');
skelReg = skelReg.skelAddTree(paths.nml_ax1_lm, 'moving');

% Retrieve the comments on the added tree
skelReg = skelReg.cpReadFromSkel;

% Inspect the added LM axon together with the blood vessels
figure('Name','bv_lm + ax1_lm');
skelReg.skelPlot('includeModality',{'moving'});

% However, the axon has not yet been registered into the EM coordinate
% system yet:
figure('Name','bv_em + bv_lm_at');
skelReg.skelPlot('includeModality',{'fixed', 'moving_at'});

% Apply the previously computed registration again to the LM ('moving')
% skeleton object to obtain a registered skeleton including the newly added
% axon
skelReg = skelReg.trafoApply('at');

% Now we see the affine transformed ax1_lm_at in the registered overlay
figure('Name','bv_em + bv_lm_at + ax1_lm_at');
skelReg.skelPlot('includeModality',{'fixed', 'moving_at'},'labels',true);


%% Step 1.5: Locally optimize the initial affine registration
% Apply a translative correction to the affine transform to minimize the
% local offset of the closest registered fiducial. We know that we
% annotated the varicosity on the ax1_lm axon we want to use as a seed
% point for the correspondence search with the comment 'b4'. Lets retrieve
% the coordinate of this comment:
treeName = 'ax1_lm';
comment_seed = 'b4';
xyz_seed = skelReg.cp.points.moving.xyz(...
    strcmp(skelReg.cp.points.moving.treeName, treeName) & strcmp(skelReg.cp.points.moving.comment, comment_seed), :);
disp(xyz_seed)

% Now we search for the closest annotated control point on the blood vessel
% skeletons relative to the axon seed and retrieve its id
norms_all = util.normList(skelReg.cp.points.moving.xyz - xyz_seed);
inds_bv = ismember(skelReg.cp.points.moving.treeName, {'bva_lm', 'bvb_lm', 'bvc_lm'});
mask = inf(size(inds_bv));
mask(inds_bv) = 0;
norms_bv = norms_all + mask;
[~, idx_mindist] = min(norms_bv);
id_mindist = skelReg.cp.points.moving.id{idx_mindist};
disp(id_mindist)

% The bv control point closest to the ax1_lm seed seems to be the control
% point with id 'bva_b3'. Lets compute the local affine registration error
% for this control point pair
offset = skelReg.cp.points.matched.xyz_fixed(strcmp(skelReg.cp.points.matched.id, id_mindist), :) - ...
    skelReg.cp.points.matched.xyz_moving_at(strcmp(skelReg.cp.points.matched.id, id_mindist), :);

% Using this offset lets correct the translative component of the computed 
% affine transformation
skelReg.affine = skelReg.affine.translate(offset');

% Now we apply the corrected affine transformation again to the LM
% skeletons to obtain affine registered skeletons with a locally increased
% registration precision and write the resulting skeleton to a .nml file
skelReg = skelReg.trafoApply('at');
skelReg.skeletons.moving_at.write(fullfile(paths.tutorial01_data, 'bv_ax1_lm_at.nml'));


%% Step 1.6: Prepare reconstruction of EM axon matching candidates
% After confirming the successful elimination of the offset between the 
% control pair with the id 'bva_b3' between the 'moving_at' and 'fixed'
% modalities, remove the blood vessel skeletons.
disp(skelReg.skeletons.moving_at.names);
skelReg = skelReg.skelRemoveTree('bv', 'partial', 'moving_at');

% Now we have obtained a skeleton containing only the affine transformed
% initial axon match candidate 'ax1_lm_at' and can write it to a separate
% .nml file
disp(skelReg.skeletons.moving_at.names);
paths.nml_ax1_lm_at = fullfile(paths.tutorial01_data, 'ax1_lm_at.nml');
skelReg.skeletons.moving_at.write(paths.nml_ax1_lm_at);

% To serve as a matching template, we only need to define a bounding box
% around the seed point 'b4' to constrain the search volume in which the
% em axon match candidates should be reconstructed. One can intuitively
% argue that a reasonable edge length for this search bounding box should
% be twice the length than the average registration error. We computed the
% registration error above:
err_mean = errCP.moving_at.summary.mean;
disp(err_mean);

% Let us construct a bounding box of edge length 2*err_mean around the seed
% point on our affine transformed LM axon matching candidate marked with 
% the comment 'b4':
centerPoint = skelReg.cp.points.moving_at.xyz(strcmp(skelReg.cp.points.moving_at.id, 'ax1_b4'), :);
bboxSize = 2*err_mean;
voxelSize = skelReg.skeletons.moving_at.scale;
[bbox, bboxStr] = util.bbox.getBboxFromCenterPoint(centerPoint, bboxSize, voxelSize);


%% Step 1.7: Carry out the reconstruction
% Paste the bboxStr in webKnossos and reconstruct all EM skeletons 
% traversing the defined bounding box


%% Step 1.8: Find the correct correspondence based on structural divergence measurement
% Define the required nml paths
paths.nml_ax1_lm_at = fullfile(paths.tutorial01_data, 'ax1_lm_at.nml');
paths.nml_ax1_em_candidates = fullfile(paths.data, 'ax1_em_candidates.nml');

% Load the matching reference (ax1_lm_at) and the matching candidates 
% (ax1_em_candidates) into a skelDiv object. Note that below we impose a 
% bbox differing very slightly from the one computed above, which is the
% original bbox used for the results shown in FluoEM Fig.4. However, the
% resulting closest neighbor remains unchanged, and the uniqueness distance
% deviates by less than 1.8% or less than 800 nm, respectively
bbox = [20889, 24751, 125, 444, 444, 166];
skelDiv = SkelDiv(paths.nml_ax1_lm_at, paths.nml_ax1_em_candidates, bbox);

% Measure divergence
skelDiv = skelDiv.measure;

% Plot result
skelDiv.plotGraph;

% Check last remaining neighbor
disp(skelDiv.results.closestNeighbors);

% Since the last remaining neighbor likely represents the corresponding 
% ax1_em for our initial match candidate ax1_lm, lets plot its
% treeId
disp(skelDiv.results.closestNeighbors.tarTreeIdx{1})
% treeName
disp(skelDiv.results.closestNeighbors.tarTreeName{1})

% To verify let us plot the reference skeleton with the remaining neighbor
skelDiv.plotSkels(1, skelDiv.results.closestNeighbors.tarTreeIdx{1});

% The resemblance is visually striking. The correspondence can be
% verified by going into the raw data and annotating structural features
% such as varicosity patterns. Let's write the putative ax1_em skeleton to
% a separate .nml file and open it in webKnossos.
paths.nml_ax1_em = fullfile(paths.tutorial01_data, 'ax1_em.nml');
skelDiv.skelTar.write(paths.nml_ax1_em, skelDiv.results.closestNeighbors.tarTreeIdx{1})













    



