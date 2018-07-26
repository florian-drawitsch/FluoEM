function target_at = trafoApplyAffineExt( obj, target, direction, scaleNew, expNameNew )
%TRAFOAPPLYAFFINEEXT applies the affine transformation found in the 
%object state to an external (lm) skeleton or [Nx3] array
% Use the "trafoComputeAffine" method to obtain such an affine 
% transformation based on matched control points, or import one.
%   INPUT:  target: Skeleton object or [Nx3] double
%               Target skeleton or points
%           direction: (optional) str
%               Specifies affine transformation direction:
%               'forward' typically means lm -> em
%               'inverse' typically means em -> lm. 
%               (Default: 'forward')
%           scaleNew: (optional) [1x3] double
%               Specifies scale of new reference frame for skeleton
%               objects
%               (Default: Changed to em scale for forward, changed to 
%               lm scale for inverse)
%           expNameNew: (optional) str
%               Specifies experiment name of new reference frame for
%               skeleton objects
%               (Default: Changed to em exp name for forward, changed to 
%               lm exp name for inverse)
%   OUTPUT: target_at: Skeleton object or [Nx3] double
%               Transformed skeleton or points
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Perform checks
if ~isfield(obj.transformations, 'at')
    error('No transformation found at obj.transformations.at. Use the trafoComputeAffine method to obtain one.');
end

% Set default values
if ~exist('direction', 'var') || isempty(direction)
    direction = 'forward';
end

if ~exist('scaleNew','var') || ~isa(scaleNew,'numeric') || ~isequal(size(scaleNew), [1 3])
    if strcmp(direction,'forward')
        scaleNew = obj.skeletons.em.scale;
    elseif strcmp(direction,'inverse')
        scaleNew = obj.skeletons.lm.scale;
    end
end

if ~exist('expNameNew', 'var') || ~isempty(expNameNew)
    if strcmp(direction,'forward')
        expNameNew = obj.skeletons.lm.parameters.experiment.name;
    elseif strcmp(direction,'inverse')
        expNameNew = obj.skeletons.em.parameters.experiment.name;
    end
end

if isa(target,'Skeleton')
    % Apply affine transformation to skeleton
    target_at = trafoAT_transformSkeleton( target, obj.transformations.at.trafoMatrix3D, scaleNew, direction );
    target_at.parameters.experiment.name = expNameNew;
    
elseif isa(target, 'numeric') && size(target,2) == 3
    % Apply affine transformation to points
    target_at = trafoAT_transformArray( target, obj.transformations.at.trafoMatrix3D, direction );
    
else
    % In case target_at does not match allowed data types, exit with error
    error('Provided target is neither a Skeleton object nor an [N x 3] array')
end

end

