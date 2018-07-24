function obj = skelAddTree(obj, nmlFname, skelName)
%SKELADDTREE Adds nml as an additional tree to a skeleton stored in the
%skeleton attribute.
%   INPUT:  nmlFname: str
%               Full path to nml file
%           skelName: str
%               Fieldname of target skeleton in skeleton attribute (e.g. 
%               'em', 'lm', 'lm_at', 'lm_at_ft')
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de

if isfield(obj.skeletons, skelName)
    obj.skeletons.(skelName) = obj.skeletons.(skelName).addTreeFromSkel(Skeleton(nmlFname));
else
    error([skelName, 'does not exist in .skeletons']);
end

end

