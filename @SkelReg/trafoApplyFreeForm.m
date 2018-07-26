function obj = trafoApplyFreeForm(obj)
%TRAFOAPPLYFREEFORM Applies the free-form transformation to the affine
%(pre-)transformed (lm_at) skeleton both found in the object state.
% Before executing this method, compute a free-form transformation first 
% via the trafoComputeFreeForm method.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Apply transformation
obj.skeletons.lm_at_ft = trafoApplyFreeFormExt(obj, obj.skeletons.lm_at, 'forward');

% Parse control points from skeleton comments
obj.controlPoints.lm_at_ft = SkelReg.comments2table(obj.skeletons.lm_at_ft);

% Match controlPoints 
obj = cpMatch(obj);
