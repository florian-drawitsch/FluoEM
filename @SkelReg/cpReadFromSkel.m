function obj = cpReadFromSkel(obj, skelType)
%READCPSFROMSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('skelType', 'var') || isempty(skelType)
    skelTypes = fieldnames(obj.skeletons);
elseif ischar(skelType)
    skelTypes = mat2cell(skelType);
end

for i = 1:numel(skelTypes)
    obj.cp = obj.cp.readFromSkel(obj.skeletons.(skelTypes{i}), skelTypes{i}, obj.parameters.commentPattern, obj.parameters.idGenerator);
end

obj.cp = obj.cp.match;

end

