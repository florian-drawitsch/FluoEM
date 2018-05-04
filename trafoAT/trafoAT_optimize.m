function [A, regParams, lsqs, lsqsOpt] = trafoAT_optimize(movingPoints, fixedPoints, scaleVector, relativeSearchRange)

if nargin < 4
    relativeSearchRange = 0.1;
end

% Compute old least Square sum
lsqs = trafoAT_wrapper( movingPoints, fixedPoints, scaleVector );

% Define Closure
func = @(scaleVector) trafoAT_wrapper( movingPoints, fixedPoints, scaleVector );

% Define Search Parameters
A = [];
b = [];
Aeq = [];
beq = [];
lb = scaleVector-scaleVector*relativeSearchRange;
ub = scaleVector+scaleVector*relativeSearchRange;

% Pattern Search
scaleVectorOpt = patternsearch(func, scaleVector, A, b, Aeq, beq, lb, ub);

% Get Trafo for optimal scaleVector
[ A, regParams ] = absorWrapper( movingPoints, fixedPoints, scaleVectorOpt );

% Compute new least Square sum
lsqsOpt = trafoAT_wrapper( movingPoints, fixedPoints, scaleVectorOpt );





