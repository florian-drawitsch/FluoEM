function write(obj, filename, treeIdx, nodeOffset, options)
% Write Skeleton object to nml file.
% INPUT filename: (Optional) string
%           Output filename (.nml will be added automatically).
%           (Default: obj.filename. If the name does exist already than the
%           filename has to be specified to confirm overwrite).
%       treeIdx: (Optional) [Nx1] int
%           Linear indices for the trees to save to nml.
%           (Default: 1:skel.numTrees()).
%       nodeOffset: (Optional) double
%           Offset to the x, y and z coordinates of all nodes.
%           see also constructor
%           (Default: obj.nodeOffset)options.dummy = [];
%filename handling
if ~exist('filename','var') && ~isempty(obj.filename)
    if isempty(obj.filename)
        error('Specify a name for the output file');
    elseif exist([obj.filename, '.nml'],'file')
        error(['File ''%s'' already exists. ', ...
            'Specify the name as input to overwrite it.'], ...
            [obj.filename, '.nml']);
    else
        filename = [obj.filename, '.nml'];
        fprintf('Saving skeleton as %s.\n', filename);
    end
elseif ~strcmp(filename(max(1,end-3):end),'.nml')
    filename = [filename, '.nml'];
end

if ~exist('treeIdx','var') || isempty(treeIdx)
    treeIdx = 1:obj.numTrees();
end
if ~exist('nodeOffset','var') || isempty(nodeOffset)
    nodeOffset = obj.nodeOffset;
    if isempty(nodeOffset) %compatibity with old version
        nodeOffset = 0;
    end
end
if ~exist('options','var') || isempty(options)
    options.useTable=false;
end

if nodeOffset ~= 1 && obj.verbose
    warning('Node offset is set to %d.',nodeOffset);
end
temp = cell(length(treeIdx),1);

% fill in missing colors
fullColors = obj.colors;
if isempty(fullColors) %compatibility with old version
    fullColors = cell(obj.numTrees(),1);
end
fullColorEmpty = cellfun(@isempty, fullColors);
fullColors(fullColorEmpty) = {[1, 0, 0, 1]};

idList = [];
for i= 1:length(treeIdx)
    temp{i}.nodes=obj.nodes{treeIdx(i)};
    temp{i}.name=obj.names{treeIdx(i)};
    temp{i}.color=fullColors{treeIdx(i)};
    temp{i}.edges=obj.edges{treeIdx(i)};
    temp{i}.nodesAsStruct=obj.nodesAsStruct{treeIdx(i)};
    if ~isfield(options, 'useTable') || ~options.useTable
        temp{i}.nodesNumDataAll=obj.nodesNumDataAll{treeIdx(i)};
    else
        temp{i}.nodesNumDataAll=table2array(obj.nodesTable{treeIdx(i)});
    end
    temp{i}.thingID=obj.thingIDs(treeIdx(i));
    if ~isempty(temp{i}.nodesNumDataAll) %in case skel contains empty trees
        idList = [idList;obj.nodesNumDataAll{treeIdx(i)}(:,1)];
    end
end
temp{1}.parameters=obj.parameters;
%sort out branchpoints not in treeIdx
keepBranchpoints = ismember(obj.branchpoints,idList);
temp{1}.branchpoints=obj.branchpoints(keepBranchpoints);
if obj.verbose
    writeNml(filename,temp',nodeOffset);
else
    evalc('writeNml(filename,temp'',nodeOffset)');
end
end
