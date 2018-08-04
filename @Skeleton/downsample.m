function obj = downsample(obj, treeInds, downsamplefactor)
%DOWNSAMPLE downsamples one or multiple trees
%   INPUT   treeInds (optional): [N x 1] double
%               Index or indices of skeleton tree
%               (Default: all trees)
%           downsamplefactor: The factor by which degree 2 nodes would be
%               downsampled
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

if ~exist('treeIndices','var') || isempty(treeInds)
    treeInds = 1:obj.numTrees();
end

for tr = treeInds
   secondDegreeNodes =find(cell2mat(obj.calculateNodeDegree(tr))==2);
   modWithFactor=@(secondDegreeNodeID) logical(mod(secondDegreeNodeID, downsamplefactor));
   nodesToDelete = secondDegreeNodes(arrayfun(modWithFactor, 1:length(secondDegreeNodes)));
   obj = obj.deleteNodes(tr,nodesToDelete,true);
end

end

