function commentsTable = comments2table(skel, columnSuffix, commentPattern, idGenerator)
%COMMENTS2TABLE Parses skeleton node comments for such matching a 
% regular expression pattern and outputs them as a table
%   INPUT   skel: Skeleton object representing one or multiple neurite
%               tracings in which control points were annotated according
%               to a specific pattern using webKnossos comments
%           commentPattern (optional): (Regex-)Pattern formally describing the
%               comments used to annotate control points.
%               (By default the comments are parsed for occurences of the
%               letter 'b' followed by a numeric index: pattern = 'b\d+')
%           idGenerator (optional): Anonymous function generating a unique
%               id from treeName and comment.
%               (The default idGenerator generates e.g. the id 'tree001_b1'
%               from treeName 'tree001_em' and comment 'b1')
%   OUTPUT  commentsTable: Table with variable names: id, treeName, comment,
%               xyz.
% Author: florian.drawitsch@brain.mpg.de

if ~exist('columnSuffix','var') || isempty(columnSuffix)
    columnSuffix = '';
end

if ~exist('commentPattern','var') || isempty(commentPattern)
    commentPattern = '^b\d+$';
end

if ~exist('idGenerator','var') || isempty(idGenerator)
    idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
end

for treeIdx = 1:skel.numTrees
    commentsAll = {skel.nodesAsStruct{treeIdx}.comment};
    matchInds = find(cellfun(@(x) ~isempty(regexpi(x,commentPattern)),commentsAll))';
    treeName = repmat(skel.names(treeIdx),size(matchInds,1),1);
    comment = commentsAll(matchInds)';
    xyz = skel.nodes{treeIdx}(matchInds,1:3);
    id = cellfun(idGenerator, treeName, comment, 'UniformOutput', false);
    tmp = table(id, treeName, comment, xyz, 'VariableNames', {'id', ['treeName_',columnSuffix], ['comment_',columnSuffix], ['xyz_',columnSuffix]});
    if ~exist('commentsTable','var')
        commentsTable = tmp;
    else
        commentsTable = [commentsTable; tmp];
    end
end

end

