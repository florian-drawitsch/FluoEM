function [fh, ax] = plotSkels(obj, treeIndsRef, treeIndsTar)
%PLOTSKELS Plots skeletons stored in the object
%   INPUT:  treeIndsRef (optional): int or array of int
%               Tree indices of the reference skeleton to be plotted
%               (Default: all ref tree indices)
%           treeIndsTar (optional): int or array of int
%               Tree indices of the target skeleton to be plotted
%               (Default: all tar tree indices)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('treeIndsRef', 'var') || isempty(treeIndsRef)
    treeIndsRef = 1:obj.skelRef.numTrees;
end

if ~exist('treeIndsTar', 'var') || isempty(treeIndsTar)
    treeIndsTar = 1:obj.skelTar.numTrees;
end

figure
obj.skelRef.plot(treeIndsRef,[1 0 0])
hold on
obj.skelTar.plot(treeIndsTar,[.5 .5 .5])
daspect([1 1 1])

fh = gcf;
ax = gca;

end

