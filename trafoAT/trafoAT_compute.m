function [A, regParams, lsqs, lsqsOpt] = trafoAT_compute(movingPoints, fixedPoints, scaleVector)

% Compute old least Square sum
lsqs = trafoAT_optWrapper( movingPoints, fixedPoints, scaleVector );

% Define Closure
func = @(scaleVector) trafoAT_optWrapper( movingPoints, fixedPoints, scaleVector );

% Define optimization parameters
options = optimset('MaxIter',1E3);

% Perform optimization
scaleVectorOpt = fminsearch(func, scaleVector, options);

% Get Trafo for optimal scaleVector
[ A, regParams ] = absorWrapper( movingPoints, fixedPoints, scaleVectorOpt );

% Compute new least Square sum
lsqsOpt = trafoAT_optWrapper( movingPoints, fixedPoints, scaleVectorOpt );





