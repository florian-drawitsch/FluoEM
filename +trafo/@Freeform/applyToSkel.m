function skel_at_ft = applyToSkel(obj, skel_at, direction )
%APPLYTOSKEL Applies the freeform transformation stored in the objects 
%trafo property to a skeleton object
%   INPUT:  skel_at: skeleton object
%               Skeleton object to be transformed
%           direction (optional): str
%               Direction of freeform transformation.
%               'forward' applies the freeform transformation in the forward
%               direction, 'inverse' applies it in the inverse direction
%               (Default: 'forward')
%   OUTPUT: skel_at_ft: skeleton object
%               Freeform transformed skeleton object
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

skel_at_ft = trafo.Freeform.transformSkel( skel_at,...
    obj.attributes.scale.moving, grid, obj.trafo.spacingConsequent,...
    obj.trafo.bbox);

end

