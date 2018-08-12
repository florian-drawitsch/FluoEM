function obj = skelAddTree(obj, nmlFname, modalityType)
%SKELADDTREE Adds nml as an additional tree to a skeleton stored in the
%skeleton attribute.
%   INPUT:  nmlFname: str
%               Full path to nml file
%           modalityType: str
%               Modality type of provided nml file. Allowed modalities are:
%               'fixed' (e.g. EM)
%               'moving' (e.g. LM)
%               'moving_at' (e.g. affine transformed LM)
%               'moving_at_ft' (e.g. affine and freeform transformed LM)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de

% Assert modality type
SkelReg.assertModalityType(modalityType)

% Assert modality availability in the skeletons property
obj.assertModalityAvailability(modalityType, 'skeletons')

% Add tree to skeleton modality
obj.skeletons.(modalityType) = obj.skeletons.(modalityType).addTreeFromSkel(Skeleton(nmlFname));

end
