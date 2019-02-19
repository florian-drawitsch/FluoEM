function obj = trafoCompute(obj, trafoType)
%TRAFOCOMPUTE Computes the specified transformation(s) based on the matched
%control points stored in the cp.points attribute
%   INPUT:  trafoType (optional): str
%               Defines the type of transformation to be computed.
%               Allowed types are 'at' and 'at_ft'. Note that a freeform
%               transformation cannot be computed without computing an
%               affine transformation first
%               (Default: 'at')
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('trafoType', 'var') || isempty(trafoType)
    trafoType = 'at';
else
    SkelReg.assertTrafoType(trafoType);
end

% Get the idx of axons to ignore
if ~isempty(obj.cp.ignoreAxons.name)
    switch obj.cp.ignoreAxons.searchMode
        case 'exact'
            rowIdx = ...
                ~strcmp(obj.cp.points.matched.id, ...
                obj.cp.ignoreAxons.name);
        case 'regexp'
            rowIdx = ~cellfun...
                (@(x) ~isempty(regexpi(x, obj.cp.ignoreAxons.name)), ...
                obj.cp.points.matched.id);
    end
else
    rowIdx=true(size(1:height(obj.cp.points.matched)))';
end

switch trafoType
    case 'at'
        obj.assertModalityAvailability('moving', {'cp', 'points'});
        obj.affine = obj.affine.compute( ...
            obj.cp.points.matched.xyz_moving(rowIdx,:), ...
            obj.cp.points.matched.xyz_fixed(rowIdx,:), ...
            obj.cp.points.moving.Properties.UserData.scale, ...
            obj.cp.points.fixed.Properties.UserData.scale, ...
            obj.cp.points.moving.Properties.UserData.dataset, ...
            obj.cp.points.fixed.Properties.UserData.dataset);
        
    case 'at_ft'
        obj.assertModalityAvailability('moving_at', {'cp', 'points'});
        obj.freeform = obj.freeform.compute( ...
            obj.cp.points.matched.xyz_moving_at(rowIdx,:), ...
            obj.cp.points.matched.xyz_fixed(rowIdx,:), ...
            obj.cp.points.moving_at.Properties.UserData.scale, ...
            obj.cp.points.fixed.Properties.UserData.scale, ...
            obj.cp.points.moving_at.Properties.UserData.dataset,...
            obj.cp.points.fixed.Properties.UserData.dataset);
end

end

