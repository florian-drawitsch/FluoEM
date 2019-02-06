function paths = tutorial_setup()
%RUN_SETUP Runs the setup method for the example scripts in case it has not
%been executed yet.
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Get path of invoking function 
path_current = fileparts(mfilename('fullpath'));

% Get main path
path_main = fullfile(path_current,'..');

% Cd into main folder and execute setup to make sure it is not shadowed
cd(path_main)
paths = setup();
cd(path_current)

end

