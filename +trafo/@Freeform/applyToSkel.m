function skel_ft = applyToSkel(obj, skel, direction )
%APPLYTOSKEL Summary of this function goes here
%   Detailed explanation goes here

if ~exist('direction','var') || isempty(direction)
    direction = 'forward';
end

switch direction
    case 'forward'
        f = +1;
    case 'inverse'
        f = -1;
end
            

for treeIdx = 1: 
    
    % Transform nodes
    skel.nodes{treeIdx}(:,1:3) = round(bspline_trans_points_double(ffdGrid,ffdSpacing,skel.nodes{treeIdx}(:,1:3)));
    
    % Transform nodes Num Data All
    skel.nodesNumDataAll{treeIdx}(:,3:5) = skel.nodes{treeIdx}(:,1:3);
    
    % Transform Nodes as struct
    for si = 1:size(skel.nodesAsStruct{treeIdx},2)
        skel.nodesAsStruct{treeIdx}(si).x = num2str(skel.nodes{treeIdx}(si,1));
        skel.nodesAsStruct{treeIdx}(si).y = num2str(skel.nodes{treeIdx}(si,2));
        skel.nodesAsStruct{treeIdx}(si).z = num2str(skel.nodes{treeIdx}(si,3));
    end

end


end

