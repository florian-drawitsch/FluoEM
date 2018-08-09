function points_ft = applyToArray(obj, points_at)
%APPLYTOARRAY Summary of this function goes here
%   Detailed explanation goes here

points_ft = trafo.Freeform.transformArray(points_at, obj.trafo.grid, obj.trafo.spacingConsequent, direction);

end

