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

% Check if reg_type is available
if ~isfield(obj.skeletons,reg_type)
    warning(['No matched cps were found for the registration type ',reg_type,'. Make sure to compute a valid registration first.'])
    reg_error_cp = [];
    return;
end

% Get tree information
tree_names_unique = unique(obj.controlPoints.matched.treeName_em);
tree_names_unique_inds = cellfun(@(x) find(strcmp(obj.controlPoints.matched.treeName_em,x)), tree_names_unique, 'Uni',false);
tree_name_stumps = cellfun(@(x) regexprep(x, '^(\w*)_.*$','$1'), tree_names_unique, 'Uni', false);

% Compute reg error
diffs = obj.controlPoints.matched.xyz_em - obj.controlPoints.matched.(['xyz_',reg_type]);
norms = normList(diffs, obj.skeletons.em.scale);

% Construct output
reg_error_cp.all = rmsList(norms);
for i = 1:numel(tree_names_unique)
    reg_error_cp.(tree_name_stumps{i}) = rmsList(norms(tree_names_unique_inds{i}));
end

end

