function obj = skelReadFromNml(obj, nmlPath, modalityType)
%SKELREADFROMNML Reads nml file into skeleton object
% Reads the specified nml file into a skeleton object and then
% assigns it to the skeletons attribute of the specified type
%   INPUT:  nmlPath: str
%               Full path to nml file
%           modalityType: str
%               Modality type of provided nml file. Allowed modalities are:
%               'fixed' (e.g. EM)
%               'moving' (e.g. LM)
%               'moving_at' (e.g. affine transformed LM)
%               'moving_at_ft' (e.g. affine and freeform transformed LM)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Test for allowed types
SkelReg.assertModalityType(modalityType);

% Construct skeleton object from nml file
skel = Skeleton(nmlPath);

% Assign to attribues
obj.skeletons.(modalityType) = skel;
obj.parameters.paths.skeletons.(modalityType) = nmlPath;

end

