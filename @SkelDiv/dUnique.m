function du = dUnique( dropToZeroDists, percentile )
%DUNIQUE Computes the uniqueness distance for a given percentile
%   INPUT:  dropToZeroDists: [1 x N] double
%               Euclidean distances from origin after which each given tree
%               lost all of its neighbors (trees never becoming unique are 
%               asserted Inf).
%           percentile: double in interval [0, 100]
%               Percentile for which the uniqueness distance should be
%               computed. For instance, dUnique with percentile = 95 would 
%               compute the distance after which 95% of the trees have lost
%               all of their neighbors
%   OUTPUT: du: double
%               Euclidean uniqeness distance from origin for the given
%               percentile
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Remove non-valid entries
dropToZeroDists(dropToZeroDists==0) = [];
dropToZeroDists(isnan(dropToZeroDists)) = [];

% Get Idx
cutIdx = ceil(numel(dropToZeroDists).*percentile/100);
dropSorted = sort(dropToZeroDists);
du = dropSorted(cutIdx);

end

