function obj = trafoCompute(obj)
%COMPUTEAFFINE Summary of this function goes here
%   Detailed explanation goes here

obj.trafoAT = obj.trafoAT.compute( ...
    obj.cp.points.matched.xyz_moving, obj.cp.points.matched.xyz_fixed, ...
    obj.cp.points.moving.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale );

obj.trafoFT = obj.trafoFT.compute( ...
    obj.cp.points.matched.xyz_moving_at, obj.cp.points.matched.xyz_fixed, ...
    obj.cp.points.moving.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale );

end

