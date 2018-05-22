function skel = table2comments(skel, commentsTable)
%TABLE2COMMENTS Summary of this function goes here
%   Detailed explanation goes here

for treeIdx = 1:skel.numTrees
    
    % Remove comments from skeleton
    skel = skel.clearComments(treeIdx);
    
    % Write comments from table to skeleton
    skel = skel.setComments(treeIdx, commentsTable.nodeIdx(commentsTable.treeIdx == treeIdx), commentsTable.comment(commentsTable.treeIdx == treeIdx));

end

