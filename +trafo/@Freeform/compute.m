function obj = compute(obj, pointsMoving, pointsFixed, scaleMoving, scaleFixed, datasetMoving, datasetFixed, spacingInitial, iterations)
%COMPUTE Computes a 3D freeform transformation
% The freeform transformation is constrained using corresponding control
% point pairs. Note that the freeform transformation is usually defined 
% relative to an already affine ('at') pre-transformed reference.
% Therefore, scaleMoving and scaleFixed should usually be identical.
%   INPUT:  pointsMoving: [N x 3] double
%               Control points annotated in the moving modality
%           pointsFixed: [N x 3] double
%               Control points annotated in the fixed modality
%           scaleMoving: [1 x 3] double
%               Nominal voxel size of the moving modality
%           scaleFixed: [1 x 3] double
%               Nominal voxel size of the fixed modality
%           datasetMoving (optional): str
%               Dataset name of the moving modality
%               (Default: '')
%           datasetFixed (optional): str
%               Dataset name of the fixed modality
%               (Default: '')
%           spacingInitial (optional): double
%               Defines the knot spacing (and therefore, the spatial reach
%               of a given control point pair's influence) with which the
%               deformation mesh fitting is initialized
%           iterations (optional): double
%               Number of bisecting mesh refinement steps to be carried out
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('spacingInitial','var') || isempty(spacingInitial)
    spacingInitial = 32768;
end

if ~exist('iterations','var') || isempty(iterations)
    iterations = 4;
end

% Transform into real world coordinates [nm]
A = diag([scaleMoving, 1]);
pointsMovingR = trafo.Affine.transformArray(pointsMoving, A);
A = diag([scaleFixed, 1]);
pointsFixedR = trafo.Affine.transformArray(pointsFixed, A);

% Compute bounding box
bbox = [min(pointsFixedR,[],1)', max(pointsFixedR,[],1)'];
bbox = [bbox(:,1) - spacingInitial, bbox(:,2) + spacingInitial];

% Compute initial bspline grid
[gridInitial, spacingConsequent] = bspline_wrapper( pointsFixedR, pointsFixedR, bbox(:), spacingInitial, iterations );

% Compute transformation bspline grid
grid = bspline_wrapper( pointsMovingR, pointsFixedR, bbox(:), spacingInitial, iterations );
gridDiff = grid - gridInitial;

% Assign to object
obj.trafo.grid = grid;
obj.trafo.gridDiff = gridDiff;
obj.trafo.spacingInitial = spacingInitial;
obj.trafo.spacingConsequent = spacingConsequent;
obj.attributes.scale.moving = scaleMoving;
obj.attributes.scale.fixed = scaleFixed;
obj.attributes.dataset.moving = datasetMoving;
obj.attributes.dataset.fixed = datasetFixed;

end


function [grid, spacing] = bspline_wrapper( pointsMoving, pointsFixed, bbox, initialSpacing, iterations )

globMin = bbox(1:3);
globMax = bbox(4:6);
globDim = globMax - globMin;
options.Verbose = 0;
options.MaxRef = iterations;
[grid, spacing] = point_registration(globDim+globMin, pointsMoving, pointsFixed, initialSpacing, options);

end