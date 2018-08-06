function [A, regParams, lsqsInit, lsqsOpt] = compute( pointsMoving, pointsFixed, scaleFixed, scaleMoving )
%COMPUTE Summary of this function goes here
%   Detailed explanation goes here

% Compute ratio of nominal scales
scaleVector = scaleMoving./scaleFixed;

% Compute old least Square sum
lsqsInit = optWrapper( pointsMoving, pointsFixed, scaleVector );

% Define Closure
func = @(scaleVector) optWrapper( pointsMoving, pointsFixed, scaleVector );

% Define optimization parameters
options = optimset('MaxIter',1E3);

% Perform optimization
scaleVectorOpt = fminsearch(func, scaleVector, options);

% Get Trafo for optimal scaleVector
[ A, regParams ] = absorWrapper( pointsMoving, pointsFixed, scaleVectorOpt );

% Compute new least Square sum
lsqsOpt = optWrapper( pointsMoving, pointsFixed, scaleVectorOpt );

end


function lsqs = optWrapper( pointsMoving, pointsFixed, scaleVector )
%OPTWRAPPER Summary of this function goes here
%   Detailed explanation goes here

A = absorWrapper( pointsMoving, pointsFixed, scaleVector );
[ pointsMovingT ] = applyAffine( pointsMoving, A);
lsq = (sum(((pointsFixed - pointsMovingT).^2),2)).^0.5;
lsqs = sum(lsq);

end


function [A, regParams ] = absorWrapper( pointsMoving, pointsFixed, scaleVector )
%TRAFO3_ABSORWRAPPER Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(scaleVector)
    A_scale = diag([scaleVector, 1]);
    pointsMovingT = applyAffine( pointsMoving, A_scale);
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


function pointsMovingT = applyAffine(pointsMoving, A)
    pointsMoving = [pointsMoving'; ones([1 size(pointsMoving,1)])];
    pointsMovingT = A*pointsMoving;
    pointsMovingT = pointsMovingT(1:3,:)';
end
