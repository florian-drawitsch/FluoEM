function skel_at_ft = applyToSkel(obj, skel_at, direction )
%APPLYTOSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('direction','var') || isempty(direction)
    direction = 'forward';
end

switch direction
    case 'forward'
        grid = obj.trafo.grid;
    case 'inverse'
        grid = obj.trafo.grid - 2*obj.trafo.gridDiff;
end

skel_at_ft = trafo.Freeform.transformSkel( skel_at, obj.attributes.scale.moving, grid, obj.trafo.spacingConsequent );

end

