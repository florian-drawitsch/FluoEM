function points_at = applyToArray(obj, points, direction)
%APPLYTOARRAY Applies the affine transformation stored in the objects trafo
%property to an array of points
%   INPUT:  points: [N x 3] double
%               Points to be transformed
%           direction (optional): str
%               Direction of affine transformation.
%               'forward' applies the affine transformation in the forward
%               direction, 'inverse' applies it in the inverse direction
%               (Default: 'forward')
%   OUTPUT: points_at: [N x 3] double
%               Affine transformed points
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('direction','var')
    direction = 'forward';
end

points_at = trafo.Affine.transformArray(points, obj.trafo.A, direction);

end

