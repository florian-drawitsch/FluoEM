function [pn_diff_table, pn_diff_mean, pn_diff_std] = cpFindOutliers(obj)
%FINDCONTROLPOINTOUTLIERS Computes an control point outlier metric  
%   Computes an outlier metric using the assumption that pairwise
%   euclidean distances between control point pairs should be preserved
%   across imaging modalities. 
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de> 

% pairwise norms are computed between control points of em and lm_at skeletons
pn_em = pnorm( obj.controlPoints.matched.xyz_em, obj.skeletons.em.scale );
pn_lm_at = pnorm( obj.controlPoints.matched.xyz_lm_at, obj.skeletons.lm_at.scale );

% pairwise norm matrix diff indicates potential outliers
pn_diff = abs(pn_lm_at-pn_em);

% column-wise summary stats
pn_diff_means = round(mean(pn_diff,1))';
pn_diff_medians = round(median(pn_diff,1))';
pn_diff_stds = round(std(pn_diff,0,1))';
pn_diff_table = obj.controlPoints.matched;
pn_diff_table.pn_diff_means = pn_diff_means;
pn_diff_table.pn_diff_medians = pn_diff_medians;
pn_diff_table.pn_diff_stds = pn_diff_stds;
pn_diff_table = sortrows(pn_diff_table,'pn_diff_means','descend');

% global summary stats
pn_diff_mean = mean(pn_diff(:));
pn_diff_std = std(pn_diff(:));

end


function pn = pnorm( points, scale )
%PNORM Computes pairwise euclidean distances of 3D points
%   INPUT:  points: [N x 3] array containing points in R^3
%           scale: [1 x 3] array containing absolute voxel sizes [nm]
%   OUTPUT: PN: [N x N] matrix containing pairwise norms of points
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

pointsNM = bsxfun(@times, points, scale);
pn = zeros(size(points,1), size(points,1));
for pi = 1:size(points,1)
   x1 = pointsNM(pi,1); 
   y1 = pointsNM(pi,2); 
   z1 = pointsNM(pi,3); 
   pn(pi,:) = arrayfun(@(x2,y2,z2) sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2), pointsNM(:,1), pointsNM(:,2), pointsNM(:,3));
end

end
