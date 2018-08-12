function skel = writeToSkel(obj, modalityType, skel)
%WRITETOSKEL Writes control points to the comments of a skeleton object
%   INPUT:  modalityType: str
%               Modality type specifying the field of the points attribute
%               from which the control points should be written
%           skel: skeleton object
%               Skeleton object into which comments the chosen control 
%               point table contents should be written
%   OUTPUT: skel: skeleton object
%               Skeleton object containing the specified control points as
%               comments
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Assert modalityType
obj.assertModalityType(modalityType);

% Start writing
for treeIdx = 1:skel.numTrees
    
    % Remove comments from skeleton
    skel = skel.clearComments(treeIdx);
    
    % Write comments from table to skeleton
    skel = skel.setComments(treeIdx, ...
        obj.points.(modalityType).nodeIdx(obj.points.(modalityType).treeIdx == treeIdx), ...
        obj.points.(modalityType).comment(obj.points.(modalityType).treeIdx == treeIdx));

end


