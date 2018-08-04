function skel = nmlExtractTrees( inputFname, pattern, outputFname )
%NMLEXTRACTTREES extracts trees from nml
%   Extracts the trees contained in given nml which tree names are
%   matching the provided regular expression pattern
%   INPUT:  inputPath: str
%               Full file path to the input .nml file
%           pattern: str or cell array of str
%               One or multiple regular expression pattern specifying the 
%               tree names to be extracted. For example, '^.*_lm$', 
%               matches only tree names with the suffix '_lm'
%           outputFname: (optional) str
%               Filename or full path of the target .nml file to be
%               written. If empty, the object containing the extracted 
%               trees is returned as output but not written to disk.
%               (Default: '' -> No write)
%   OUTPUT: skel: Skeleton object 
%               Skeleton object containing the extracted trees
%Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~iscell(pattern)
    pattern = {pattern};
end

if exist('outputFname','var') && ~isempty(outputFname)
    write = true;
else
    write = false;
end

% Load skeleton object
skel = Skeleton(inputFname);

% Find matching patterns
include = zeros(skel.numTrees, 1);
for i = 1:numel(pattern)
    include = include | cellfun(@(x) ~isempty(regexpi(x, pattern{i})), skel.names);
end

% Delete remaining trees
skel = skel.deleteTrees(~include);

% Write skeleton object
if write
    skel.write(outputFname);
end
