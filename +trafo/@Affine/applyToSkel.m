function skel_at = applyToSkel(obj, skel, direction)
%APPLYTOSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('direction','var')
    direction = 'forward';
end

switch direction
    case 'forward'
        scaleNew = obj.attributes.scale.fixed;
        datasetNew = obj.attributes.dataset.fixed;
    case 'inverse'
        scaleNew = obj.attributes.scale.moving;
        datasetNew = obj.attributes.dataset.moving;
end

skel_at = trafo.Affine.transformSkel( skel, obj.trafo.A, scaleNew, datasetNew, direction );

end

