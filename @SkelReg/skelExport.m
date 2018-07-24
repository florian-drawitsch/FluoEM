function skelExport( obj, targetPath )
%WRITE Writes skeletons to nml files
%   By default, all available skeletons stored in the object are written to 
%   files. Single skeletons can be written by using the respective skeleton
%   object's skelExport method. (For example: >> obj.skeletons.em.skelExport)
%   INPUT:  targetPath: (optional) str
%               Path to which nml files should be written.
%               (By default, the nml files are written to the same
%               directory in which the source nml (fpathLM) is stored)
% Author: Florian Drawitsch <florian.drawitsch@brain.mpg.de>

if ~exist('targetPath','var')
   targetPath = fileparts(obj.paths.fpathLM); 
elseif ~exist(targetPath,'file')
    warning([targetPath, ' does not exist, creating new directory at target path'])
    mkdir(targetPath)
end

if isfield(obj.skeletons,'em')
    [~, tmp] = fileparts(obj.paths.fpathEM);
    obj.skeletons.em.write(fullfile(targetPath, [tmp,'.nml']))
end

if isfield(obj.skeletons,'lm')
    [~, tmp] = fileparts(obj.paths.fpathLM);
    obj.skeletons.lm.write(fullfile(targetPath, [tmp,'.nml']))
end

if isfield(obj.skeletons,'lm_at')
    [~, tmp] = fileparts(obj.paths.fpathLM);
    obj.skeletons.lm_at.write(fullfile(targetPath, [tmp,'_AT.nml']))
end

if isfield(obj.skeletons,'lm_at_ft')
    [~, tmp] = fileparts(obj.paths.fpathLM);
    obj.skeletons.lm_at_ft.write(fullfile(targetPath, [tmp,'_AT_FT.nml']))
end

end

