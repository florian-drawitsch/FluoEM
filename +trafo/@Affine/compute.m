function obj = compute( obj, pointsMoving, pointsFixed, scaleMoving, scaleFixed, datasetMoving, datasetFixed  )
%COMPUTE Summary of this function goes here
%   Detailed explanation goes here

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
%OPTWRAPPER Summary of this function goes here
%   Detailed explanation goes here

A = absorWrapper( pointsMoving, pointsFixed, scaleVector );
[ pointsMovingT ] = trafo.Affine.transformArray( pointsMoving, A);
lsq = (sum(((pointsFixed - pointsMovingT).^2),2)).^0.5;
lsqs = sum(lsq);

end


function [A, regParams ] = absorWrapper( pointsMoving, pointsFixed, scaleVector )
%TRAFO3_ABSORWRAPPER Summary of this function goes here
%   Detailed explanation goes here

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



