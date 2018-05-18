function target_at = applyAffine( obj, target, direction )
%APPLYAFFINE  computes the affine transformation of the target
% based on the transformation attribute stored in the internal state
%   Use the "registerAffine" method to obtain such an affine transformation
%   model based on control point pairs, or import one.
%   INPUT:  target: Skeleton object or [Nx3] double
%               Target skeleton or points
%           direction: (optional) str
%               Specifies affine transformation direction:
%               'forward' typically means lm -> em
%               'inverse' typically means em -> lm. 
%               (Default: 'forward')
%   OUTPUT: target_at: Skeleton object or [Nx3] double
%               Transformed skeleton or points
% Author: florian.drawitsch@brain.mpg.de

if ~isfield(obj.transformations, 'at')
    error('No transformation found at obj.transformations.at. Use the registerAffine method to obtain one.');
end

if ~exist('direction', 'var')
    direction = 'forward';
end

if isa(target,'Skeleton')
    % Apply affine transformation to skeleton
    target_at = trafoAT_transformSkeleton( target, obj.transformations.at.trafoMatrix3D, obj.skeletons.em.scale, direction );
    
elseif isa(target, 'numeric') && size(target,2) == 3
    % Apply affine transformation to points
    target_at = trafoAT_transformArray( target, obj.transformations.at.trafoMatrix3D, direction );
    
else
    % In case target_at does not match allowed data types, exit with error
    error('Provided target is neither a Skeleton object nor an [N x 3] array')
end

end

