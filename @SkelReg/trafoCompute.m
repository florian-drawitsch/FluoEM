function obj = trafoCompute(obj, trafoType)
%COMPUTEAFFINE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('trafoType', 'var') || isempty(trafoType)
    trafoType = 'at';
end

SkelReg.assertTrafoType(trafoType)

switch trafoType
    case 'at'
        obj.trafoAT = obj.trafoAT.compute( ...
            obj.cp.points.matched.xyz_moving, obj.cp.points.matched.xyz_fixed, ...
            obj.cp.points.moving.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale );
    
    case 'ft'
         obj.trafoFT = obj.trafoFT.compute( ...
            obj.cp.points.matched.xyz_moving_at, obj.cp.points.matched.xyz_fixed, ...
            obj.cp.points.moving.Properties.UserData.scale, obj.cp.points.fixed.Properties.UserData.scale );


end

