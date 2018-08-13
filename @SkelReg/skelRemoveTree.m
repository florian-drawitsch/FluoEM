function obj = skelRemoveTree( obj, treeName, searchMode, modalityType)
%SKELREMOVETREE Removes tree(s) from skeleton object
% Removes tree(s) with tree names matching the specified tree name or 
% matching the search pattern from the skeleton object of the specified 
% modality
%   INPUT:  treeName: str
%               Tree name or search pattern (see mode) specifying the 
%               tree(s) to be removed
%           searchMode: (optional) str
%               Specify search mode
%               'exact': Exactly matches the comment (Default)
%               'partial': comment is partially contained in a node comment
%               'insensitive': Case-insensitive string matching
%               'regexp': regular expression matching
%           modalityType (optional): str
%               Modality type of provided nml file. Allowed modalities are:
%               'fixed' (e.g. EM)
%               'moving' (e.g. LM)
%               'moving_at' (e.g. affine transformed LM)
%               'moving_at_ft' (e.g. affine and freeform transformed LM)
%               (Default: all available modalities)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de

% Set mode default
if ~exist('searchMode','var') || isempty(searchMode)
    searchMode = 'exact';
end

% Set default modalityMode
if ~exist('modalityType', 'var') || isempty(modalityType)
    modalityType = fieldnames(obj.skeletons);
else
    obj.assertModalityAvailability(modalityType, 'skeletons')
end

% Delete tree(s)
obj.skeletons.(modalityType) = obj.skeletons.(modalityType).deleteTreeWithName(treeName, searchMode);

end
