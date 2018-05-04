function write( obj, path )
%WRITE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('fpath','var')
   path = fileparts(obj.paths.fpathLM); 
end

if isfield(obj.skeletons,'lm_at')
    [~, tmp] = fileparts(obj.paths.fpathLM);
    obj.skeletons.lm_at.write(fullfile(path, [tmp,'_AT.nml']))
end

if isfield(obj.skeletons,'lm_at')
    [~, tmp] = fileparts(obj.paths.fpathLM);
    obj.skeletons.lm_at.write(fullfile(path, [tmp,'_AT_FT.nml']))
end


end

