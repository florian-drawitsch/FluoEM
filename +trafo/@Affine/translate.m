function obj = translate(obj, t)
%TRANSLATE Allows to modify the translative component of the affine 
% transformation matrix stored in the object's trafo property
%   INPUT   t: [3 x 1] double
%               Translation vector (x, y, z) to be added to the translative
%               component of the stored affine transformation matrix         
% Author: Florian.Drawitsch <florian.drawtisch@brain.mpg.de>

% Assert shape
cond = @(x) isequal(size(x), [3 1]);
msg = 't needs to be of shape [3 1]';
assert(cond(t), msg);

% Add translation to trafo Matrix
obj.trafo.A(1:3,4)  = obj.trafo.A(1:3,4) + t;

end

