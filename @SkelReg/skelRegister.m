function obj = skelRegister(obj, trafoType)
%SKELREGISTER Registers skeletons
% Available registration types are affine (trafoType = 'at') or freeform 
% (the latter of which is always defined relative to a previously computed 
% affine registration, hence the trafoType = 'at_ft'). To constrain the
% registration, matched control points in the cp.points.matched attribute 
% are used.
%   INPUT:  trafoType (optional): str or cell array of str
%               Defines the type of transformation to be carried out.
%               Allowed types are 'at' and 'at_ft'. Note that a freeform
%               registration cannot be performed without a prior affine
%               transformation. Triggering the freeform registration when
%               no affine transformation is available will lead to a forced
%               affine registration before the freeform registration is
%               performed.
%               (Default: {'at', 'at_ft'})
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('trafoType', 'var') || isempty(trafoType)
    trafoType = {'at', 'at_ft'};
else
    SkelReg.assertTrafoType(trafoType);
end

% Trafo type affine
if any(strcmp(trafoType, 'at'))  
    obj = trafoCompute(obj, 'at');
    obj = obj.trafoApply('at', {'cp', 'skel'});
end

% Trafo type freeform
if any(strcmp(trafoType, 'at_ft'))
    obj = trafoCompute(obj, 'at_ft');
    obj = obj.trafoApply('at_ft', {'cp', 'skel'});
end

end

