function [ output_args ] = rmsSkeletons( skel1, treeIdx1, skel2, treeIdx2, autoTruncate )
%RMSSKELETONS Summary of this function goes here
%   Detailed explanation goes here

figure
skel1.plot(treeIdx1)
hold on
skel2.plot(treeIdx2)


lv = linspace(0,1,intf*2)';
for treeIdx = treeInds
    skelI.edges{treeIdx} = [];
    for edgeIdx = 1:size(skel.edges{treeIdx},1)
        thisEdge = skel.edges{treeIdx}(edgeIdx,:);
        n1 = skel.nodes{treeIdx}(thisEdge(1),1:3);
        n2 = skel.nodes{treeIdx}(thisEdge(2),1:3);
        tmp = unique(n1 + floor((n2 - n1).*lv),'rows');
        nodesAll = [tmp, repmat(skel.nodes{treeIdx}(thisEdge(1),4),size(tmp,1),1)];
        nodesNew = nodesAll(2:end-1,:);
        connectTo = thisEdge(1);
        for nn = 1:size(nodesNew,1)
            [skelI, addedEdge] = addNode(skelI, treeIdx, nodesNew(nn,1:3), connectTo, nodesNew(nn,4));
            connectTo = addedEdge;
        end
        skelI.edges{treeIdx} = [skelI.edges{treeIdx}; [connectTo thisEdge(2)]];
    end
end


end

