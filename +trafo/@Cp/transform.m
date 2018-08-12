function obj = transform(obj, modalityType, trafo, trafoAlias)
%TRANSFORM Transforms a control point table using the provided
%transformation object
%   INPUT:  modalityType: str
%               Modality type specifying the table in the points attribute
%               which should be transformed
%           trafo: transformation (affine or freeform) object
%               Transformation object containing a transformation
%           alias (optional): str
%               Defines an alias for the transformation used as a suffix
%               which is appended to the chosen modalityType and used as a
%               fieldname for the resulting transformed table
%               (Default: 'at' when an affine trafo object is passed,
%               'at_ft' when a freeform trafo object is passed)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Assert modalityType
obj.assertModalityType(modalityType);

% Assert trafo class
cond = @(x) ismember(class(x),{'trafo.Affine', 'trafo.Freeform'});
msg = 'Provided trafo needs to be an object of class Affine or Freeform';
assert(cond(trafo), msg);

% Define alias
if ~exist('trafoAlias', 'var') || isempty(trafoAlias)
    switch class(trafo)
        case 'trafo.Affine'
            trafoAlias = 'at';
        case 'trafo.Freeform'
            trafoAlias = 'at_ft';
    end
end

% Transform points
points = obj.points.(modalityType);
points.xyz = round(trafo.applyToArray(points.xyz));

% Assign to object
obj.points.([modalityType,'_',trafoAlias]) = points;
    
end

