function obj = skelAddTree(obj, nmlFname, modalityType)
%SKELADDTREE Adds nml as an additional tree to a skeleton stored in the
%skeleton attribute.
%   INPUT:  nmlFname: str/cell
%               Full path to nml file/s. They should be in cell format
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

% Make sure the nmlFnames are in cell format
if ~iscell(nmlFname)
    nmlFname={nmlFname};
end
for f=1:length(nmlFname)
    % Add tree to skeleton modality
    obj.skeletons.(modalityType) = obj.skeletons.(modalityType). ...
        addTreeFromSkel(Skeleton(nmlFname{f}));
end
end
