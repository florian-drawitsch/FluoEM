function obj = trafoApply(obj, trafoType, trafoTarget)
%TRAFOCOMPUTE Applies the specified transformation(s) stored in the trafo
%(trafo.affine, trafo.freeform) attribute(s)
%   INPUT:  trafoType (optional): str
%               Defines the type of transformation to be carried out.
%               Allowed types are 'at' and 'at_ft'. Note that a freeform
%               transformation cannot be applied without computing and
%               applying an affine transformation first
%               (Default: 'at')
%           trafoTarget (optional): str or cell array of str
%               Defines the target(s) to which the transformation should be
%               applied. It can be applied to the control points ('cp'), to
%               the skeleton ('skel') or both the control points and
%               skeleton ({'cp', 'skel'} of the respective trafoType source
%               stored in the objects attributes.
%               (Default: {'cp', 'skel'})
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('trafoType', 'var') || isempty(trafoType)
    trafoType = 'at';
else
    SkelReg.assertTrafoType(trafoType);
end

if ~exist('trafoTarget', 'var') || isempty(trafoTarget)
    trafoTarget = {'cp','skel'};
end

obj.assertTrafoAvailability(trafoType);

switch trafoType
    
    % Trafo type affine
    case 'at'
        
        % Trafo target control points
        if any(strcmp(trafoTarget, 'cp'))  
            obj.assertModalityAvailability('moving', {'cp', 'points'});
            obj.cp = obj.cp.transform('moving', obj.affine, 'at');
            obj.cp = obj.cp.match;
        end
        % Trafo target skeleton
        if any(strcmp(trafoTarget, 'skel'))  
            assertSkeletonAvailability(obj, 'moving');
            obj.skeletons.moving_at = obj.affine.applyToSkel...
                (obj.skeletons.moving, 'forward');
        end
        
    % Trafo type freeform
    case 'at_ft'
        
        % Trafo target control points
        if any(strcmp(trafoTarget, 'cp'))  
            obj.assertModalityAvailability('moving_at', {'cp', 'points'});
            obj.cp = obj.cp.transform('moving_at', obj.freeform, 'at_ft');
            obj.cp = obj.cp.match;
        end
        % Trafo target skeleton
        if any(strcmp(trafoTarget, 'skel'))
            assertSkeletonAvailability(obj, 'moving_at');
            obj.skeletons.moving_at_ft = obj.freeform.applyToSkel...
                (obj.skeletons.moving_at, 'forward');
        end
end

end

