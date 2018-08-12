function skel_at = applyToSkel(obj, skel, direction)
%APPLYTOSKEL Applies the affine transformation stored in the objects trafo
%property to a skeleton object
%   INPUT:  skel: skeleton object
%               Skeleton object to be transformed
%           direction (optional): str
%               Direction of affine transformation.
%               'forward' applies the affine transformation in the forward
%               direction, 'inverse' applies it in the inverse direction
%               (Default: 'forward')
%   OUTPUT: skel_at: skeleton object
%               Affine transformed skeleton object
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

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

