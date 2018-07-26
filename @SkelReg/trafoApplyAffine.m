function obj = trafoApplyAffine(obj)
%TRAFOAPPLYAFFINE applies the affine transformation to the (lm) skeleton 
%both found in the object state.
% Before executing this method, compute an affine transformation first via
% the trafoComputeAffine method.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Apply transformation
obj.skeletons.lm_at = trafoApplyAffineExt(obj, obj.skeletons.lm, 'forward', obj.transformations.at.parameters.em.scale);

% Parse control points from skeleton comments
obj.controlPoints.lm_at = SkelReg.comments2table(obj.skeletons.lm_at);

% Match controlPoints 
obj = cpMatch(obj);

end

