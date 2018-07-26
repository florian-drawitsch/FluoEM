function obj = trafoComputeFreeForm( obj, spacingInitial, iterations )
%TRAFOCOMPUTEFREEFORM computes a free-form transformation (ft) based on  
%matched control point pairs. 
% In the forward direction, this transformation maps from em (lm_at) to em 
% (lm_at_ft) reference space
% Before executing this method, retrieve matched control points either by
% loading two corresponding lm_at and em skeletons with control points 
% annotated as comments and parsing those via cpReadFromSkel followed by 
% cpMatch. Alternatively, import an existing set of control points via 
% cpImport. 
% The usual way of obtaining an affine transformed (lm_at) skeleton is to
% load lm and em skeletons and to perform the affine skeleton registration
% workflow (trafoComputeAffine + trafoApplyAffine) first. 
%   INPUT:  spacingInitial (optional): int
%               Initial knot spacing used for the b-spline deformation
%           iterations (optional): int
%               Number of bisecting mesh refinement steps for the b-spline
%               deformation
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Set default parameters
if ~exist('spacingInitial','var') || isempty(spacingInitial)
    spacingInitial = 32768;
end

if ~exist('iterations','var') || isempty(iterations)
    iterations = 4;
end

% Compute free form transformation
[...
    obj.transformations.ft.grid, ...
    obj.transformations.ft.vectorField, ...
    obj.transformations.ft.spacingConsequent, ...
    obj.transformations.ft.spacingInitial] = trafoFT_start(...
        obj.controlPoints.matched.xyz_lm_at, ...
        obj.controlPoints.matched.xyz_em, ...
        obj.controlPoints.lm_at.Properties.UserData.parameters.scale, ...
        obj.controlPoints.em.Properties.UserData.parameters.scale, ...
        spacingInitial, ...
        iterations);

% Save transformation parameters
obj.transformations.ft.parameters.em = obj.controlPoints.em.Properties.UserData.parameters;
obj.transformations.ft.parameters.lm_at = obj.controlPoints.lm_at.Properties.UserData.parameters;
    

end

