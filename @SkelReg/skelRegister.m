function obj = skelRegister(obj)
%REGISTER Summary of this function goes here
%   Detailed explanation goes here

obj.trafoAT = obj.trafoAT.compute( ...
    obj.cp.points.matched.xyz_moving, obj.cp.points.matched.xyz_fixed, ...
    obj.cp.points.moving.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale, ...
    obj.cp.points.moving.Properties.UserData.dataset, obj.cp.points.fixed.Properties.UserData.dataset);

obj.skeletons.moving_at = obj.trafoAT.applyToSkel( obj.skeletons.moving, 'forward');

obj = obj.cpRead('moving_at');

obj.trafoFT = obj.trafoFT.compute( ...
    obj.cp.points.matched.xyz_moving_at, obj.cp.points.matched.xyz_fixed, ...
    obj.cp.points.moving_at.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale, ...
    obj.cp.points.moving_at.Properties.UserData.dataset, obj.cp.points.fixed.Properties.UserData.dataset);

obj.skeletons.moving_at_ft = obj.trafoFT.applyToSkel( obj.skeletons.moving_at, 'forward');

obj = obj.cpRead('moving_at_ft');

end

