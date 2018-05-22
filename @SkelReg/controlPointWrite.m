function obj = controlPointWrite(obj)
%CONTROLPOINT2COMMENTS Writes control points attributes to skeleton
%comments (allowing for export)

skeletons_available = fieldnames(obj.skeletons);

for i = 1:numel(skeletons_available)
    obj.skeletons.(skeletons_available{i}) = SkelReg.table2comments(obj.skeletons.(skeletons_available{i}), obj.controlPoints.(skeletons_available{i}));
end


end

