function reg_error_cp = measureRegErrorCP( obj, reg_type )
%MEASUREREGERRORCP Measures registration error based on control points
% The error is computed as the root mean square of the euclidean distances
% between the EM control points and the respective affine or free-form
% registered EM control points
%   INPUT:  reg_type (optional): str
%               Registration type for which cp based error should be
%               measured. Either 'lm_at' or 'lm_at_ft'
%               (Default: 'lm_at')
%   OUTPUT: reg_error_cp: struct
%               Struct containing the measured errors

if ~exist('reg_type', 'var')
    reg_type = 'lm_at';
end

tree_names_unique = unique(obj.controlPoints.matched.treeName_em);
tree_names_unique_inds = cellfun(@(x) find(strcmp(obj.controlPoints.matched.treeName_em,x)), tree_names_unique, 'Uni',false);

if ismember(['xyz_',reg_type],obj.controlPoints.matched.Properties.VariableNames)
    diffs_cp_at = obj.controlPoints.matched.xyz_em - obj.controlPoints.matched.(['xyz_',reg_type]);
    norms_cp_at = normList(diffs_cp_at, obj.skeletons.em.scale);
    reg_error_cp.all.cp.at = rmsList(norms_cp_at);
    for i = 1:numel(tree_names_unique)
        reg_error_cp.(tree_names_unique{i}).cp.at = rmsList(norms_cp_at(tree_names_unique_inds{i}));
    end  
else
    warning(['No matched cps were found for the registration type ',reg_type,'. Make sure to compute a valid registration first.'])
    reg_error_cp = [];
end

end

