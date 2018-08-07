function obj = trafoApply(obj, trafoType)
%APPLYAFFINE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('trafoType', 'var') || isempty(trafoType)
    trafoType = 'at';
end

SkelReg.assertTrafoType(trafoType)

switch trafoType
    case 'at'
        obj.skeletons.moving_at = obj.trafoAT.applyToSkel( obj.skeletons.moving, 'forward');
    case 'ft'
        obj.skeletons.moving_ft = obj.trafoFT.applyToSkel( obj.skeletons.moving_at, 'forward');
end

obj = cpReadFromSkel(obj);

end

