function obj = readFromSkel(obj, skel, modalityType, commentPattern, idGenerator)
%READFROMSKEL reads control points from skeleton comments
%   INPUT   skel: Skeleton object
%               Skeleton object representing
%               one or multiple neurite tracings in which control points
%               were annotated according to a specific pattern using
%               webKnossos comments
%           modalityType: str
%               Modality type specifying the field of the points attribute
%               to which the control points table should be assigned
%           commentPattern (optional): str
%               Regular expression pattern specifying the
%               pattern of skeleton comments to be read as
%               control points
%               (Default: commentPattern = '^b\d+$', reads all
%               comments starting with the letter 'b' followed
%               by one or more numeric digits, e.g. b7, b21,
%               etc.)
%           idGenerator (optional): function handle or anonymous
%               function. Defines the rule creating table ids
%               from webKnossos tree names and comments. These
%               table ids are used for the table join
%               operations matching the control point tables of
%               the modalities to be registered.
%               (Default: idGenerator = @(x,y) sprintf(...
%                   '%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y)
%               generates unique cp ids by appending the part
%               of the tree name leading an underscore to the
%               comment. The combination of tree name = 'ax1_lm'
%               and comment 'b1' would lead to an id of
%               'ax1_b1' using the default idGenerator)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('modalityType', 'var') || isempty(modalityType)
    modalityType = 'undefined';
end

if ~exist('commentPattern','var') || isempty(commentPattern)
    commentPattern = '^b\d+$';
end

if ~exist('idGenerator','var') || isempty(idGenerator)
    idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
end

for treeIdx = 1:skel.numTrees
    
    % Parse skeleton comments
    commentsAll = {skel.nodesAsStruct{treeIdx}.comment};
    nodeIdx = find(cellfun(@(x) ~isempty(regexpi(x,commentPattern)),commentsAll))';
    treeInds = repmat(treeIdx,size(nodeIdx,1),1);
    treeName = repmat(skel.names(treeIdx),size(nodeIdx,1),1);
    comment = commentsAll(nodeIdx)';
    xyz = skel.nodes{treeIdx}(nodeIdx,1:3);
    id = cellfun(idGenerator, treeName, comment, 'UniformOutput', false);
    
    % Create temporary table
    tmp = table(id, treeInds, treeName, nodeIdx, comment, xyz, 'VariableNames', {'id', 'treeIdx', 'treeName', 'nodeIdx', 'comment', 'xyz'});
    
    % Create or append to final table
    if ~exist('points','var')
        points = tmp;
    else
        points = [points; tmp];
    end
end

points = sortrows(points);
points.Properties.UserData.scale = skel.scale;
points.Properties.UserData.dataset = skel.parameters.experiment.name;

obj.points.(modalityType) = points;

end

