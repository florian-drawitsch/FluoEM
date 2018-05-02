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
checkDownsample = @(x) isinteger(x);
p.addOptional('downsample', defaultDownsample, checkDownsample);

% Parse Inputs
p.parse

% Generate figure
fh = figure
for i = 1:numel(p.Results.include)
    skel = obj.skeletons.(p.Results.include{i});
    skel = skel.downSample([],p.Results.downsample);
    skel.plot;
    hold on
end
daspect([1 1 1])

