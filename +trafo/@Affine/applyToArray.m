function points_at = applyToArray(obj, points)
%APPLY Summary of this function goes here
%   Detailed explanation goes here

points_at = trafo.Affine.transform(points, obj.trafo.A);

end

