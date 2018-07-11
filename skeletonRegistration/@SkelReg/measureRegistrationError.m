function regError = measureRegistrationError( obj )
%MEASUREREGISTRATIONERROR Measures various registration error metrics
%   Detailed explanation goes here

tree_names_unique = unique(obj.controlPoints.matched.treeName_em);
tree_names_unique_inds = cellfun(@(x) find(strcmp(obj.controlPoints.matched.treeName_em,x)), tree_names_unique, 'Uni',false);

% Measure RMS between control points at
if ismember('xyz_lm_at',obj.controlPoints.matched.Properties.VariableNames)
    diffs_cp_at = obj.controlPoints.matched.xyz_em - obj.controlPoints.matched.xyz_lm_at;
    norms_cp_at = normList(diffs_cp_at, obj.skeletons.em.scale);
    regError.all.cp.at = rmsList(norms_cp_at);
    for i = 1:numel(tree_names_unique)
        regError.(tree_names_unique{i}).cp.at = rmsList(norms_cp_at(tree_names_unique_inds{i}));
    end  
end

% Measure RMS between control points at_ft
if ismember('xyz_lm_at',obj.controlPoints.matched.Properties.VariableNames)
    diffs_cp_at_ft = obj.controlPoints.matched.xyz_em - obj.controlPoints.matched.xyz_lm_at_ft;
    norms_cp_at_ft = normList(diffs_cp_at_ft, obj.skeletons.em.scale);
    regError.all.cp.at_ft = rmsList(norms_cp_at_ft);
    for i = 1:numel(tree_names_unique)
        regError.(tree_names_unique{i}).cp.at_ft = rmsList(norms_cp_at_ft(tree_names_unique_inds{i}));
    end  
end







end

