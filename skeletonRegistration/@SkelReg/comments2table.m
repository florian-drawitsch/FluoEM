function commentsTable = comments2table(skel, commentPattern, idGenerator)
%COMMENTS2TABLE Parses skeleton node comments for such matching a 
% regular expression pattern and outputs them as a table
%   INPUT   skel: Skeleton object 
%               Skeleton object representing one or multiple neurite
%               tracings in which control points were annotated according
%               to a specific pattern using webKnossos comments
%           commentPattern (optional): str
%               (Regex-)Pattern formally describing the comments used to             
%               annotate control points. (By default the comments are 
%               parsed for occurences of the letter 'b' followed by a 
%               numeric index: pattern = 'b\d+')
%           idGenerator (optional): function handle
%               Anonymous function generating a unique id from treeName and 
%               comment. (The default idGenerator = 
%               @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y)
%               generates e.g. the id 'tree001_b1' from treeName 
%               'tree001_em' and comment 'b1')
%   OUTPUT  commentsTable: table
%               Table with variable names: id, treeName, comment, xyz.
% Author: florian.drawitsch@brain.mpg.de

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
    if ~exist('commentsTable','var')
        commentsTable = tmp;
    else
        commentsTable = [commentsTable; tmp];
    end
    
end

end

