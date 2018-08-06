function [grid, vectorField, spacingConsequent, spacingInitial] = compute(pointsMoving, pointsFixed, scaleMoving, scaleFixed, spacingInitial, iterations)

if ~exist('spacingInitial','var') || isempty(spacingInitial)
    spacingInitial = 32768;
end

if ~exist('iterations','var') || isempty(iterations)
    iterations = 4;
end

% Transform into real world coordinates [nm]
A = diag([scaleMoving, 1]);
pointsMovingR = trafoAT_transformArray(pointsMoving, A);

A = diag([scaleFixed, 1]);
pointsFixedR = trafoAT_transformArray(pointsFixed, A);

% Free-Form Trafo
outerBboxEM = [min(pointsFixedR,[],1)', max(pointsFixedR,[],1)'];
outerBboxEM = [outerBboxEM(:,1) - spacingInitial, outerBboxEM(:,2) + spacingInitial];
grid = trafoFT_compute( pointsFixedR, pointsMovingR, outerBboxEM(:), spacingInitial, iterations );
[gridInitial, spacingConsequent] = trafoFT_compute( pointsFixedR, pointsFixedR, outerBboxEM(:), spacingInitial, iterations );
vectorField = grid - gridInitial;

end


function [O_trans,Spacing,Xreg] = trafoFT_compute( pointsMoving, pointsFixed, bbox, initialSpacing, iterations )
%COMPUTEFREEFORMTRAFO Summary of this function goes here
%   Detailed explanation goes here

globMin = bbox(1:3);
globMax = bbox(4:6);
globDim = globMax - globMin;

options.Verbose = 0;
options.MaxRef = iterations;
[O_trans,Spacing,Xreg] = point_registration(globDim+globMin, pointsMoving, pointsFixed, initialSpacing, options);

end