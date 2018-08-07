function skel_at = applyToSkel(obj, skel, direction)
%APPLYTOSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('direction','var')
    direction = 'forward';
end

switch direction
    case 'forward'
        scaleNew = obj.trafo.scale.fixed;
    case 'inverse'
        scaleNew = obj.trafo.scale.moving;
end

skel_at = trafo.Affine.transformSkel( skel, obj.trafo.A, scaleNew, direction );


end

