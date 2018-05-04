function obj = registerAffine( obj )
%REGISTER Summary of this function goes here
%   Detailed explanation goes here

% Affine Transform skelLM to obtain skelLM_AT
obj.skeletons.lm_at = trafoAT_start(obj.skeletons.lm, obj.skeletons.em, obj.controlPoints.matched.xyz_lm, obj.controlPoints.matched.xyz_em);

% Parse control points from skeleton comments
obj.controlPoints.lm_at = SkelReg.comments2table(obj.skeletons.lm_at);

% Match EM and LM controlPoints 
obj.controlPoints.matched = SkelReg.joinTables(obj.controlPoints.em, obj.controlPoints.lm_at, 'em', 'lm_at');

end

