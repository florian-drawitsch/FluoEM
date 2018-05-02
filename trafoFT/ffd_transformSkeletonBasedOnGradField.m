function [ krk_outputT ] = ffd_transformSkeletonBasedOnGradField( krk_output, gradField, gradFieldSpacing, gridSpacing )
%FFD_TRANSFORMSKELETON Performs B-Spline based free form deformation on
%skeleton 

% Transform Skeleton
krk_outputT = krk_output;
for skel = 1:size(krk_output,2)
    nodes = krk_output{1,skel}.nodes(:,1:3);
    
    nodesI = ceil(nodes(:,1:3)*diag(1./gradFieldSpacing));
    
    for node = 1:size(nodes,1)
        nodesT(node,1) = nodes(node,1) + gradField(nodesI(node,1),nodesI(node,2),nodesI(node,3),1);
        nodesT(node,2) = nodes(node,2) + gradField(nodesI(node,1),nodesI(node,2),nodesI(node,3),2);
        nodesT(node,3) = nodes(node,3) + gradField(nodesI(node,1),nodesI(node,2),nodesI(node,3),3);
    end
   
    krk_outputT{1,skel}.nodes(:,1:3) = nodesT;
    krk_outputT{1,skel}.nodesNumDataAll(:,3:5) = nodesT(:,1:3);
    for struct = 1:size(krk_output{1,skel}.nodesAsStruct,2)
        krk_outputT{1,skel}.nodesAsStruct{1,struct}.x = nodesT(struct,1);
        krk_outputT{1,skel}.nodesAsStruct{1,struct}.y = nodesT(struct,2);
        krk_outputT{1,skel}.nodesAsStruct{1,struct}.z = nodesT(struct,3);
    end
end
    


