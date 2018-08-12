function points_ft = applyToArray(obj, points_at)
%APPLYTOARRAY Applies the freeform transformation stored in the objects 
%trafo property to an array of points
%   INPUT:  points_at: [N x 3] double
%               Points to be transformed
%   OUTPUT: points_at_ft: [N x 3] double
%               Freeform transformed points
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

points_ft = trafo.Freeform.transformArray(points_at, obj.trafo.grid, obj.trafo.spacingConsequent, direction);

end

