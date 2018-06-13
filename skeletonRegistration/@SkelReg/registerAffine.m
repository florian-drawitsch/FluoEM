function obj = registerAffine( obj )
%REGISTERAFFINE computes the affine transformation lm_at of the lm skeleton
% based on the provided control point pairs
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Affine Transform skelLM to obtain skelLM_AT
[obj.skeletons.lm_at, obj.transformations.at.trafoMatrix3D] = trafoAT_start(obj.skeletons.lm, obj.skeletons.em, obj.controlPoints.matched.xyz_lm, obj.controlPoints.matched.xyz_em);

% Parse control points from skeleton comments
obj.controlPoints.lm_at = SkelReg.comments2table(obj.skeletons.lm_at);

% Match controlPoints 
obj = matchControlPoints(obj);

end

