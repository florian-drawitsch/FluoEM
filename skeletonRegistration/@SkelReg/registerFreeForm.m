function obj = registerFreeForm( obj, spacingInitial, iterations )
%REGISTERFREEFORM computes the free-form registration of two skeletons
% Computes the free-form transformation (lm_at_ft) of a previously 
% computed affine transformed (lm_at) skeleton using the control points 
% tables stored in the object. When called without an affine transformed
% skeleton available, the registerAffine method is called first.
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

if ~isfield(obj.skeletons,'lm_at')
    obj = registerAffine( obj );
end

% Free-Form Transform skelLM_AT to obtain skelLM_AT_FT
[...
    obj.skeletons.lm_at_ft, ...
    obj.transformations.ft.grid, ...
    obj.transformations.ft.vectorField, ...
    obj.transformations.ft.spacingConsequent, ...
    obj.transformations.ft.spacingInitial] = trafoFT_start(...
        obj.skeletons.lm_at, ...
        obj.skeletons.em, ...
        obj.controlPoints.matched.xyz_lm_at, ...
        obj.controlPoints.matched.xyz_em, ...
        spacingInitial, ...
        iterations);

% Parse control points from skeleton comments
obj.controlPoints.lm_at_ft = SkelReg.comments2table(obj.skeletons.lm_at_ft);

% Match controlPoints 
obj = matchControlPoints(obj);

end

