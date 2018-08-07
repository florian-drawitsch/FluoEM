function skel_at = transformSkel( skel, A, scaleNew, direction )
% trafo3_transformSkeleton transforms skeleton object using 4x4 transformation matrix A

if ~exist('direction','var')
    direction = 'forward';
end

if ~exist('scaleNew','var') || isempty(scaleNew)
    switch direction
        case 'forward'
            scaleNew = skel.scale./diag(A(1:3,1:3))';
        case 'inverse'
            scaleNew = skel.scale./diag(inv(A(1:3,1:3)))';
    end
end

skel_at = skel;

% Transform all skelIDs
for skelIdx = 1:length(skel.names)    
    
    nodes = skel.nodes{skelIdx}(:,1:3);
    nodes_at = round(trafo.Affine.transformArray(nodes, A, direction));
    
    % Transform nodes
    skel_at.nodes{skelIdx}(:,1:3) = nodes_at;
    
    % Transform nodes Num Data All
    skel_at.nodesNumDataAll{skelIdx}(:,3:5) = nodes_at;
    
    % Transform Nodes as struct   
    x = cellfun(@num2str,num2cell(nodes_at(:,1)),'UniformOutput',false);
    [skel_at.nodesAsStruct{skelIdx}(:).x] = x{:};
    y = cellfun(@num2str,num2cell(nodes_at(:,2)),'UniformOutput',false);
    [skel_at.nodesAsStruct{skelIdx}(:).y] = y{:};
    z = cellfun(@num2str,num2cell(nodes_at(:,3)),'UniformOutput',false);
    [skel_at.nodesAsStruct{skelIdx}(:).z] = z{:};
    
end

% Adapt Scale
skel_at.scale = scaleNew;
skel_at.parameters.scale.x = sprintf('%3.2f', scaleNew(1));
skel_at.parameters.scale.y = sprintf('%3.2f', scaleNew(2));
skel_at.parameters.scale.z = sprintf('%3.2f', scaleNew(3));
