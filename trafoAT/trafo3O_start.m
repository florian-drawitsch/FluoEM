function [A, regParams, lsqs, lsqsOpt] = trafo3O_start(movingPoints, fixedPoints, scaleVector, relativeSearchRange)

if nargin < 4
    relativeSearchRange = 0.1;
end

% Compute old least Square sum
lsqs = trafo3O_wrapper( movingPoints, fixedPoints, scaleVector )

% Define Closure
func = @(scaleVector) trafo3O_wrapper( movingPoints, fixedPoints, scaleVector );

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
[ A, regParams ] = trafo3_absorWrapper( movingPoints, fixedPoints, scaleVectorOpt );

% Compute new least Square sum
lsqsOpt = trafo3O_wrapper( movingPoints, fixedPoints, scaleVectorOpt );





