function obj = skelAddTree(obj, nmlFname, target)
%ADDTREE Adds nml as an additional tree to a skeleton stored in the
%skeleton attribute.
%   INPUT:  nmlFname: str
%               Full path to nml file
%           target: str
%               Fieldname of target skeleton in skeleton attribute (e.g. 
%               'em', 'lm', 'lm_at', 'lm_at_ft')
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de

if isfield(obj.skeletons, target)
    obj.skeletons.(target) = obj.skeletons.(target).skelAddTreeFromSkel(Skeleton(nmlFname));
else
    error([target, 'does not exist in .skeletons']);
end

end

