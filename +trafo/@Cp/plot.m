function [fh, ax] = plot(obj, modalityType)
%PLOT Visualizes the specified control point modalities as a scatter plot
%   INPUT:  modalityType: str or cell array of str
%               Modality type(s) specifying the field of the points 
%               attribute to be plotted. If several modality types are
%               passed as a cell array of str, they are plotted together
%   OUTPUT: fh: figure handle
%               The produced plot's figure handle
%           ax: axis handle
%               The produced plot's axis handle
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

obj.assertModalityType(modalityType);

if ischar(modalityType)
    modalityType = {modalityType};
end

cm = lines(numel(modalityType));

for i = 1:numel(modalityType)
    scatter3(...
        obj.points.(modalityType{i}).xyz(:,1), ...
        obj.points.(modalityType{i}).xyz(:,2), ...
        obj.points.(modalityType{i}).xyz(:,3), ...
        'MarkerEdgeColor', cm(i,:))
    hold on
end

fh = gcf;
ax = gca;

end

