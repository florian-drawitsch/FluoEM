function write( obj, targetPath )
%WRITE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('targetPath','var')
   targetPath = fileparts(obj.paths.fpathLM); 
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

