function skel = nmlMerge( inputPath, pattern, outputFname )
%NMLMERGE Merges trees of multiple nml files into a single skeleton object
%   Merges all nml files contained in the specified directory and returns
%   them as a skeleton object and/or writes them as a single .nml file 
%   containing the input files as separate trees.
%   INPUT:  inputPath: (optional) str
%               Path to the directory containing the .nml files to be
%               merged
%               (Default: path selection dialog box is opened)
%           pattern: (optional) str
%               Regular expression pattern specifying the nmls to be 
%               merged. For example, pattern = '^.*lm_AT.*$', matches only
%               .nml files having lm_AT somewhere in their filename and
%               merges only those into the target file.
%               (Default: '.*' -> all .nml files on inputPath are merged)
%           outputFname: (optional) str
%               Filename or full path of the target .nml file to be
%               written. If empty, the merged skeleton object is returned
%               as output skel but not written to disk.
%               (Default: '' -> No write)
%   OUTPUT: skel: Skeleton object 
%               Skeleton object containing the merged .nml files as trees
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

% Get input path
if ~exist('inputPath','var') || isempty(inputPath)
    inputPath = uigetdir('','Please choose folder containing .nml files to be merged');
end

% Get output path and filename
if exist('outputFname','var') && ~isempty(outputFname)
    write = true;
    [outputPath, outputName] = fileparts(outputFname);
    if isempty(outputPath)
        outputPath = inputPath;
    end
else
    write = false;
end
    
% Get default pattern
if ~exist('pattern','var') || isempty(pattern)
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
            cr = checkCommonReference(skel, tmp);
            if cr
                skel = skel.addTreeFromSkel(tmp);
            else
                error(['Experiment name and/or scale of ',fnamesMatch{skelIdx},' does not match with ',fnamesMatch{1},'. Merge aborted.']);
            end
        end
    end
    if write
        skel.write(fullfile(outputPath,[outputName,'.nml']));
    end
else
    warning(['No .nml files found to merge matching pattern ',pattern,' at ',inputPath]);
    skel = [];
end

end

% Sanity check for merge compatibility
function cr = checkCommonReference(skelRef, skelTar)
    
    mismatchExp = ~strcmp(skelRef.parameters.experiment.name, skelTar.parameters.experiment.name);
    mismatchScale = ~isequal(skelRef.scale, skelTar.scale);
    
    if any([mismatchExp, mismatchScale])
        cr = false;
    else
        cr = true;
    end

end

