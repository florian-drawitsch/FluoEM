function obj = applyAffine(obj, direction, scaleNew)
%APPLYAFFINE Applies the affine transformation stored in the internal state
%to the stored skeleton object
%           direction: (optional) str
%               Specifies affine transformation direction:
%               'forward' typically means lm -> em
%               'inverse' typically means em -> lm. 
%               (Default: 'forward')
%           scaleNew: (optional) [1x3] double
%               Specifies scale of new reference frame for skeleton
%               objects
%               (Default: Changed to em scale for forward, changed to 
%               lm scale for inverse)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('direction', 'var') || isempty(direction)
    direction = 'forward';
end

if ~exist('scaleNew','var') || ~isa(scaleNew,'numeric') || ~isequal(size(scaleNew), [1 3])
    if strcmp(direction,'forward')
        scaleNew = obj.skeletons.em.scale;
    elseif strcmp(direction,'inverse')
        scaleNew = obj.skeletons.lm.scale;
    end
end

% Apply transformation
if isfield(obj.transformations, 'at')
    obj.skeletons.lm_at = transformAffine( obj, obj.skeletons.lm, direction, scaleNew );
end

% Parse control points from skeleton comments
obj.controlPoints.lm_at = SkelReg.comments2table(obj.skeletons.lm_at);

% Match controlPoints 
obj = cpMatch(obj);

end

