function obj = trafoComputeFreeForm( obj, spacingInitial, iterations )
%REGISTERFREEFORM computes the free-form registration of two skeletons
% Computes the free-form transformation (lm_at_ft) of a previously 
% computed affine transformed (lm_at) skeleton using the control points 
% tables stored in the object. When called without an affine transformed
% skeleton available, the trafoComputeAffine method is called first.
%   INPUT:  spacingInitial (optional): int
%               Initial knot spacing used for the b-spline deformation
%           iterations (optional): int
%               Number of bisecting mesh refinement steps for the b-spline
%               deformation
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('spacingInitial','var') || isempty(spacingInitial)
    spacingInitial = 32768;
end

if ~exist('iterations','var') || isempty(iterations)
    iterations = 4;
end

if ~isfield(obj.skeletons,'lm_at') || ~isfield(obj.controlPoints,'lm_at')
    warning([...
        'Skeleton "lm_at" and/or control points "lm_at" not found. ',...
        'Executing trafoApplyAffine first.']);
    if ~isfield(obj.transformations, 'at')
        warning([...
            'Transformation "at" not found. ',...
            'Executing trafoComputeAffine first.']);
        obj = trafoComputeAffine( obj );
    end
    obj = trafoApplyAffine( obj );
end

% Free-Form Transform skelLM_AT to obtain skelLM_AT_FT
[...
    obj.transformations.ft.grid, ...
    obj.transformations.ft.vectorField, ...
    obj.transformations.ft.spacingConsequent, ...
    obj.transformations.ft.spacingInitial] = trafoFT_computeNew(...
        obj.controlPoints.matched.xyz_lm_at, ...
        obj.controlPoints.matched.xyz_em, ...
        obj.controlPoints.lm_at.Properties.UserData.parameters.scale, ...
        obj.controlPoints.em.Properties.UserData.parameters.scale, ...
        spacingInitial, ...
        iterations);
    
obj.transformations.ft.parameters.em = obj.controlPoints.em.Properties.UserData.parameters;
obj.transformations.ft.parameters.lm_at = obj.controlPoints.lm_at.Properties.UserData.parameters;
    

end

