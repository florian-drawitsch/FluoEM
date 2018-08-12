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
end

SkelReg.assertTrafoType(trafoType);

if any(strcmp(trafoType, 'at'))  
    
    obj.affine = obj.affine.compute( ...
        obj.cp.points.matched.xyz_moving, obj.cp.points.matched.xyz_fixed, ...
        obj.cp.points.moving.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale, ...
        obj.cp.points.moving.Properties.UserData.dataset, obj.cp.points.fixed.Properties.UserData.dataset);    
    obj.skeletons.moving_at = obj.affine.applyToSkel( obj.skeletons.moving, 'forward');
    obj = obj.cpReadFromSkel('moving_at');
    
end

if any(strcmp(trafoType, 'at_ft'))
    
    if ~any(strcmp(fieldnames(obj.cp.points), 'moving_at'))
        warning(['Freeform registration cannot be performed without ',...
            'prior affine registration. Performing affine registration now'])
        obj = obj.skelRegister('at');
    end
    
    obj.freeform = obj.freeform.compute( ...
        obj.cp.points.matched.xyz_moving_at, obj.cp.points.matched.xyz_fixed, ...
        obj.cp.points.moving_at.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale, ...
        obj.cp.points.moving_at.Properties.UserData.dataset, obj.cp.points.fixed.Properties.UserData.dataset);
    obj.skeletons.moving_at_ft = obj.freeform.applyToSkel( obj.skeletons.moving_at, 'forward');
    obj = obj.cpReadFromSkel('moving_at_ft');
    
end

end

