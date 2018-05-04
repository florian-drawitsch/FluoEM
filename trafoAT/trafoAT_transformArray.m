function [ movingPointsT ] = trafoAT_transformArray( movingPoints, A, direction )
% Transforms sparse array X (N x 3) according to 4x4 transformation Matrix A.

if nargin < 3
    direction = 'forward';
end

if strmatch(direction,'forward')
    A = A;
elseif strmatch(direction,'inverse')
    A = inv(A);
end

movingPoints = [movingPoints'; repmat(1,[1 size(movingPoints,1)])];
movingPointsT = A*movingPoints;
movingPointsT = movingPointsT(1:3,:)';
end

