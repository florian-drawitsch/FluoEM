function points_ft = applyToArray(obj, points_at, direction)
%APPLYTOARRAY Applies the freeform transformation stored in the objects 
%trafo property to an array of points
%   INPUT:  points_at: [N x 3] double
%               Points to be transformed
%           direction (optional): str
%               Direction of freeform transformation.
%               'forward' applies the freeform transformation in the forward
%               direction, 'inverse' applies it in the inverse direction
%               (Default: 'forward')
%   OUTPUT: points_at_ft: [N x 3] double
%               Freeform transformed points
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('direction','var') || isempty(direction)
    direction = 'forward';
end

switch direction
    case 'forward'
        grid = obj.trafo.grid;
    case 'inverse'
        grid = obj.trafo.grid - 2*obj.trafo.gridDiff;
end

points_ft = trafo.Freeform.transformArray(points_at, obj.attributes.scale.moving, grid, obj.trafo.spacingConsequent);

end

