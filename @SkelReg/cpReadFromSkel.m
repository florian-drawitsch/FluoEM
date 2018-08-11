function obj = cpReadFromSkel(obj, match, modalityType)
%CPREADFROMSKEL Reads control points from skeletons
% Reads control points from comments contained in specified skeleton
% objects stored in the skeletons attribute and matches them if selected.
%   INPUT:  match (optional): boolean
%               If true, control points are matched after reading
%               (Default: true)
%           modalityType: (optional) str or cell array of str
%               Selects from which skeleton modalities should be read.
%               Allowed modality types are
%               'fixed' (e.g. EM)
%               'moving' (e.g. LM)
%               'moving_at' (e.g. affine transformed LM)
%               'moving_at_ft' (e.g. affine and freeform transformed LM)
%               (Default: all modality types available in the skeletons
%               attribute are read)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('match', 'var') || isempty(match)
    match = 1;
end

if ~exist('modalityType', 'var') || isempty(modalityType)
    modalityType = fieldnames(obj.skeletons);
else
    SkelReg.assertModalityType(modalityType);
    if ischar(modalityType)
        modalityType = {modalityType};
    end
end

for i = 1:numel(modalityType)
    obj.cp = obj.cp.readFromSkel(...
        obj.skeletons.(modalityType{i}), modalityType{i}, ...
        obj.parameters.commentPattern, obj.parameters.idGenerator);
end

if match
    obj.cp = obj.cp.match;
end

end

