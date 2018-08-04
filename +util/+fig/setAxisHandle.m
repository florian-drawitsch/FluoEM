function h = setAxisHandle( h, colorToBlack )
%SETAXISHANDLE Facilitates setting axis properties for print quality
%   INPUT:  h: axis handle
%               Input axis handle
%           colorToBlack: (optional) boolean
%               Makes sure that all axis element colors are set to black
%               (Default: true)
%   OUTPUT: h: axis handle
%               Output axis handle
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('colorToBlack','var') || isempty(colorToBlack)
    colorToBlack = true;
end

set(h,'FontName','Arial')
set(h,'FontSize',10)
set(h,'Box','off')
set(h,'LineWidth',0.5)
set(h,'TickDir','out')
set(h,'XMinorTick','on')
set(h,'YMinorTick','on')
set(h,'TickLength',[0.03 0.075])
if colorToBlack
    set(h,'GridColor',[0 0 0])
    set(h,'MinorGridColor',[0 0 0])
    set(h,'XColor',[0 0 0])
    set(h,'YColor',[0 0 0])
end

end

