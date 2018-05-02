function obj = registerFreeForm( obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~isfield(obj.skeletons,'lm_at')
    obj = registerAffine( obj );
end

obj.skeletons.lm_at_ft = trafoSkelFTCP(obj.skeletons.lm_at, obj.skeletons.em, obj.controlPoints.matched.xyz_lm_at, obj.controlPoints.matched.xyz_em);

end

