function skel = writeToSkel(skel, points)
%TABLE2COMMENTS Writes the comments contained in a table (e.g. output from
% comments2table) to skeleton node comments
%   INPUT:  skel: skeleton object 
%               Skeleton object representing one or multiple traced 
%               neurites.    
%           points: table
%               Control point table with at least the following variable 
%               names: id, treeName, comment, xyz.
%   OUTPUT: skel: skeleton object
%               Skeleton object representing one or multiple traced 
%               neurites and containing the written comments.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

for treeIdx = 1:skel.numTrees
    
    % Remove comments from skeleton
    skel = skel.clearComments(treeIdx);
    
    % Write comments from table to skeleton
    skel = skel.setComments(treeIdx, points.nodeIdx(points.treeIdx == treeIdx), points.comment(points.treeIdx == treeIdx));

end


