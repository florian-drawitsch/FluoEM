function skel = adaptScale(skel, scaleNew)
%ADAPTSCALE Adapts the skeleton's scale parameter
%   INPUT:  scaleNew: [1 x 3] double
%               New scale to be set in parameter fields

% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

skel.scale = scaleNew;
skel.parameters.scale.x = sprintf('%3.2f', scaleNew(1));
skel.parameters.scale.y = sprintf('%3.2f', scaleNew(2));
skel.parameters.scale.z = sprintf('%3.2f', scaleNew(3));

end

