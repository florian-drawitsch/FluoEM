function obj = cpRead(obj, match, skelTypes)
%READCPSFROMSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('match', 'var') || isempty(match)
    match = 1;
end

if ~exist('skelTypes', 'var') || isempty(skelTypes)
    skelTypes = fieldnames(obj.skeletons);
else
    SkelReg.assertSkelType(skelTypes);
end

for i = 1:numel(skelTypes)
    
    if iscell(skelTypes)
        skelType = skelTypes{i};
    end
    
    obj.cp = obj.cp.readFromSkel(...
        obj.skeletons.(skelType), skelType, ...
        obj.parameters.commentPattern, obj.parameters.idGenerator);
end

if match
    obj.cp = obj.cp.match;
end

end

