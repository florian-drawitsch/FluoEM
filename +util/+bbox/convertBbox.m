function bbox = convertBbox( bbox )
%CONVERTBBOX Converts bounding box format
%   Converts bounding box format from 
%       [xmin, ymin, zmin, xwidth, ywidth, zwidth]
%   to
%       [xmin, xmax; ymin, ymax; zmin, zmax]
%   INPUT:  bbox: [1 x 6] double
%               bbox of format [xmin, ymin, zmin, xwidth, ywidth, zwidth]
%   OUTPUT: bbox: [3 x 2] double
%               bbox of format [xmin, xmax; ymin, ymax; zmin, zmax]
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de

bbox = [bbox(1:3); bbox(1:3) + bbox(4:6) - [1 1 1]]';

end

