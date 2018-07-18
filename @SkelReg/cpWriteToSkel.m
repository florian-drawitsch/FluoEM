function obj = cpWriteToSkel(obj)
%WRITECONTROLPOINTS Writes control points skeleton comments
%   Writes the available control point tables  as comments into the
%   respective skeleton objects, allowing to export any changes made to the
%   internal control point tables to nml files.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

skeletons_available = fieldnames(obj.skeletons);

for i = 1:numel(skeletons_available)
    obj.skeletons.(skeletons_available{i}) = SkelReg.table2comments(obj.skeletons.(skeletons_available{i}), obj.controlPoints.(skeletons_available{i}));
end

end

