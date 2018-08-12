function obj = compute( obj, pointsMoving, pointsFixed, scaleMoving, scaleFixed, datasetMoving, datasetFixed  )
%COMPUTE Computes a 3D affine transformation
% The affine transformation is constrained using corresponding control
% point pairs. After establishing a coarse initial transformation based on
% the provided nominal voxel scales, the transformation scale is
% iteratively optimized by minimizing the sum of the squared control point
% pair 2-norms until an optimum is reached.
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
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('datasetMoving', 'var') || isempty(datasetMoving)
    datasetMoving = '';
end

if ~exist('datasetFixed', 'var') || isempty(datasetFixed)
    datasetFixed = '';
end

% Compute ratio of nominal scales
scaleRatioNominal = scaleMoving./scaleFixed;

% Define Optimizer Closure
func = @(scaleVector) optWrapper( pointsMoving, pointsFixed, scaleVector );

% Perform optimization
options = optimset('MaxIter',1E3);
scaleRatioOptimized = fminsearch(func, scaleRatioNominal, options);

% Get Trafo for optimal scaleVector
[ A, regParams ] = absorWrapper( pointsMoving, pointsFixed, scaleRatioOptimized );

% Assign to object
obj.trafo.A = A;
obj.trafo.regParams = regParams;
obj.attributes.scale.ratio.nominal = scaleRatioNominal;
obj.attributes.scale.ratio.optimized = scaleRatioOptimized;
obj.attributes.scale.moving = scaleMoving;
obj.attributes.scale.fixed = scaleFixed;
obj.attributes.dataset.moving = datasetMoving;
obj.attributes.dataset.fixed = datasetFixed;

end


function lsqs = optWrapper( pointsMoving, pointsFixed, scaleVector )

A = absorWrapper( pointsMoving, pointsFixed, scaleVector );
[ pointsMovingT ] = trafo.Affine.transformArray( pointsMoving, A);
lsq = (sum(((pointsFixed - pointsMovingT).^2),2)).^0.5;
lsqs = sum(lsq);

end


function [A, regParams ] = absorWrapper( pointsMoving, pointsFixed, scaleVector )

if exist('scaleVector', 'var')
    A_scale = diag([scaleVector, 1]);
    pointsMovingT = trafo.Affine.transformArray( pointsMoving, A_scale);
    regParams = absor(pointsMovingT', pointsFixed', 'doScale', 0);
    regParams.s = scaleVector;
    A_rot_trans = [regParams.R, regParams.t; 0, 0, 0, 1];       
    A =  A_rot_trans * A_scale;
else
    regParams = absor(pointsMoving',pointsFixed','doScale',1);
    regParams.s = repmat(regParams.s,[1 3]);
    A = regParams.M;
end

end



