function obj = registerAffine( obj )
%REGISTER Summary of this function goes here
%   Detailed explanation goes here

% Affine Transform skelLM to obtain skelLM_AT
[obj.skeletons.lm_at, obj.transformations.at.trafoMatrix3D] = trafoAT_start(obj.skeletons.lm, obj.skeletons.em, obj.controlPoints.matched.xyz_lm, obj.controlPoints.matched.xyz_em);

% Parse control points from skeleton comments
obj.controlPoints.lm_at = SkelReg.comments2table(obj.skeletons.lm_at,'lm_at');

% Match EM and LM controlPoints 
obj.controlPoints.matched = innerjoin(obj.controlPoints.matched, obj.controlPoints.lm_at, 'Key', 'id');

end

