function fh = plot( obj, varargin )
%PLOT Shows skeleton reconstructions or their overlays as a simple 3D line
%plot 
%   Detailed explanation goes here

% Parse Inputs
p = inputParser;

% Include
if isfield(obj.skeletons,'lm_at_ft')    
    defaultInclude = {'em','lm_at_ft'};
else 
    defaultInclude = {'em','lm_at'};
end
checkInclude = @(x) ~any(~cellfun(@(y) any(strcmp(fieldnames(obj.skeletons),y)), x));
p.addOptional('include', defaultInclude, checkInclude);

% Downsample
defaultDownsample = 1;
checkDownsample = @(x) isnumeric(x);
p.addOptional('downsample', defaultDownsample, checkDownsample);

% CPs
defaultCPs = 1;
checkCPs = @(x) islogical(x);
p.addOptional('cps', defaultCPs, checkCPs);

% Labels
defaultLabels = 1;
checkLabels = @(x) islogical(x);
p.addOptional('labels', defaultLabels, checkLabels);

% Parse Inputs
p.parse(varargin{:})

% Generate colormaps
maxTrees = max(structfun(@(x) numTrees(x), obj.skeletons));
cm_factor = 0.5;
cm_base = lines(maxTrees) * cm_factor;
for i = 1:numel(p.Results.include)
    % Skeletons
    cm_tmp = cm_base .* (cm_factor + i*cm_factor);
    cm_tmp(cm_tmp > 1) = 1;
    cm.skel.(p.Results.include{i}) = cm_tmp;
    % Control Points
    if p.Results.cps && isfield(obj.controlPoints,p.Results.include{i})
        cp_skel_inds = cellfun(@(x) find(strcmp(x, obj.skeletons.(p.Results.include{i}).names)), obj.controlPoints.(p.Results.include{i}).treeName);
        cm.cp.(p.Results.include{i}) = zeros(length(cp_skel_inds),3);
        for j = 1:length(cp_skel_inds)
            cm.cp.(p.Results.include{i})(j,:) = cm_tmp(cp_skel_inds(j),:);
        end
    end
end

% Generate figure
fh = figure;
for i = 1:numel(p.Results.include)
    skel = obj.skeletons.(p.Results.include{i});
    skel = skel.downSample([],p.Results.downsample);
    % Plot Skeleton
    skel.plot([],cm.skel.(p.Results.include{i}),[],[],[],1);
    hold on;
    % Plot Control points
    if p.Results.cps && isfield(obj.controlPoints,p.Results.include{i})
        cps = obj.controlPoints.(p.Results.include{i}).xyz;
        scatter3(cps(:,1),cps(:,2),cps(:,3), 10, cm.cp.(p.Results.include{i}));
        hold on;
    end
end

% Plot Labels
if p.Results.labels
    cps = obj.controlPoints.em.xyz;
    comments = obj.controlPoints.em.comment;
    cellfun(@(x,y,z,c) text(x,y,z,c), num2cell(cps(:,1)), num2cell(cps(:,2)), num2cell(cps(:,3)), comments);
end

% Check scales
scales = zeros(numel(p.Results.include),3);
for i = 1:numel(p.Results.include)
    scales(i,:) = obj.skeletons.(p.Results.include{i}).scale;
end
if isequal(diff(scales),[0 0 0])
    daspect(scales(1,:));
else
    daspect([1 1 1]);
    warning('Included skeletons have different scales!');
end

