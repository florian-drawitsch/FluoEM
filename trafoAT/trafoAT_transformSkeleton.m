function [ skel ] = trafoAT_transformSkeleton( skel, A, newScale, direction )
% trafo3_transformSkeleton transforms skeleton object using 4x4 transformation matrix A

if ~exist('direction','var')
    direction = 'forward';
end

if ~exist('newScale','var') || isempty(newScale)
    if strcmp(direction, 'forward')
        skel.scale = skel.scale./diag(A(1:3,1:3))';
    elseif strcmp(direction, 'inverse')
        skel.scale = skel.scale./diag(inv(A(1:3,1:3)))';
    end
else
    skel.scale = newScale;
end

% Transform all skelIDs
for skelIdx = 1:length(skel.names)    
    
    % Transform nodes
    skel.nodes{skelIdx}(:,1:3) = round(trafoAT_transformArray(skel.nodes{skelIdx}(:,1:3), A, direction));
    
    % Transform nodes Num Data All
    skel.nodesNumDataAll{skelIdx}(:,3:5) = skel.nodes{skelIdx}(:,1:3);
    
    % Transform Nodes as struct
    for si = 1:size(skel.nodesAsStruct{skelIdx},2)
        skel.nodesAsStruct{skelIdx}(si).x = num2str(skel.nodes{skelIdx}(si,1));
        skel.nodesAsStruct{skelIdx}(si).y = num2str(skel.nodes{skelIdx}(si,2));
        skel.nodesAsStruct{skelIdx}(si).z = num2str(skel.nodes{skelIdx}(si,3));
    end

end

