function obj = cpImport( obj, path )
%CPIMPORT Imports control points stored in a mat file into the 
% controlPoints attribute
%   INPUT:  path: str
%               Import path of the mat file
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

obj.controlPoints = load(path);

end

