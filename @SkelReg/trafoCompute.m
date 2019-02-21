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

rowIdx=true(size(1:height(obj.cp.points.matched)))';
% Get the idx of axons to ignore
if ~isempty(obj.cp.ignoreAxons.name)
    for i=1:length(obj.cp.ignoreAxons.name)
        curNameTag=obj.cp.ignoreAxons.name{i};
        switch obj.cp.ignoreAxons.searchMode
            case 'exact'
                rowIdx =rowIdx & ...
                    ~strcmp(obj.cp.points.matched.id, ...
                    curNameTag);
            case 'regexp'
                rowIdx =rowIdx & ~cellfun...
                    (@(x) ~isempty(regexpi(x,curNameTag)), ...
                    obj.cp.points.matched.id);
        end
    end
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

