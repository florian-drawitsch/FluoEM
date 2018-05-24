function nmlSplit( inputFname, outputPath, fnameGenerator )
%NMLSPLIT Splits the trees contained in a single .nml file into separate
%.nml files
%   INPUT:  inputFname: (optional) str
%               Full file path to the input .nml file
%               (If no file path is provided, a file selection input dialog 
%               is presented.)
%           outputPath: (optional) str
%               Output directoy for the split .nml files 
%               to be written into. (If not specified, the output files are 
%               written into the directory of the inputFname).
%           fnameGenerator: (optional) str
%               Anonymous function modifying the
%               name string of the trees contained in the input nml to 
%               obtain the respective file names. (Default is the identity
%               function appended to the .nml ending)
%               Example: fnameGenerator = @(x) sprintf('%s_AT.nml', x) 
%               produces the filename by appending _AT.nml to the tree name 
%   Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Get inputFname
if ~exist('inputFname','var') || isempty(inputFname)
    [inputFile, inputPath] = uigetfile('*.nml','Select webKnossos (.nml) file containing multiple skeleton tracings');
    inputFname = fullfile(inputPath,inputFile);
end

% Get output path
if ~exist('outputPath','var') || ~exist(outputPath,'file')
    outputPath = inputPath;
end

if ~exist('fnameGenerator', 'var')
    fnameGenerator = @(x) sprintf('%s.nml', x);
end

% Read nml into Skeleton object
skel = Skeleton(inputFname);

% Write trees to files
for skelIdx = 1:skel.numTrees
   skel.write(fullfile(outputPath, fnameGenerator(skel.names{skelIdx})), skelIdx);
end

end

