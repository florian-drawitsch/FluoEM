function PN = pnorm( points, scale )
%PNORM Computes pairwise euclidean distances of 3D points
%   INPUT:  points: [N x 3] array containing points in R^3
%           scale: [1 x 3] array containing absolute voxel sizes [nm]
%   OUTPUT: PN: [N x N] matrix containing pairwise norms of points
% Author: florian.drawitsch@brain.mpg.de

pointsNM = bsxfun(@times, points, scale);

PN = zeros(size(points,1), size(points,1));
for pi = 1:size(points,1)
   x1 = pointsNM(pi,1); 
   y1 = pointsNM(pi,2); 
   z1 = pointsNM(pi,3); 
   PN(pi,:) = arrayfun(@(x2,y2,z2) sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2), pointsNM(:,1), pointsNM(:,2), pointsNM(:,3));
end

end

