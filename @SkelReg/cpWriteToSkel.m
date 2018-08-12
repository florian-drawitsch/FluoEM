function obj = cpWriteToSkel(obj, modalityType)
%CPWRITETOSKEL Writes control points to skeleton(s)
% Writes the control points stored in the cp attribute to the respective
% skeleton modality stored in the skeleton attribute
%   INPUT:      modalityType: (optional) str or cell array of str
%               Selects the modality from which control points should be
%               read and to which skeleton should those be written
%               Allowed modality types are
%               'fixed' (e.g. EM)
%               'moving' (e.g. LM)
%               'moving_at' (e.g. affine transformed LM)
%               'moving_at_ft' (e.g. affine and freeform transformed LM)
%               (Default: all modality types available in the control
%               points attribute are written to the respective skeletons)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('modalityType', 'var') || isempty(modalityType)
    modalityType = fieldnames(obj.cp.points);
    modalityType(strcmp(modalityType, 'matched')) = [];
else
    SkelReg.assertModalityType(modalityType);
    if ischar(modalityType)
        modalityType = {modalityType};
    end
end

for i = 1:numel(modalityType)
    obj.skeletons.(modalityType{i}) = obj.cp.writeToSkel(modalityType{i}, obj.skeletons.(modalityType{i}));
end

end

