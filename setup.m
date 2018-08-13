function paths = setup()
%SETUP Sets and returns relevant FluoEM paths
% Run this method first before starting to work with the FluoEM code
%   OUTPUT: paths: struct
%               Contains relevant project paths
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Retrieve path of invoking function
paths.main = fileparts(mfilename('fullpath'));

% Construct additional relevant paths
paths.data = fullfile(paths.main, 'data');
paths.examples = fullfile(paths.main, 'tutorial');

% Add FluoEM's directory structure to matlab path
addpath(genpath(paths.main));