function cpExport( obj, path )
%CPEXPORT Exports control points stored in the controlPoints attribute to a
%mat file
%   INPUT:  path: str
%               Export path for the mat file
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

cp = obj.controlPoints;
save(path, 'cp');

end

