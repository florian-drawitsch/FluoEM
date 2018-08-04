function corners = getBboxCorners( bbox )
%GETBBOXCORNERS Returns all corners of a given bounding box
%   INPUT:  bbox: [1 x 6] double
%               bbox of format [xmin, ymin, zmin, xwidth, ywidth, zwidth]
%   OUTPUT: corners: [8 x 3] double
%               corners of bbox in format  
%               [   corner000_x, corner000_y, corner000_z; ...
%                   corner001_x; corner001_y, corner001_z; ... 
%                   ...                                     ]
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de

corners = zeros(8,3);

c000 = bbox(1:3);
c111 = bbox(4:6) - bbox(1:3);

corners(1,:) = c000;
corners(8,:) = c111;

corners(2,:) = [c000(1) c000(2) c111(3)];
corners(3,:) = [c000(1) c111(2) c111(3)];
corners(4,:) = [c000(1) c111(2) c000(3)];
corners(5,:) = [c111(1) c000(2) c000(3)];
corners(6,:) = [c111(1) c111(2) c000(3)];
corners(7,:) = [c111(1) c000(2) c111(3)];

end

