function target_at_ft = applyFreeForm( obj, target_at )
%APPLYFREEFORM  computes the free-form transformation of the target 
%based on the transformation attribute stored in the internal state
%   Use the "registerFreeForm" method to obtain such an free-form 
%   transformation model based on control point pairs, or import one.
%   The free-form deformation is defined relative to an affine pre-
%   registration. Use an already affine transformed skeleton or points as
%   input.
%   INPUT:  target_at: Skeleton object or [Nx3] double
%               Affine transformed target skeleton or points
%   OUTPUT: target_at_ft: Skeleton object or [Nx3] double
%               Free-form transformed skeleton or points
%   Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~isfield(obj.transformations, 'ft')
    error('No transformation found at obj.transformations.at_ft. Use the registerFree-Form method to obtain one.');
end

% Create affine transformation matrix for voxel -> nm transformation
A = diag([obj.skeletons.lm_at.scale, 1]);

if isa(target_at,'Skeleton')
    % Transform from voxel space -> nm space
    target_atr = trafoAT_transformSkeleton(target_at, A, [1 1 1], 'forward');
    % Apply free-form deformation grid in nm space
    target_atr_ft = trafoFT_transformSkeleton( target_atr, obj.transformations.ft.grid, obj.transformations.ft.spacingConsequent);
    % Transform from back from nm space -> voxel space
    target_at_ft = trafoAT_transformSkeleton(target_atr_ft, A, scale, 'inverse');
    
elseif isa(target_at, 'numeric') && size(target_at,2) == 3
    % Transform from voxel space -> nm space
    target_atr = trafoAT_transformArray( target_at, A, 'forward');
    % Apply free-form deformation grid in nm space
    target_atr_ft = bspline_trans_points_double(obj.transformations.ft.grid, obj.transformations.ft.spacingConsequent, target_atr);
    % Transform from back from nm space -> voxel space
    target_at_ft = trafoAT_transformArray( target_atr_ft, A, 'inverse');
    
else
    % In case target_at does not match allowed data types, exit with error
    error('Provided target is neither a Skeleton object nor an [N x 3] array')
end

end

