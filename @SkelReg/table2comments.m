function skel = table2comments(skel, commentsTable)
%TABLE2COMMENTS Writes the comments contained in a table (e.g. output from
% comments2table) to skeleton node comments
%   INPUT:  skel: skeleton object 
%               Skeleton object representing one or multiple traced 
%               neurites.    
%           commentsTable: table
%               Table with variable names: id, treeName, comment, xyz.
%   OUTPUT: skel: skeleton object
%               Skeleton object representing one or multiple traced 
%               neurites and containing the written comments.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

for treeIdx = 1:skel.numTrees
    
    % Remove comments from skeleton
    skel = skel.clearComments(treeIdx);
    
    % Write comments from table to skeleton
    skel = skel.setComments(treeIdx, commentsTable.nodeIdx(commentsTable.treeIdx == treeIdx), commentsTable.comment(commentsTable.treeIdx == treeIdx));

end

