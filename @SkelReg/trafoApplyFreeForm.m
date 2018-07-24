function obj = trafoApplyFreeForm( obj )
%TRAFOAPPLYFREEFORM Applies the free-form transformation stored in the  
% internal state to the stored skeleton object
%   Use the "trafoComputeFreeForm" method to obtain such an free-form 
%   transformation model based on control point pairs, or import one.
%   The free-form deformation is defined relative to an affine pre-
%   registration. 
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Create affine transformation matrix for voxel -> nm transformation
A = diag([obj.skeletons.lm_at.scale, 1]);

% Transform from voxel space -> nm space
skel_lm_atr = trafoAT_transformSkeleton(obj.skeletons.lm_at, A, [1 1 1], 'forward');
% Apply free-form deformation grid in nm space
skel_lm_atr_ft = trafoFT_transformSkeleton( skel_lm_atr, obj.transformations.ft.grid, obj.transformations.ft.spacingConsequent);
% Transform from back from nm space -> voxel space
obj.skeletons.lm_at_ft = trafoAT_transformSkeleton(skel_lm_atr_ft, A, obj.skeletons.lm_at.scale, 'inverse');

% Parse control points from skeleton comments
obj.controlPoints.lm_at_ft = SkelReg.comments2table(obj.skeletons.lm_at_ft);

% Match controlPoints 
obj = cpMatch(obj);
