function points_at = transformArray(points, A, direction)
%POINTSAT applies a 3D transformation to an array of points

if ~exist('direction', 'var')
    direction = 'forward';
end

if strcmp(direction,'inverse')
    A = inv(A);
end

points = [points'; ones([1 size(points, 1)])];
points_at = A * points;
points_at = points_at(1:3, :)';

end

