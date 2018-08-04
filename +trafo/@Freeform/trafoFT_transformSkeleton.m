function [ skel ] = trafoFT_transformSkeleton( skel, ffdGrid, ffdSpacing, direction )
%FFD_TRANSFORMSKELETONCLASS Summary of this function goes here
%   Detailed explanation goes here

if ~exist('direction','var') || isempty(direction)
    direction = 'forward';
end

if strcmp(direction,'inverse')
    ffdGrid = - ffdGrid;
end

% Transform all skelIDs
for skelIdx = 1:length(skel.names)    
    
    % Transform nodes
    skel.nodes{skelIdx}(:,1:3) = round(bspline_trans_points_double(ffdGrid,ffdSpacing,skel.nodes{skelIdx}(:,1:3)));
    
    % Transform nodes Num Data All
    skel.nodesNumDataAll{skelIdx}(:,3:5) = skel.nodes{skelIdx}(:,1:3);
    
    % Transform Nodes as struct
    for si = 1:size(skel.nodesAsStruct{skelIdx},2)
        skel.nodesAsStruct{skelIdx}(si).x = num2str(skel.nodes{skelIdx}(si,1));
        skel.nodesAsStruct{skelIdx}(si).y = num2str(skel.nodes{skelIdx}(si,2));
        skel.nodesAsStruct{skelIdx}(si).z = num2str(skel.nodes{skelIdx}(si,3));
    end

end


end

