function obj = trafoComputeAffine( obj, relativeSearchRange )
%TRAFOCOMPUTEAFFINE computes an affine transformation (at) based on  
%matched control point pairs.
% In the forward direction, this transformation maps from lm to em (lm_at) 
% reference space.
% Before executing this method, retrieve matched control points either by
% loading two corresponding lm and em skeletons with control points 
% annotated as comments and parsing those via cpReadFromSkel followed by 
% cpMatch. Alternatively, import an existing set of control points via 
% cpImport.
%   INPUT:  relativeSearchRange (optional): double
%               Specifies the search range relative to the quotient of the
%               two nominal experiment scale vectors in which the numerical 
%               optimization of this initial scale vector should be
%               performed
%               (Default: 1.0)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Set default parameters
if ~exist('relativeSearchRange','var') || isempty(relativeSearchRange)
    relativeSearchRange = 1;
end

% Compute affine transform
obj.transformations.at.trafoMatrix3D = trafoAT_start( ...
    obj.controlPoints.matched.xyz_em, ...
    obj.controlPoints.matched.xyz_lm, ...
    obj.controlPoints.em.Properties.UserData.parameters.scale, ...
    obj.controlPoints.lm.Properties.UserData.parameters.scale, ...
    relativeSearchRange );

% Save transformation parameters
obj.transformations.at.parameters.em = obj.controlPoints.em.Properties.UserData.parameters;
obj.transformations.at.parameters.lm = obj.controlPoints.lm.Properties.UserData.parameters;

end

