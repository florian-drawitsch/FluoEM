function [ skel ] = trafoAT_transformSkeleton( skel, A, newScale )
% trafo3_transformSkeleton transforms skeleton object using 4x4 transformation matrix A

% Transform all skelIDs
for skelIdx = 1:length(skel.names)    
    
    % Transform nodes
    skel.nodes{skelIdx}(:,1:3) = round(trafoAT_transformArray(skel.nodes{skelIdx}(:,1:3), A, 'forward'));
    
    % Transform nodes Num Data All
    skel.nodesNumDataAll{skelIdx}(:,3:5) = skel.nodes{skelIdx}(:,1:3);
    
    % Transform Nodes as struct
    for si = 1:size(skel.nodesAsStruct{skelIdx},2)
        skel.nodesAsStruct{skelIdx}(si).x = num2str(skel.nodes{skelIdx}(si,1));
        skel.nodesAsStruct{skelIdx}(si).y = num2str(skel.nodes{skelIdx}(si,2));
        skel.nodesAsStruct{skelIdx}(si).z = num2str(skel.nodes{skelIdx}(si,3));
    end

end

if ~exist('newScale','var')
    skel.scale = skel.scale./[A(1,1) A(2,2) A(3,3)];
else
    skel.scale = newScale;
end