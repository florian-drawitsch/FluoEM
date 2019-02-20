function [fh, ax] = skelPlot( obj, varargin )
%SKELPLOT Shows skeleton reconstructions or their overlays as a simple 3D
%line plot with various annotations
% The skeletons to be plotted as well as the annotations to be displayed
% can be selected via the varargin arguments.
%   INPUT (varargin: name, value pairs)
%           includeModality (optional): cell array of str
%               Skeleton modalities to be plotted. Depending on the available
%               modalities, valid arguments include
%               {'fixed', 'moving', 'moving_at_ft', 'moving_ft'}. Warning: To
%               be plotted as an overlay, the skeletons need to be in
%               the same reference frame. Therefore, attempting to call
%               skelPlot with {'fixed', 'moving'} included will likely
%               result in a warning and no meaningful overlay.
%               (Default: {'fixed', 'moving_at'} or {'fixed', 'moving_at_ft'}
%               depending on whether 'moving_at_ft' is available)
%           downsample (optional): integer
%               Downsampling factor to be applied to the nodes of the
%               skeleton before plotting it. Increases skelPlotting
%               performance for very large .nml files containing skeletons
%               with thousands of nodes.
%               (Default: 1, meaning no downsampling)
%           cps (optional): boolean
%               Boolean controlling the highlighting control points
%               (Default: true)
%           labels (optional): boolean
%               Boolean controlling the display of control point ids
%               (Default: true)
%           connectCPs (optional): boolean
%               Boolean controlling whether the control points get
%               connected or not
%               (Default: true)
%           cpSize (optional): numeric
%               Gives the size of the control points in the plot
%               (Default: 15)
%   OUTPUT: fh: figure handle
%               Figure handle for the generated skelPlot
%           ax: axis handle
%               Axis handle for the generated skelPlot
%
%   USAGE EXAMPLE:
%   >> skelReg.skelPlot('includeModality',{'fixed','moving_at_ft'},'downsample',2,'labels',false)
%
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Parse Inputs
p = inputParser;

% Include
defaultIncludeModality = {'fixed','moving_at_ft'};
checkIncludeModality = @(x) SkelReg.assertModalityType(x);
p.addOptional('includeModality', defaultIncludeModality, checkIncludeModality);

% Downsample
defaultDownsample = 1;
checkDownsample = @(x) isnumeric(x);
p.addOptional('downsample', defaultDownsample, checkDownsample);

% CPs
defaultCPs = 1;
checkCPs = @(x) islogical(x);
p.addOptional('cps', defaultCPs, checkCPs);

% Labels
defaultLabels = 0;
checkLabels = @(x) islogical(x);
p.addOptional('labels', defaultLabels, checkLabels);

% CPs
defaultCPsize = 15;
checkCPsize = @(x) isnumeric(x);
p.addOptional('cpSize', defaultCPsize, checkCPsize);

% connectCPs
defaultConnectCPs = 0;
checkConnectCPs = @(x) islogical(x);
p.addOptional('connectCPs', defaultConnectCPs, checkConnectCPs);

% Parse Inputs
p.parse(varargin{:})

% Generate colormaps
maxTrees = max(structfun(@(x) numTrees(x), obj.skeletons));
cm_factor = 0.5;
cm_base = lines(maxTrees) * cm_factor;
for i = 1:numel(p.Results.includeModality)
    % Skeletons
    cm_tmp = cm_base .* (cm_factor + i*cm_factor);
    cm_tmp(cm_tmp > 1) = 1;
    cm.skel.(p.Results.includeModality{i}) = cm_tmp;
    % Control Points
    if p.Results.cps && isfield(obj.cp.points,p.Results.includeModality{i})
        cp_skel_inds = cellfun(@(x) find(strcmp(x, obj.skeletons.(p.Results.includeModality{i}).names)), ...
            obj.cp.points.(p.Results.includeModality{i}).treeName);
        cm.cp.(p.Results.includeModality{i}) = zeros(length(cp_skel_inds),3);
        for j = 1:length(cp_skel_inds)
            cm.cp.(p.Results.includeModality{i})(j,:) = cm_tmp(cp_skel_inds(j),:);
        end
    end
end

% Generate figure
for i = 1:numel(p.Results.includeModality)
    skel = obj.skeletons.(p.Results.includeModality{i});
    skel = skel.downsample([],p.Results.downsample);
    % Plot Skeleton
    skel.plot([],cm.skel.(p.Results.includeModality{i}),[],[],[],1);
    hold on;
    % Plot Control points
    if p.Results.cps && isfield(obj.cp.points,p.Results.includeModality{i})
        cps = obj.cp.points.(p.Results.includeModality{i}).xyz;
        scatter3(cps(:,1),cps(:,2),cps(:,3), p.Results.cpSize, ...
            cm.cp.(p.Results.includeModality{i}));
        hold on;
    end
end

% Connect control points
if p.Results.connectCPs
    connectControlPoints(obj)
end

% Plot Labels
if p.Results.labels
    cps = obj.cp.points.matched.xyz_fixed;
    ids = cellfun(@(x) regexprep(x, '^(\w+)(_b\d+)$','$1\\$2'), obj.cp.points.matched.id, 'Uni', false);
    cellfun(@(x,y,z,c) text(x,y,z,c), num2cell(cps(:,1)), num2cell(cps(:,2)), num2cell(cps(:,3)), ids);
end


% Check scales
scales = zeros(numel(p.Results.includeModality),3);
for i = 1:numel(p.Results.includeModality)
    scales(i,:) = obj.skeletons.(p.Results.includeModality{i}).scale;
end
% Note: single scale would fail the condition added an additional condition
if isequal(diff(scales),[0 0 0]) || size(scales,1)==1
    daspect(1./scales(1,:));
else
    daspect([1 1 1]);
    warning('Included skeletons have different scales!');
end

% Get handles and set properties
fh = gcf;
ax = gca;
ax.Color = 'none';

end

function connectControlPoints(obj)
coords=cat(3,obj.cp.points.matched.xyz_fixed,...
    obj.cp.points.matched.xyz_moving_at);

for i=1:size(coords,1)
    % Add 2 so that they are differentiable from the points themselves
    curC=squeeze(coords(i,:,:));
    plot3(curC(1,:),curC(2,:),curC(3,:),'color','k')
    hold on
end
end



