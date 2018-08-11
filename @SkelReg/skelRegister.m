function obj = skelRegister(obj, trafoType)
%REGISTER Summary of this function goes here
%   Detailed explanation goes here

if ~exist('trafoType', 'var') || isempty(trafoType)
    trafoType = {'at', 'at_ft'};
end

SkelReg.assertTrafoType(trafoType);

if any(strcmp(trafoType, 'at'))  
    
    obj.trafoAT = obj.trafoAT.compute( ...
        obj.cp.points.matched.xyz_moving, obj.cp.points.matched.xyz_fixed, ...
        obj.cp.points.moving.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale, ...
        obj.cp.points.moving.Properties.UserData.dataset, obj.cp.points.fixed.Properties.UserData.dataset);    
    obj.skeletons.moving_at = obj.trafoAT.applyToSkel( obj.skeletons.moving, 'forward');
    obj = obj.cpReadFromSkel('moving_at');
    
end

if any(strcmp(trafoType, 'at_ft'))
    
    if ~any(strcmp(fieldnames(obj.cp.points), 'moving_at'))
        warning(['Freeform registration cannot be performed without ',...
            'prior affine registration. Performing affine registration now'])
        obj = obj.skelRegister('at');
    end
    
    obj.trafoFT = obj.trafoFT.compute( ...
        obj.cp.points.matched.xyz_moving_at, obj.cp.points.matched.xyz_fixed, ...
        obj.cp.points.moving_at.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale, ...
        obj.cp.points.moving_at.Properties.UserData.dataset, obj.cp.points.fixed.Properties.UserData.dataset);
    obj.skeletons.moving_at_ft = obj.trafoFT.applyToSkel( obj.skeletons.moving_at, 'forward');
    obj = obj.cpReadFromSkel('moving_at_ft');
    
end

end

