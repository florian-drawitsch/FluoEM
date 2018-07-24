function obj = skelRemoveTree( obj, treeName, skelName, mode)
%SKELREMOVETREE Removes tree from skeleton stored in the skeleton attribute.
%   INPUT:  treeName: str
%               Name of tree to be removed
%           skelName: str
%               Fieldname of target skeleton in skeleton attribute (e.g. 
%               'em', 'lm', 'lm_at', 'lm_at_ft')
%           mode: (optional) str
%               Specify search mode
%               'exact': Exactly matches the comment (Default)
%               'partial': comment is partially contained in a node
%                   comment.
%               'insensitive': Case-insensitive string matching
%               'regexp': regular expression matching
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de

if ~exist('mode','var') || isempty(mode)
    mode = 'exact';
end

if isfield(obj.skeletons, skelName)
    obj.skeletons.(skelName) = obj.skeletons.(skelName).deleteTreeWithName(treeName, mode);
else
    error([skelName, 'does not exist in .skeletons']);
end

end

