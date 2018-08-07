function obj = readFromSkel(obj, skel, skelType, commentPattern, idGenerator)
%READFROMSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('skelType', 'var') || isempty(skelType)
    skelType = 'undefined';
end

if ~exist('commentPattern','var') || isempty(commentPattern)
    commentPattern = '^b\d+$';
end

if ~exist('idGenerator','var') || isempty(idGenerator)
    idGenerator = @(x,y) sprintf('%s_%s', regexprep(x,'^(\w*)_.*$','$1'), y);
end

obj.points.(skelType) = trafo.Cp.parseSkel(skel, commentPattern, idGenerator);

obj.points.(skelType).Properties.UserData.scale = skel.scale;
obj.points.(skelType).Properties.UserData.expname = skel.parameters.experiment.name;

end


