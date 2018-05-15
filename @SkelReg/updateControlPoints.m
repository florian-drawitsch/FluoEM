function obj = updateControlPoints( obj )
%UPDATECONTROLPOINTS Summary of this function goes here
%   Detailed explanation goes here

skeletons_available = fieldnames(obj.skeletons);

for i = 1:numel(skeletons_available)
    obj.controlPoints.(skeletons_available{i}) = SkelReg.comments2table(obj.skeletons.(skeletons_available{i}),skeletons_available{i});
end

for i = 1:numel(skeletons_available)-1
    if i == 1
        obj.controlPoints.matched = innerjoin(obj.controlPoints.(skeletons_available{i}), obj.controlPoints.(skeletons_available{i+1}), 'Key', 'id');
    else
        obj.controlPoints.matched = innerjoin(obj.controlPoints.matched, obj.controlPoints.(skeletons_available{i+1}), 'Key', 'id');
    end
end

end