function obj = trafoComputeAffine( obj, relativeSearchRange )
%TRAFOCOMPUTEAFFINE computes an affine transformation based on the 
%available control points
%   INPUT:  relativeSearchRange (optional): double
%               Specifies the search range relative to the quotient of the
%               two nominal scaling vectors in which the numerical 
%               optimization of the optimal scaling vector should be
%               performed
%               (Default: 1.0)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('relativeSearchRange','var') || isempty(relativeSearchRange)
    relativeSearchRange = 1;
end

obj.transformations.at.trafoMatrix3D = trafoAT_compute( obj.controlPoints.matched.xyz_em, obj.controlPoints.matched.xyz_lm, obj.controlPoints.em.Properties.UserData.parameters.scale, obj.controlPoints.lm.Properties.UserData.parameters.scale, relativeSearchRange );

end

