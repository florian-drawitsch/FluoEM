function mainPath = setup()
%SETUP Sets the required matlab paths for the FluoEM code
%   OUTPUT: mainPath: str
%               The FluoEM main path
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

mainPath = fileparts(mfilename('fullpath'));
addpath(genpath(mainPath));