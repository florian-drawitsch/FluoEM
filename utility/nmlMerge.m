function skel = nmlMerge( inputPath, outputFname, pattern )
%NMLMERGE Merges all .nml files contained in the specified directory and
%writes them as a single .nml file with multiple trees
%   INPUT:  path (optional): Path to the directory containing the .nml 
%               files. (By default, path selection dialog box is opened)
%           fnameTarget (optional): Filename / full path of the target .nml 
%               file to be written. If only filename is provided, the file 
%               is written to the specified input path. (If neither full 
%               path nor filename is provided 'merged.nml' is written to 
%               the specified input path)
%           pattern (optional): Regex pattern specifying the nmls to be 
%               merged. For example, pattern = '^.*lm_AT.*$', matches only
%               .nml files having lm_AT somewhere in their filename and
%               merges only those into the target file.
%   OUTPUT: skel: Skeleton object holding the collected .nml files as trees
% Author: florian.drawitsch@brain.mpg.de

% Get input path
if ~exist('inputPath','var')
    inputPath = uigetdir('','Please choose folder containing .nml files to be merged');
end

% Get output path and filename
if ~exist('outputFname','var')
    outputName = 'merged';
    outputPath = inputPath;
else
    [outputPath, outputName] = fileparts(outputFname);
    if isempty(outputPath)
        outputPath = inputPath;
    end
end
    
% Get default pattern
if ~exist('pattern','var')
    pattern = '.*';
end

% Get (matching) fnames
tmp = dir(fullfile(inputPath,'*.nml'));
fnames = {tmp(:).name};
fnamesMatch = fnames(cellfun(@(x) ~isempty(regexpi(x, pattern)), fnames));

% Merge Skeletons
if ~isempty(fnamesMatch)
    for skelIdx = 1:numel(fnamesMatch)
        tmp = Skeleton(fullfile(inputPath, fnamesMatch{skelIdx}));
        if skelIdx == 1
            skel = tmp;
        else
            skel = skel.addTreeFromSkel(tmp);
        end
    end
    skel.write(fullfile(outputPath,[outputName,'.nml']));
else
    warning(['No .nml files found to merge matching pattern ',pattern,' at ',inputPath])
    skel = [];
end

